import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/repository/shopping_list_repository.dart';
import 'package:shopping_list_app/screens/app_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

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
    await repository.addItem(item);
    state = [item, ...state];    
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
