import 'package:get/get.dart';

class OutLineMacController extends GetxController {
  OutLineMacController();
  List sectionList = ['mac01', 'mac02', 'mac03'];
  var currentSection = 'mac01'.obs;

  onSectionChange(String section) {
    currentSection.value = section;
    _initData();
  }

  _initData() {
    update(["out_line_mac"]);
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
