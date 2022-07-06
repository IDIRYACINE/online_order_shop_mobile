import 'package:flutter/foundation.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/Product/product_model.dart';

class SizeEditorHelper {
  late Product _product;
  bool _somethingUpdated = false;

  late List<String> _tempSizes;

  late List<double> _tempPrices;

  final ValueNotifier<int> modelsChangeCounter = ValueNotifier(0);

  final ValueNotifier<int> modelsCount = ValueNotifier(0);

  final ValueNotifier<int> tempModelsCount = ValueNotifier(0);

  void setUp(Product product) {
    _product = product;

    _tempSizes = List.from(_product.getSizeList());

    _tempPrices = List.from(_product.getPriceList());

    modelsCount.value = _tempPrices.length;

    tempModelsCount.value = _tempPrices.length;
  }

  String getTempSize(int index) => _tempSizes[index];

  String getTempPrice(int index) => _tempPrices[index].toString();

  void addModel(String size, String price) {
    _tempSizes.add(size);
    _tempPrices.add(double.parse(price));

    tempModelsCount.value++;
  }

  void removeModel(int index) {
    _tempSizes.removeAt(index);
    _tempPrices.removeAt(index);
    _somethingUpdated = true;

    tempModelsCount.value--;
  }

  void updateModel(int index, String size, String price) {
    _tempSizes[index] = size;
    _tempPrices[index] = double.parse(price);
    modelsChangeCounter.value++;
    _somethingUpdated = true;
  }

  void applyModelsChanges() {
   
      _product.updateModels(_tempSizes, _tempPrices);
      modelsCount.value = _tempSizes.length;
      _somethingUpdated = false;
    
  }

  ValueListenable<int> getModelsCount() {
    return modelsCount;
  }

  ValueListenable<int> getTempModelsCount() {
    return tempModelsCount;
  }
}
