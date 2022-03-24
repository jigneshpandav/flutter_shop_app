import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart' as _oi;

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchOrders(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) {
                  return ListView.builder(
                    itemBuilder: (ctx, index) {
                      return _oi.OrderItem(order: orderData.orders[index]);
                    },
                    itemCount: orderData.orders.length,
                  );
                },
              );
            }
          },
        ));
  }
}
