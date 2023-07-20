/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 13:24:23
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-18 10:39:51
 * @FilePath: /eatm_ini_config/lib/pages/setting/store_settings/program_management/local_store_path/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class LocalStorePathController extends GetxController {
  LocalStorePathController();
  List sectionList = [];
  var currentSection = "".obs;

  onSectionChange(String value) {
    currentSection.value = value;
    update(["local_store_path"]);
  }

  _initData() {
    update(["local_store_path"]);
  }

  void getSectionList() async {
    ResponseApiBody res = await CommonApi.getSectionList({
      "params": [
        {
          "list_node": "PrgLocalInfo",
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
    var res = await CommonApi.addSection({
      "params": [
        {
          "list_node": "PrgLocalInfo",
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
          "list_node": 'PrgLocalInfo',
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
