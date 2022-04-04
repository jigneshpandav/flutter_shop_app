import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/custom_route.dart';
import '../providers/auth.dart';
import '../screens/auth_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Hello"),
            automaticallyImplyLeading: false,
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("shop"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductsOverviewScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Orders"),
            onTap: () {
              Navigator.of(
                context,
              ).pushReplacement(
                CustomRoute(
                  builder: (ctx) => const OrdersScreen(),
                ),
              );

              // Navigator.of(
              //   context,
              // ).pushReplacementNamed(
              //   OrdersScreen.routeName,
              // );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.local_grocery_store),
            title: const Text("Products"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
