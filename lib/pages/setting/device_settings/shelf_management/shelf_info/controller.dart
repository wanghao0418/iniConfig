import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShelfInfoController extends GetxController {
  ShelfInfoController();
  List shelfList = ['1', '2', '3'];
  var currentShelf = "".obs;
  GlobalKey shelfInfoSettingKey = GlobalKey();

  _initData() {
    update(["shelf_info"]);
  }

  onShelfChange(String shelf) {
    currentShelf.value = shelf;
    update(["shelf_info"]);
  }

  void save() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
