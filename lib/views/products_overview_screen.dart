import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/enums/filter_options.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/utils/app_routes.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_grid.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Minha Loja"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) => {
                    if (selectedValue == FilterOptions.Favorite)
                      {productProvider.showFavoriteOnly()}
                    else
                      {productProvider.showAll()}
                  },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Somente Favoritos'),
                      value: FilterOptions.Favorite,
                    ),
                    PopupMenuItem(
                      child: Text('Todos'),
                      value: FilterOptions.All,
                    )
                  ]),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
            ),
            builder: (ctx, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child,
            ),
          )
        ],
      ),
      body: ProductGrid(),
      drawer: AppDrawer(),
    );
  }
}
