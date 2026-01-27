import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list_app/main.dart';
import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/repository/shopping_list_repository.dart';

final shoppingListRepositoryProvider =
    Provider<ShoppingListRepository>((ref) {
  return ShoppingListRepository(
    baseUrl:
        'https://shopping-list-app-f36c7-default-rtdb.europe-west1.firebasedatabase.app/',
  );
});

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingItem>>(
  (ref) => ShoppingListNotifier(
    repository: ref.watch(shoppingListRepositoryProvider),
  ),
);