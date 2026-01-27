import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';

class ShoppingListRepository {
  final String baseUrl;

  ShoppingListRepository({required this.baseUrl});

  Future<List<ShoppingItem>> fetchList() async {
    final response = await http.get(Uri.parse('$baseUrl/items.json'));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch shopping list');
    }

    final data = json.decode(response.body) as Map<String, dynamic>?;
    if (data == null) return [];

    final items = data.entries.map((e) {
      final value = e.value as Map<String, dynamic>;
      return ShoppingItem(
        id: e.key,
        name: value['name'],
        isChecked: value['isChecked'],
        createdAt: DateTime.parse(value['createdAt']),
      );
    }).toList();

    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return items;
  }

  Future<void> addItem(ShoppingItem item) async {
    await http.put(
      Uri.parse('$baseUrl/items/${item.id}.json'),
      body: json.encode({
        'name': item.name,
        'isChecked': item.isChecked,
        'createdAt': item.createdAt.toIso8601String(),
      }),
    );
  }

  Future<void> updateItem(ShoppingItem item) async {
    await http.patch(
      Uri.parse('$baseUrl/items/${item.id}.json'),
      body: json.encode({
        'name': item.name,
        'isChecked': item.isChecked,
        'createdAt': item.createdAt.toIso8601String(),
      }),
    );
  }

  Future<void> removeItem(String id) async {
    await http.delete(Uri.parse('$baseUrl/items/$id.json'));
  }
}
