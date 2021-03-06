import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/orders.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/utils/app_routes.dart';
import 'package:shop_app/views/auth_home_screen.dart';
import 'package:shop_app/views/cart_screen.dart';
import 'package:shop_app/views/orders_sceen.dart';
import 'package:shop_app/views/product_form_screen.dart';
import 'package:shop_app/views/products_detail_screen.dart';
import 'package:shop_app/views/products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          update: (ctx, auth, previousProducts) => ProductProvider(
            auth.token,
            previousProducts.items,
          ),
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            previousOrders.items,
            auth.userId,
          ),
          create: (_) => Orders(),
        ),
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
        routes: {
          AppRoutes.AUTH_HOME: (ctx) => AuthOrHomeScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
          AppRoutes.PRODUCT_FORM: (cts) => ProductFormScreen(),
        },
      ),
    );
  }
}
