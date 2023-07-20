import 'package:get/get.dart';
import 'package:iniConfig/common/api/machine.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class OutLineMacController extends GetxController {
  OutLineMacController();
  List sectionList = [];
  var currentSection = ''.obs;

  onSectionChange(String section) {
    currentSection.value = section;
    _initData();
  }

  void getSectionList() async {
    ResponseApiBody res = await CommonApi.getSectionList({
      "params": [
        {
          "list_node": "TestCMMInfo",
          "parent_node": "NULL",
        }
      ],
    });
    if (res.success == true) {
      // 查询成功
      var data = res.data;
      var result = (data as List).first as String;
      sectionList = result.isEmpty ? [] : result.split('-');
      currentSection.value = sectionList.isNotEmpty ? sectionList.first : "";
      _initData();
    } else {
      // 查询失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 新增
  void add() async {
    var res = await MachineApi.addMachine({
      "params": [
        {
          "list_node": "TestCMMInfo",
          "parent_node": "NULL",
        }
      ],
    });
    if (res.success == true) {
      // 新增成功
      // getSectionList();
      sectionList.add((res.data as List).first as String);
      _initData();
    } else {
      // 新增失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 删除
  void delete() async {
    var lastSection = sectionList.last;
    var res = await CommonApi.deleteLastSection({
      "params": [
        {
          "list_node": 'TestCMMInfo',
          "parent_node": "NULL",
          "node_name": lastSection,
        }
      ],
    });
    if (res.success == true) {
      // 删除成功
      // getSectionList();
      sectionList.remove(lastSection);
      if (currentSection.value == lastSection) {
        currentSection.value = sectionList.isNotEmpty ? sectionList.first : "";
      }
      _initData();
    } else {
      // 删除失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  _initData() {
    update(["out_line_mac"]);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    getSectionList();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
