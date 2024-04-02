import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/screens/new_item.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  void _addItem() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const NewItemScreen()));
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
        body: ListView.builder(
            itemCount: groceryItems.length,
            itemBuilder: (ctx, index) => ListTile(
                  title: Text(groceryItems[index].name),
                  leading: Icon(
                    Icons.square,
                    color: groceryItems[index].category.color,
                  ),
                  trailing: Text(groceryItems[index].quantity.toString()),
                )));
  }
}
