/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 09:57:41
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-13 16:35:07
 * @FilePath: /eatm_ini_config/lib/pages/setting/store_settings/program_management/mac_program_source/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class MacProgramSourceController extends GetxController {
  MacProgramSourceController();
  List sectionList = [];
  var currentSection = ''.obs;
  List<String> macSectionList = [];

  onSectionChange(String value) {
    currentSection.value = value;
    update(["mac_program_source"]);
  }

  _initData() {
    update(["mac_program_source"]);
  }

  void getSectionList() async {
    ResponseApiBody res = await CommonApi.getSectionList({
      "params": [
        {
          "list_node": "PrgServerInfo",
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
          "list_node": "PrgServerInfo",
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
    if (currentSection.value.isEmpty) {
      PopupMessage.showWarningInfoBar('请选择要删除的节点');
      return;
    }
    var res = await CommonApi.deleteSection({
      "params": [
        {
          "list_node": 'PrgServerInfo',
          "parent_node": "NULL",
          "node_name": currentSection.value,
        }
      ],
    });
    if (res.success == true) {
      // 删除成功
      // getSectionList();
      sectionList.remove(currentSection.value);
      currentSection.value = sectionList.isNotEmpty ? sectionList.first : "";
      _initData();
    } else {
      // 删除失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 获取机床节点列表数据 供子组件使用
  void getMacSectionList() async {
    ResponseApiBody res = await CommonApi.getSectionList({
      "params": [
        {
          "list_node": "MachineInfo",
          "parent_node": "NULL",
        }
      ],
    });
    if (res.success == true) {
      // 查询成功
      var data = res.data;
      var result = (data as List).first as String;
      macSectionList = result.isEmpty ? [] : result.split('-');
      print(macSectionList);
      _initData();
    } else {
      // 查询失败
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
    getMacSectionList();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
