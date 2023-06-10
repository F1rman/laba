import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laba/app/controllers/firestore.dart';
import 'package:laba/app/controllers/global_controller.dart';
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
  GlobalController globalController = Get.find();

  final List<String> category = [
    'Дата',
    'название города',
    'Order ID',
    'купівля/продаж',
    'название товара',
    'цена',
    'кол-во',
    'полная стоимость лота',
    'Статус',
    'действия',
  ];
  final List<String> status = ['Очікування', 'Виконано', 'Відмінено'];
  @override
  void initState()  {
    getTableData();
    filteredProducts = products;
    setState(() {});
    super.initState();
  }

  getTableData() async {
    var rows = await firestore.getTable();
    globalController.products.value =
        rows.docs.map((e) => Product.fromJson(e.data())).toList();
    globalController.loading.value = false;
  }

  editPress({item}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ModalAddNewItem(
            edit: true,
            item: item,
            products: products,
            onPressed: (Product newProduct) {
              setState(() {
                products[products.indexWhere(
                        (element) => element.orderId == newProduct.orderId)] =
                    newProduct;

                // products.add(newProduct);
                // var newProducts =
                //     products.map((Product item) => item.toJson()).toList();

                Storage.saveValue('products', json.encode(products));
              });

              Navigator.pop(context);
            },
          );
        });
  }

  remove(Product item) {
    setState(() {
      products.remove(item);
      firestore.removeTableRow(id: item.orderId.toString());
      // firestore.updateTableRow(products);
      Storage.saveValue(
          'products', products.map((Product item) => item.toJson()));
    });
  }

  save(Product newProduct) {
    setState(() {
      products.add(newProduct);
      var newProducts = products.map((Product item) => item.toJson()).toList();
      firestore.updateTableRow(
          id: newProduct.orderId.toString(), obj: newProduct.toJson());
      Storage.saveValue('products', json.encode(newProducts));
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Table')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () => Column(
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
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 15),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              filteredProducts = products;
                              setState(() {});
                              return;
                            }
                            filteredProducts = products
                                .where((element) =>
                                    element.nameCity.contains(value))
                                .toList();
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (globalController.loading.value)
                  const CircularProgressIndicator(
                    color: Colors.blueAccent,
                  ),
                if (!globalController.loading.value)
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
                      rows: globalController.products
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
                                  Text(item.orderId.toString()),
                                ),
                                DataCell(
                                  Text(['продаж', 'купівля'][item.status]
                                      .toString()),
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
                                DataCell(
                                  Text(status[item.statusOrder]),
                                ),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => editPress(item: item),
                                      icon: Icon(Icons.edit),
                                      color: Colors.grey,
                                    ),
                                    if (item.statusOrder == 1)
                                      IconButton(
                                        onPressed: () => {
                                          setState(() {
                                            if (item.status == 1) {
                                              item.status = 0;
                                            } else {
                                              item.status = 1;
                                            }
                                            var newProducts = products
                                                .map((Product item) =>
                                                    item.toJson())
                                                .toList();

                                            Storage.saveValue('products',
                                                json.encode(newProducts));
                                          })
                                        },
                                        icon: Icon(item.status == 1
                                            ? Icons.sell_rounded
                                            : Icons.sell_outlined),
                                        color: Colors.green,
                                      ),
                                    IconButton(
                                      onPressed: () => remove(item),
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
      ),
      floatingActionButton: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (globalController.loading.value)
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
              if (!globalController.loading.value)
                FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ModalAddNewItem(
                            products: products,
                            edit: false,
                            onPressed: save,
                          );
                        });
                  },
                  child: const Icon(Icons.add),
                ),
            ],
          )),
    );
  }
}
