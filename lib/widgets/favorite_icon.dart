import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Product>(
      builder: (ctx, product, child) => IconButton(
        icon: product.isFavorite
            ? Icon(Icons.favorite)
            : Icon(Icons.favorite_outline),
        onPressed: () {
          product.toggleFavoriteStatus();
        },
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
