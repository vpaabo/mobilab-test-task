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

  ShoppingListNotifier({required this.repository}) : super([]) {
    _loadFromFirebase();
  }

  final _uuid = const Uuid();

  Future<void> _loadFromFirebase() async {
    try {
      state = await repository.fetchList();
    } catch (_) {
      state = [];
    }
  }

  Future<void> addItem(String name) async {
    final item = ShoppingItem(id: _uuid.v4(), name: name, isChecked: false);
    state = [item, ...state];
    await repository.addItem(item);
  }

  Future<void> toggleItem(String id) async {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(isChecked: !item.isChecked)
        else
          item
    ];
    final updatedItem = state.firstWhere((item) => item.id == id);
    await repository.updateItem(updatedItem);
  }

  Future<void> removeItem(String id) async {
    state = state.where((item) => item.id != id).toList();
    await repository.removeItem(id);
  }
}
/// ----------
/// Provider
/// ----------
final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingItem>>(
  (ref) => ShoppingListNotifier(
    repository: ShoppingListRepository(
      baseUrl: 'https://shopping-list-app-f36c7-default-rtdb.europe-west1.firebasedatabase.app/',
    ),
  ),
);

/// ----------
/// UI
/// ----------
class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(shoppingListProvider);
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration:
                        const InputDecoration(labelText: 'Add item'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isNotEmpty) {
                      ref.read(shoppingListProvider.notifier).addItem(text);
                      controller.clear();
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
                  leading: Checkbox(
                    value: item.isChecked,
                    onChanged: (_) {
                      ref
                          .read(shoppingListProvider.notifier)
                          .toggleItem(item.id);
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
                    onPressed: () {
                      ref
                          .read(shoppingListProvider.notifier)
                          .removeItem(item.id);
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
