/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-20 13:38:43
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-21 14:22:43
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/machine/machine_info/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:get/get.dart';

class MachineInfoController extends GetxController {
  MachineInfoController();
  List sectionList = ['mac01', 'mac02', 'mac03'];
  var currentSection = 'mac01'.obs;

  onSectionChange(String section) {
    currentSection.value = section;
    _initData();
  }

  _initData() {
    update(["machine_info"]);
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
