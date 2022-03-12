import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/badge.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = "/";

  ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    DateTime pre_backpress = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= const Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if (cantExit) {
          //show snackbar
          const snack = SnackBar(
            content: Text('Press Back button again to Exit'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Products"),
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                print("Selected value from popup menu is $selectedValue");
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showFavoriteOnly = true;
                  } else {
                    _showFavoriteOnly = false;
                  }
                });
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  child: Text("Only favorites"),
                  value: FilterOptions.Favorites,
                ),
                const PopupMenuItem(
                  child: Text("Show all"),
                  value: FilterOptions.All,
                )
              ],
              icon: const Icon(Icons.more_vert),
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                value: '${cart.itemCount}',
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    print('${cart.itemCount}');
                  },
                ),
              ),
            ),
          ],
        ),
        body: ProductsGrid(showFavoriteOnly: _showFavoriteOnly),
      ),
    );
  }
}
