import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list_app/main.dart';
import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/repository/shopping_list_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final shoppingListRepositoryProvider = Provider<ShoppingListRepository>((ref) {
  final baseUrl = dotenv.env['FIREBASE_BASE_URL'];

  if (baseUrl == null || baseUrl.isEmpty) {
    throw Exception('FIREBASE_BASE_URL not set in .env');
  }
  return ShoppingListRepository(baseUrl: baseUrl);
});

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingItem>>(
      (ref) => ShoppingListNotifier(
        repository: ref.watch(shoppingListRepositoryProvider),
      ),
    );
