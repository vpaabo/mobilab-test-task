import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shopping_list_app/main.dart';

void main() {
  group('ShoppingListNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is empty', () {
      final items = container.read(shoppingListProvider);
      expect(items, isEmpty);
    });

    test('addItem adds a new item', () {
      final notifier =
          container.read(shoppingListProvider.notifier);

      notifier.addItem('Milk');

      final items = container.read(shoppingListProvider);

      expect(items.length, 1);
      expect(items.first.name, 'Milk');
      expect(items.first.isChecked, false);
    });

    test('toggleItem toggles isChecked', () {
      final notifier =
          container.read(shoppingListProvider.notifier);

      notifier.addItem('Bread');
      final itemId =
          container.read(shoppingListProvider).first.id;

      notifier.toggleItem(itemId);

      final updatedItem =
          container.read(shoppingListProvider).first;

      expect(updatedItem.isChecked, true);
    });

    test('removeItem removes the item', () {
      final notifier =
          container.read(shoppingListProvider.notifier);

      notifier.addItem('Eggs');
      final itemId =
          container.read(shoppingListProvider).first.id;

      notifier.removeItem(itemId);

      final items = container.read(shoppingListProvider);
      expect(items, isEmpty);
    });

    test('newly added items appear at the top of the list', () {
  final notifier = container.read(shoppingListProvider.notifier);

  // Add first item
  notifier.addItem('Apples');
  var items = container.read(shoppingListProvider);
  expect(items.length, 1);
  expect(items.first.name, 'Apples');

  // Add second item
  notifier.addItem('Bananas');
  items = container.read(shoppingListProvider);

  expect(items.length, 2);
  expect(items.first.name, 'Bananas');
  expect(items.last.name, 'Apples');
});

  });
}
