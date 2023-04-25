
class Product {
  final String nameCity;
  final int uid;
  final int status;
  final String nameProduct;
  final int price;
  final int quantity;
  final int sum;
  Map<String, dynamic> toJson() => productToJson(this);

  factory Product.fromJson(Map<String, dynamic> json) =>
      productFromJson(json);
  Product(this.nameCity, this.uid, this.status, this.nameProduct, this.price,
      this.quantity, this.sum);
}

Map<String, dynamic> productToJson(Product instance) =>
    <String, dynamic>{
      'nameCity': instance.nameCity,
      'uid': instance.uid,
      'status': instance.status,
      'nameProduct': instance.nameProduct,
      'price': instance.price,
      'quantity': instance.quantity,
      'sum': instance.sum,
    };

Product productFromJson(Map<String, dynamic> json) =>
    Product(
        json["nameCity"] as String,
        json["uid"] as int,
        json["status"] as int,
        json["nameProduct"] as String,
        json["price"] as int,
        json["quantity"] as int,
        json["sum"] as int,
    );

   