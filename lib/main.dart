import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list_app/repos/shopping_list_repository.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/// ----------
/// App root
/// ----------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(useMaterial3: true),
      home: const ShoppingListScreen(),
    );
  }
}

/// ----------
/// Model
/// ----------
class ShoppingItem {
  final String id;
  final String name;
  final bool isChecked;
  final DateTime createdAt;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.isChecked,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  ShoppingItem copyWith({String? id, String? name, bool? isChecked}) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isChecked: isChecked ?? this.isChecked,
      createdAt: createdAt,
    );
  }
}

/// ----------
/// State Notifier
/// ----------
class ShoppingListNotifier extends StateNotifier<List<ShoppingItem>> {
  final ShoppingListRepository repository;
  final _uuid = const Uuid();

  ShoppingListNotifier({required this.repository}) : super([]) {
    _loadFromFirebase();
  }

  Future<void> _loadFromFirebase() async {
    try {
      state = await repository.fetchList();
    } catch (_) {}
  }

  Future<void> refresh() async {
    state = await repository.fetchList();
  }

  Future<void> addItem(String name) async {
    final item = ShoppingItem(id: _uuid.v4(), name: name, isChecked: false);
    state = [item, ...state];
    await repository.addItem(item);
  }

  Future<void> toggleItem(String id) async {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(isChecked: !item.isChecked) else item,
    ];
    final updatedItem = state.firstWhere((item) => item.id == id);
    await repository.updateItem(updatedItem);
  }

  Future<void> removeItem(String id) async {
    state = state.where((item) => item.id != id).toList();
    await repository.removeItem(id);
  }
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

/// ----------
/// Provider
/// ----------
final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingItem>>(
      (ref) => ShoppingListNotifier(
        repository: ShoppingListRepository(
          baseUrl:
              'https://shopping-list-app-f36c7-default-rtdb.europe-west1.firebasedatabase.app/',
        ),
      ),
    );

/// ----------
/// UI
/// ----------
class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() =>
      _ShoppingListScreenState();
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              try {
                await ref.read(shoppingListProvider.notifier).refresh();
              } catch (e) {
                showMessage(context, 'Failed to refresh: $e');
              }
            },
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
