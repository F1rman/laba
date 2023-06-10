import 'package:get/get.dart';
import 'package:laba/app/controllers/firestore.dart';
import 'package:laba/app/models/product.dart';


class GlobalController extends GetxController {
  final List<String> status = ['Очікування', 'Виконано', 'Відмінено'];

  var firestore = Get.find<FirestoreController>();
  RxList cities = [].obs;
  RxList product = [].obs;
  RxList<Product> products = [Product(nameCity: 'nameCity', uid: 0, orderId: 1, status: 1, nameProduct: 'nameProduct', price: 1, quantity: 1, sum: 1, statusOrder: 1, date: 1)].obs;
  RxBool loading = true.obs;

  late RxList filteredProducts = [].obs;

  @override
  void onInit() async {
    try {
      var citiesData = await firestore.getTableFields();
      var productData = await firestore.getTableFields(doc: 'products');

      cities.value = citiesData?['cities'];
      product.value = productData?['products'];
      loading.value = false;
    } catch (e) {
      loading.value = false;
      print(e);
    }
    super.onInit();
  }

  onSearch(value) {
    if (value.isEmpty) {
      filteredProducts.value = [...products];
    } else {
      filteredProducts.value = products
          .where((element) =>
              element.nameCity.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
  }

}
