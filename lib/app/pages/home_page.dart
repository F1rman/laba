import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laba/app/controllers/firestore.dart';
import 'package:laba/app/storage/storage.dart';
import 'package:laba/app/widgets/modal_add_new_item.dart';

import '../models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Product> products = [];
  late List<Product> filteredProducts = [];
  var firestore = Get.find<FirestoreController>();
  final List<String> category = [
    'Дата',
    'название города',
    'uid',
    'статус',
    'название товара',
    'цена',
    'кол-во',
    'полная стоимость лота',
    'действия',
  ];

  @override
  void initState() {
    products = json
        .decode(Storage.getValue('products') ?? '[]')
        .map<Product>((item) => Product.fromJson(item))
        .toList();
    filteredProducts = products;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Table')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search),
                    Container(
                      width: 200,
                      margin: EdgeInsets.only(left: 20),
                      child: TextField(
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            filteredProducts = products;
                            setState(() {});
                            return;
                          }
                          filteredProducts = products
                              .where(
                                  (element) => element.nameCity.contains(value))
                              .toList();
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => Text('${firestore.userDataModel.value.name}')),
              DataTable(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  columns: category.map((item) {
                    return DataColumn(
                      label: Container(
                        child: Text(item),
                      ),
                    );
                  }).toList(),
                  rows: filteredProducts
                      .map(
                        (item) => DataRow(
                          color: MaterialStateColor.resolveWith(
                            (states) {
                              if (item.status == 1) {
                                return Colors.green.shade100;
                              } else {
                                return Colors.white;
                              }
                            },
                          ),
                          cells: [
                            DataCell(
                              Text(
                                  '${DateTime.fromMillisecondsSinceEpoch(item.date).toLocal()}'),
                            ),
                            DataCell(
                              Text(item.nameCity),
                            ),
                            DataCell(
                              Text(item.uid.toString()),
                            ),
                            DataCell(
                              Text(item.status.toString()),
                            ),
                            DataCell(
                              Text(item.nameProduct),
                            ),
                            DataCell(
                              Text(item.price.toString()),
                            ),
                            DataCell(
                              Text(item.quantity.toString()),
                            ),
                            DataCell(
                              Text(item.sum.toString()),
                            ),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  onPressed: () => {
                                    setState(() {
                                      if (item.status == 1) {
                                        item.status = 0;
                                      } else {
                                        item.status = 1;
                                      }
                                      var newProducts = products
                                          .map((Product item) => item.toJson())
                                          .toList();

                                      Storage.saveValue(
                                          'products', json.encode(newProducts));
                                    })
                                  },
                                  icon: Icon(item.status == 1
                                      ? Icons.sell_rounded
                                      : Icons.sell_outlined),
                                  color: Colors.green,
                                ),
                                IconButton(
                                  onPressed: () => {
                                    setState(() {
                                      products.remove(item);
                                      var newProducts = products
                                          .map((Product item) => item.toJson())
                                          .toList();

                                      Storage.saveValue(
                                          'products', json.encode(newProducts));
                                    })
                                  },
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.red,
                                ),
                              ],
                            )),
                          ],
                        ),
                      )
                      .toList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ModalAddNewItem(
                  products: products,
                  onPressed: (Product newProduct) {
                    setState(() {
                      products.add(newProduct);
                      var newProducts = products
                          .map((Product item) => item.toJson())
                          .toList();

                      Storage.saveValue('products', json.encode(newProducts));
                    });

                    Navigator.pop(context);
                  },
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
