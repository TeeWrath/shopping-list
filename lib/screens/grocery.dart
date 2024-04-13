import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  List<GroceryItem> _groceryItems = [];
  late Future<List<GroceryItem>> _loadedItems;

  @override
  void initState() {
    super.initState();
    _loadedItems = _loadItems();
  }

  Future<List<GroceryItem>> _loadItems() async {
    final url = Uri.https('shopping-list-66ed5-default-rtdb.firebaseio.com',
        'shopping-list.json');

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw Exception('Fialed to fetch grocery items. Please try again later.');
    }

    if (response.body == 'null') {
      return [];
    }

    final Map<String, dynamic> loadedData = await json.decode(response.body);

    final List<GroceryItem> loadedItems = [];

    for (final item in loadedData.entries) {
      final category = categories.entries
          .firstWhere((catItem) => catItem.value.name == item.value['category'])
          .value;

      loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }
    // setState(() {
    //   _groceryItems = loadedItems;
    //   _isLoading = false;
    // });
    return loadedItems;
  }

  void _addItem() async {
    final newItem = await Navigator.push<GroceryItem>(context,
        MaterialPageRoute(builder: (context) => const NewItemScreen()));

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https('shopping-list-66ed5-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
          actions: [
            IconButton(onPressed: _addItem, icon: const Icon(Icons.add))
          ],
        ),
        body: FutureBuilder(
          future: _loadedItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }

            if (snapshot.data!.isEmpty) {
              const Center(
                  child: Text('Nothing here, try adding grocery items'));
            }

            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx, index) => Dismissible(
                      onDismissed: (direction) {
                        _removeItem(snapshot.data![index]);
                      },
                      key: ValueKey(snapshot.data![index].id),
                      child: ListTile(
                        title: Text(snapshot.data![index].name),
                        leading: Icon(
                          Icons.square,
                          color: snapshot.data![index].category.color,
                        ),
                        trailing:
                            Text(snapshot.data![index].quantity.toString()),
                      ),
                    ));
          },
        ));
  }
}
