import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/widgets/product.item.dart';

import '../widgets/app_drawer.dart';
import '../utils/app_routes.dart';

class ProductsScreen extends StatelessWidget {
  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductProvider>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final products = productsData.items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PRODUCT_FORM,
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.itemsCount,
            itemBuilder: (ctx, i) => Column(
              children: <Widget>[
                ProductItem(products[i]),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
