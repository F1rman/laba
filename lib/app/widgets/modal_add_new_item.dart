import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:laba/app/models/product.dart';

class ModalAddNewItem extends StatefulWidget {
  const ModalAddNewItem({super.key, this.onPressed});
  final onPressed;
  @override
  State<ModalAddNewItem> createState() => _ModalAddNewItemState();
}

class _ModalAddNewItemState extends State<ModalAddNewItem> {
  String nameCity = '';
  int group = 0;
  String nameProduct = '';
  int price = 0;
  int quantity = 0;
  int uid = 0;

  void _handleRadioValueChanged(int value) {
    setState(() {
      group = value;
    });
  }

  int sum() {
    return price * quantity;
  }

  int randomId() {
    setState(() {});
    return uid++;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Название города"),
            TextField(
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              ),
              onChanged: (value) {
                nameCity = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Название товара"),
            TextField(
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              ),
              onChanged: (value) {
                // nameProduct = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Цена"),
            TextField(
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              ),
              onChanged: (value) {
                price = int.parse(value);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Количество товара"),
            TextField(
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              ),
              onChanged: (value) {
                quantity = int.parse(value);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Статус"),
            RadioListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Продажа'),
                value: 0,
                groupValue: group,
                onChanged: (dynamic value) {
                  setState(() {
                    _handleRadioValueChanged(value);
                  });
                }),
            RadioListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Покупка'),
                value: 1,
                groupValue: group,
                onChanged: (dynamic value) {
                  setState(() {
                    _handleRadioValueChanged(value);
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Закрить'),
                ),
                ElevatedButton(
                    onPressed: () {
                      final Product newProduct = Product(nameCity, uid, group,
                        nameProduct, price, quantity, sum());
                      widget.onPressed(newProduct);
                    },
                    child: const Text('Сохранить'))
              ],
            )
          ]),
    );
  }
}
