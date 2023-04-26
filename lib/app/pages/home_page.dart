import 'dart:convert';

import 'package:flutter/material.dart';
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

  final List<String> category = [
    'Дата',
    'название города',
    'uid',
    'статус',
    'название товара',
    'цена',
    'кол-во',
    'полная стоимость лота'
  ];

  @override
  void initState() {
    print('${Storage.getValue('products')}');
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
