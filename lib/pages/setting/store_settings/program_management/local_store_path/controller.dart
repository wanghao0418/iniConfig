/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 13:24:23
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-21 13:38:53
 * @FilePath: /eatm_ini_config/lib/pages/setting/store_settings/program_management/local_store_path/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:get/get.dart';

class LocalStorePathController extends GetxController {
  LocalStorePathController();
  List sectionList = ['1', '2', '3'];
  var currentSection = "".obs;

  onSectionChange(String value) {
    currentSection.value = value;
    update(["local_store_path"]);
  }

  _initData() {
    update(["local_store_path"]);
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
