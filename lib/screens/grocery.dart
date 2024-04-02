import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
        ),
        body: ListView.builder(
            itemCount: groceryItems.length,
            itemBuilder: (ctx, index) => Dismissible(
                key: ValueKey(groceryItems[index]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.square,
                            color: groceryItems[index].category.color,
                          ),
                          Text(groceryItems[index].name),
                        ],
                      ),
                      Text(groceryItems[index].quantity.toString())
                    ],
                  ),
                ))));
  }
}
