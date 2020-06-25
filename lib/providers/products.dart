import 'package:flutter/material.dart';
import 'package:shop_app/data/dummy_data.dart';
import 'package:shop_app/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PROODUCTS;

  List<Product> get items => [..._items];

  void addProduct(Product product){
    _items.add(product);
    notifyListeners();
  }

}
