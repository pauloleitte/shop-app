import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/utils/app_routes.dart';
import 'package:shop_app/views/products_detail_screen.dart';
import 'package:shop_app/views/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MaterialApp(
        title: 'ShopApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          accentColor: Colors.redAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen()},
      ),
    );
  }
}
