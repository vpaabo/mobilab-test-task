import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list_app/main.dart';
import 'package:shopping_list_app/providers/providers.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(shoppingListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: Material(
              shape: const CircleBorder(),
              color: Theme.of(context).colorScheme.secondary, // highlight color
              child: IconButton(
                iconSize: 28, // make the icon bigger
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.onSecondary, // dark icon
                ),
                onPressed: () async {
                  try {
                    await ref.read(shoppingListProvider.notifier).refresh();
                  } catch (e) {
                    showMessage(context, 'Failed to refresh: $e');
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller, // persistent controller
                    decoration: const InputDecoration(labelText: 'Add item'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      try {
                        await ref
                            .read(shoppingListProvider.notifier)
                            .addItem(text);
                        _controller.clear();
                      } catch (e) {
                        showMessage(context, 'Failed to add item: $e');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  key: ValueKey(item.id), // prevents checkbox glitches
                  leading: Checkbox(
                    value: item.isChecked,
                    onChanged: (_) async {
                      try {
                        await ref
                            .read(shoppingListProvider.notifier)
                            .toggleItem(item.id);
                      } catch (e) {
                        showMessage(context, 'Failed to toggle item: $e');
                      }
                    },
                  ),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      decoration: item.isChecked
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      try {
                        await ref
                            .read(shoppingListProvider.notifier)
                            .removeItem(item.id);
                      } catch (e) {
                        showMessage(context, 'Failed to remove item: $e');
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
