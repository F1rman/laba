import 'package:flutter/material.dart';

class Product {
  final String nameCity;
  final int uid;
  final int date;
  final int orderId;
   int status;
  final String nameProduct;
  final int price;
  final int quantity;
  final int statusOrder;
  final int sum;
  Map<String, dynamic> toJson() => productToJson(this);

  factory Product.fromJson(Map<String, dynamic> json) => productFromJson(json);
  Product(
      {required this.nameCity,
      required this.orderId,
      required this.uid,
      required this.status,
      required this.nameProduct,
      required this.price,
      required this.quantity,
      required this.sum,
      required this.statusOrder,
      required this.date});
}

Map<String, dynamic> productToJson(Product instance) => <String, dynamic>{
      'nameCity': instance.nameCity,
      'date': instance.date,
      'orderId': instance.orderId,
      'uid': instance.uid,
      'status': instance.status,
      'nameProduct': instance.nameProduct,
      'price': instance.price,
      'quantity': instance.quantity,
      'statusOrder': instance.statusOrder,
      'sum': instance.sum,
    };

Product productFromJson(Map<String, dynamic> json) => Product(
      date: json["date"] as int,
      uid: json["uid"] as int,
      nameCity: json["nameCity"] as String,
      nameProduct: json["nameProduct"] as String,
      price: json["price"] as int,
      quantity: json["quantity"] as int,
      status: json["status"] as int,
      statusOrder: json["statusOrder"] as int,
      sum: json["sum"] as int,
      orderId: json["orderId"] as int,
    );
