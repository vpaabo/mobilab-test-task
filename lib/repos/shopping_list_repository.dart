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

    // Sort newest-first
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return items;
  }

  Future<void> addItem(ShoppingItem item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/items.json'),
      body: json.encode({
        'name': item.name,
        'isChecked': item.isChecked,
        'createdAt': item.createdAt.toIso8601String(),
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add item');
    }
  }

  Future<void> updateItem(ShoppingItem item) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/items/${item.id}.json'),
      body: json.encode({
        'name': item.name,
        'isChecked': item.isChecked,
        'createdAt': item.createdAt.toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update item');
    }
  }

  Future<void> removeItem(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/items/$id.json'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete item');
    }
  }
}
