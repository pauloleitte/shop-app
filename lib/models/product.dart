import 'dart:convert';

import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  Product(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.imageUrl,
      this.isFavorite});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    imageUrl = json['imageUrl'];
  }

  String toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    data['imageUrl'] = this.imageUrl;
    return json.encode(data);
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
