import 'package:get/get.dart';
import 'package:laba/app/controllers/firestore.dart';

import '../models/product.dart';

class GlobalController extends GetxController {
  var firestore = Get.find<FirestoreController>();
  RxList cities = [].obs;
  RxList product = [].obs;
  RxList products = [].obs;
  RxBool loading = true.obs;
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
    // cities.value =
    super.onInit();
  }
}
