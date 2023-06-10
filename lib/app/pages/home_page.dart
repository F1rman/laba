import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laba/app/controllers/auth.dart';
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
  var firestore = Get.find<FirestoreController>();
  GlobalController globalController = Get.find();
  AuthController authController = Get.find();

  final List<String> category = [
    'uid',
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

  editPress({required Product item}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ModalAddNewItem(
            edit: true,
            selling: false,
            item: item,
            onPressed: (Product newProduct) {
              firestore.updateTableRow(
                  id: newProduct.uid.toString(), obj: newProduct.toJson());

              Navigator.pop(context);
            },
          );
        });
  }

  sellOrderPress({required Product item}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ModalAddNewItem(
            edit: false,
            selling: true,
            item: item,
            onPressed: (Product newProduct) {
              firestore.updateTableRow(
                  id: newProduct.uid.toString(), obj: newProduct.toJson());

              Navigator.pop(context);
            },
          );
        });
  }

  remove({required Product item}) {
    firestore.removeTableRow(id: item.uid.toString());
  }

  save({required Product item}) {
    firestore.updateTableRow(id: item.uid.toString(), obj: item.toJson());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Data Table'),
          leading: IconButton(
            onPressed: () {
              authController.logOut();
              Get.offAllNamed('/login');
            },
            icon: const Icon(Icons.logout),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              StreamBuilder(
                  stream: firestore.getTable(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                            ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      globalController.products.value =
                          snapshot.data!.docs.map((e) {
                        return Product.fromJson(
                            e.data() as Map<String, dynamic>);
                      }).toList();
                      globalController.filteredProducts.value =
                          globalController.products;
                      return Column(
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
                                    onChanged: (e) =>
                                        globalController.onSearch(e),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => DataTable(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                columns: category.map((item) {
                                  return DataColumn(
                                    label: Container(
                                      child: Text(item),
                                    ),
                                  );
                                }).toList(),
                                rows: globalController.filteredProducts
                                    .map(
                                      (item) => DataRow(
                                        color: MaterialStateColor.resolveWith(
                                          (states) {
                                            if (item.status == 0) {
                                              return Colors.green.shade100;
                                            } else {
                                              return Colors.white;
                                            }
                                          },
                                        ),
                                        cells: [
                                          DataCell(
                                            Text(item.uid.toString()),
                                          ),
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
                                            Text([
                                              'купівля',
                                              'продаж',
                                            ][item.status]
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
                                            Text(globalController
                                                .status[item.statusOrder]),
                                          ),
                                          DataCell(Row(
                                            children: [
                                              IconButton(
                                                onPressed: () =>
                                                    editPress(item: item),
                                                icon: Icon(Icons.edit),
                                                color: Colors.grey,
                                              ),
                                              if (item.statusOrder == 1 &&
                                                  item.status == 0)
                                                IconButton(
                                                  onPressed: () =>
                                                      sellOrderPress(
                                                          item: item),
                                                  icon: Icon(
                                                      Icons.add_circle_rounded),
                                                  color: Colors.green,
                                                ),
                                              IconButton(
                                                onPressed: () =>
                                                    remove(item: item),
                                                icon: Icon(Icons.remove_circle),
                                                color: Colors.red,
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    )
                                    .toList()),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        child: Text('No data'),
                      );
                    }
                  }),
            ],
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
                            selling: false,
                            edit: false,
                            onPressed: (item) => save(item: item),
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
