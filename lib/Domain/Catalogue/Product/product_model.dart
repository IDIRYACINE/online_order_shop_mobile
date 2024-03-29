// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/foundation.dart';

typedef ProductMap = Map<String, List<Product>>;

class Product {
  String _description;
  late ValueNotifier<String> _imageUrl;
  late ValueNotifier<String> _name;
  List<double> _prices;
  List<String> _sizes;
  late final List<String> _descriptionImages;
  late final int _id;

  Product(String name, this._description, String imageUrl, this._prices,
      this._sizes, this._id) {
    _name = ValueNotifier(name);
    _imageUrl = ValueNotifier(imageUrl);
  }

  String getDescription() {
    return _description;
  }

  String getImageUrl() {
    return _imageUrl.value;
  }

  String getName() {
    return _name.value;
  }

  double getPrice([int index = 0]) {
    return _prices[index];
  }

  String getSize(int index) {
    return _sizes[index];
  }

  int getPricesCount() {
    return _prices.length;
  }

  int getSizesCount() {
    return _sizes.length;
  }

  String getDescriptionImageUrl(int index) {
    return _imageUrl.value;
  }

  int getDescrpitionImagesCount() {
    return 1;
  }

  int getId() {
    return _id;
  }

  Map<String, String> toMap() {
    return {
      "Name": _name.value,
      "Description": _description,
      "ImageUrl": _imageUrl.value,
      "Size": jsonEncode(_sizes),
      "Price": jsonEncode(_prices),
    };
  }

  List<double> getPriceList() {
    return _prices;
  }

  List<String> getSizeList() {
    return _sizes;
  }

  static Product from(Product source) {
    return Product(
        source.getName(),
        source.getDescription(),
        source.getImageUrl(),
        source.getPriceList(),
        source.getSizeList(),
        source.getId());
  }

  void transfer(Product target) {
    target.setSizeList(_sizes);
    target.setPriceList(_prices);
    target.setName(_name.value);
    target.setImageUrl(_imageUrl.value);
    target.setDescription(_description);
  }

  void setSizeList(List<String> sizeList) {
    _sizes.clear();
    _sizes.addAll(sizeList);
  }

  void setPriceList(List<double> priceList) {
    _prices.clear();
    _prices.addAll(priceList);
  }

  void setName(String name) {
    _name.value = name;
  }

  void setImageUrl(String imageUrl) {
    _imageUrl.value = imageUrl;
  }

  void setDescription(String description) {
    _description = description;
  }

  void removePrice(int index) {
    _prices.removeAt(index);
  }

  void removeSize(int index) {
    _sizes.removeAt(index);
  }

  void addPrice(double price) {
    _prices.add(price);
  }

  void addSize(String size) {
    _sizes.add(size);
  }

  void updateModel(int index, String size, double price) {
    _prices[index] = price;
    _sizes[index] = size;
  }

  void updateModels(List<String> sizes, List<double> prices) {
    _sizes = List.from(sizes);
    _prices = List.from(prices);
  }

  ValueListenable<String> getNameObserver() {
    return _name;
  }

  ValueListenable<String> getImageObservable() {
    return _imageUrl;
  }
}
