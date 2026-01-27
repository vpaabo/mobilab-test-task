import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/providers/providers.dart';
import 'helpers/fake_repository.dart';

void main() {
  late ProviderContainer container;
  late FakeShoppingListRepository fakeRepo;

  setUp(() {
    fakeRepo = FakeShoppingListRepository();

    container = ProviderContainer(
      overrides: [
        shoppingListRepositoryProvider.overrideWithValue(fakeRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is empty', () {
    final items = container.read(shoppingListProvider);
    expect(items, isEmpty);
  });

  test('addItem inserts item at the top', () {
    final notifier = container.read(shoppingListProvider.notifier);

    notifier.addItem('Milk');
    notifier.addItem('Bread');

    final items = container.read(shoppingListProvider);

    expect(items.length, 2);
    expect(items.first.name, 'Bread');
    expect(items.last.name, 'Milk');
  });

  test('toggleItem flips isChecked', () {
    final notifier = container.read(shoppingListProvider.notifier);

    notifier.addItem('Eggs');
    final item = container.read(shoppingListProvider).first;

    notifier.toggleItem(item.id);

    final updated = container.read(shoppingListProvider).first;

    expect(updated.isChecked, true);
  });

  test('removeItem removes the item', () {
    final notifier = container.read(shoppingListProvider.notifier);

    notifier.addItem('Cheese');
    final id = container.read(shoppingListProvider).first.id;

    notifier.removeItem(id);

    expect(container.read(shoppingListProvider), isEmpty);
  });

  test('refresh replaces state with repository data', () async {
    final notifier = container.read(shoppingListProvider.notifier);

    fakeRepo.items.addAll([
      ShoppingItem(
        id: '1',
        name: 'Apples',
        isChecked: false,
        createdAt: DateTime.now(),
      ),
    ]);

    await notifier.refresh();

    final items = container.read(shoppingListProvider);
    expect(items.length, 1);
    expect(items.first.name, 'Apples');
  });

}
