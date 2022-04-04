import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../screens/manage_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product product;
  const UserProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Product product = Provider.of<Product>(context, listen: false);
    return ListTile(
      style: ListTileStyle.list,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      subtitle: Text(product.description),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              splashRadius: 20,
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).pushNamed(ManageProductScreen.routeName,
                    arguments: product);
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              splashRadius: 20,
              padding: EdgeInsets.zero,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: () async {
                              try {
                                await Provider.of<Products>(
                                  context,
                                  listen: false,
                                ).removeProduct(product.id);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Product removed successfully.",
                                    ),
                                  ),
                                );
                              } catch (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "There is some error occurred while removing product!",
                                    ),
                                  ),
                                );
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Text("Yes"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("No"),
                          ),
                        ],
                        title: const Text(
                          "Are you sure?",
                        ),
                        content: const Text(
                          "Do you want to remove the item form the cart?",
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
