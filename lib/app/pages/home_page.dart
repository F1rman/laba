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
  final List<String> category = [
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
          child: Center(
            child: DataTable(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                columns: category.map((item) {
                  return DataColumn(
                    label: Container(
                      child: Text(item),
                    ),
                  );
                }).toList(),
                rows: products
                    .map(
                      (item) => DataRow(
                        cells: [
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
