import 'package:flutter/material.dart';

class Product {
  final String nameCity;
  final int date;
  final int uid;
  final int status;
  final String nameProduct;
  final int price;
  final int quantity;
  final int sum;
  Map<String, dynamic> toJson() => productToJson(this);

  factory Product.fromJson(Map<String, dynamic> json) => productFromJson(json);
  Product(
      {required this.nameCity,
      required this.uid,
      required this.status,
      required this.nameProduct,
      required this.price,
      required this.quantity,
      required this.sum,
      required this.date});
}

Map<String, dynamic> productToJson(Product instance) => <String, dynamic>{
      'nameCity': instance.nameCity,
      'date': instance.date,
      'uid': instance.uid,
      'status': instance.status,
      'nameProduct': instance.nameProduct,
      'price': instance.price,
      'quantity': instance.quantity,
      'sum': instance.sum,
    };

Product productFromJson(Map<String, dynamic> json) => Product(
      date: json["date"] as int,
      nameCity: json["nameCity"] as String,
      nameProduct: json["nameProduct"] as String,
      price: json["price"] as int,
      quantity: json["quantity"] as int,
      status: json["status"] as int,
      sum: json["sum"] as int,
      uid: json["uid"] as int,
    );
