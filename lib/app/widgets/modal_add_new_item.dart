import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:laba/app/controllers/firestore.dart';
import 'package:laba/app/controllers/global_controller.dart';
import 'package:laba/app/models/product.dart';
import 'dart:math';

class ModalAddNewItem extends StatefulWidget {
  const ModalAddNewItem(
      {super.key,
      this.onPressed,
      required this.edit,
      this.item,
      required this.selling});
  final onPressed;
  final bool edit;
  final bool selling;
  final Product? item;
  @override
  State<ModalAddNewItem> createState() => _ModalAddNewItemState();
}

class _ModalAddNewItemState extends State<ModalAddNewItem> {
  GlobalController globalController = Get.find();
  FirestoreController firestore = Get.find();

  RxInt group = 0.obs;
  RxInt orderStatus = 0.obs;
  RxInt price = 0.obs;
  RxInt quantity = 0.obs;
  int uid = 0;
  RxString nameProduct = ''.obs;
  RxString nameCity = ''.obs;
  RxInt newQuantity = 0.obs;
  int sum() {
    return price.value * newQuantity.value;
  }

  save() {
    final Product newProduct = Product(
        uid: widget.edit ? widget.item!.uid : maxIncrement(),
        date: DateTime.now().millisecondsSinceEpoch,
        nameCity: nameCity.value,
        nameProduct: nameProduct.value,
        price: price.value,
        quantity: newQuantity.value,
        status: group.value,
        sum: sum(),
        orderId: widget.edit || widget.selling
            ? widget.item!.orderId
            : maxIncrement(),
        statusOrder: orderStatus.value);
    widget.onPressed(newProduct);
  }

  int maxIncrement() {
    var maxUid = 0;
    if (globalController.products.isEmpty) {
      return maxUid;
    }
    return globalController.products.map((e) => e.uid).reduce(max) + 1;
  }

  @override
  void initState() {
    nameCity.value = globalController.cities.first;
    nameProduct.value = globalController.product.first;
    if (widget.edit) {
      quantity.value = widget.item!.quantity;
      group.value = widget.item!.status;
      nameCity.value = widget.item!.nameCity;
      nameProduct.value = widget.item!.nameProduct;
      price.value = widget.item!.price;
      orderStatus.value = widget.item!.statusOrder;
      newQuantity.value = widget.item!.quantity;
    }
    if (widget.selling) {
      // widget.item?.quantity = newQuantity.value;
      // quantity.value = widget.item!.quantity;
      group.value = 1;
      nameCity.value = widget.item!.nameCity;
      nameProduct.value = widget.item!.nameProduct;
      price.value = widget.item!.price;
      newQuantity.value = widget.item!.quantity;
      globalController.products.forEach((Product e) {
        if (widget.item!.orderId == e.orderId) {
          if (e.status == 1 && e.statusOrder != 2) {
            newQuantity.value -= e.quantity;
          }
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text("Название города"),
        Obx(() => DropdownButton<String>(
              value: nameCity.value,
              items: globalController.cities.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (val) {
                nameCity.value = val.toString();
              },
            )),
        const SizedBox(
          height: 20,
        ),
        const Text("Название товара"),
        if (!widget.edit)
          Obx(() => DropdownButton<String>(
                value: nameProduct.value,
                items: globalController.product.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (val) {
                  nameProduct.value = val.toString();
                },
              )),
        if (widget.edit)
          DropdownButton<String>(
            value: widget.item?.nameProduct,
            items: globalController.product.map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (val) {
              nameProduct.value = val.toString();
            },
          ),
        const SizedBox(
          height: 20,
        ),
        const Text("Цена"),
        TextFormField(
          initialValue: price.value.toString(),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          ),
          onChanged: (value) {
            price.value = int.parse(value);
          },
        ),
        const SizedBox(
          height: 20,
        ),
        const Text("Количество товара"),
        Obx(() => TextFormField(
              initialValue: newQuantity.value.toString(),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              ),
              onChanged: (value) {
                newQuantity.value = int.parse(value);
              },
            )),
        const SizedBox(
          height: 20,
        ),
        if (widget.edit)
          Obx(() => Column(
                children: [
                  const Text("Статус Замовлення"),
                  RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Очікування'),
                      value: 0,
                      groupValue: orderStatus.value,
                      onChanged: (dynamic value) {
                        orderStatus.value = value;
                      }),
                  RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Виконано'),
                      value: 1,
                      groupValue: orderStatus.value,
                      onChanged: (dynamic value) {
                        orderStatus.value = value;
                      }),
                  RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Відмінено'),
                      value: 2,
                      groupValue: orderStatus.value,
                      onChanged: (dynamic value) {
                        orderStatus.value = value;
                      }),
                ],
              )),
        if (!widget.edit) const Text("Статус"),
        if (!widget.edit && !widget.selling)
          Obx(() => RadioListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Покупка'),
              value: 0,
              groupValue: group.value,
              onChanged: (dynamic value) {
                setState(() {
                  group.value = value;
                });
              })),
        if (!widget.edit)
          Obx(() => RadioListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Продажа'),
              value: 1,
              groupValue: group.value,
              onChanged: (dynamic value) {
                setState(() {
                  group.value = value;
                });
              })),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Закрить'),
            ),
            ElevatedButton(onPressed: save, child: const Text('Сохранить'))
          ],
        )
      ]),
    );
  }
}
