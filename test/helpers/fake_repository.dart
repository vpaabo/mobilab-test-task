import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/repository/shopping_list_repository.dart';

class FakeShoppingListRepository extends ShoppingListRepository {
  FakeShoppingListRepository() : super(baseUrl: '');

  final List<ShoppingItem> items = [];

  @override
  Future<List<ShoppingItem>> fetchList() async {
    return List.from(items);
  }

  @override
  Future<void> addItem(ShoppingItem item) async {
    items.insert(0, item);
  }

  @override
  Future<void> updateItem(ShoppingItem item) async {
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) items[index] = item;
  }

  @override
  Future<void> removeItem(String id) async {
    items.removeWhere((i) => i.id == id);
  }
}
