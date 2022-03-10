import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).items;
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider(
            builder: (ctx) => Product(),
            child: ProductItem(
              product: products[index],
            ),
          );
        },
        padding: EdgeInsets.all(10.0));
  }
}
