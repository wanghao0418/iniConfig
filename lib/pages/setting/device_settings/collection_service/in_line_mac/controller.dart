/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 15:58:21
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-05 17:45:35
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/collection_service/in_line_mac/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class InLineMacController extends GetxController {
  InLineMacController();
  List sectionList = [];
  final List selectedSections = [];
  bool isSearching = false;

  _initData() {
    update(["in_line_mac"]);
  }

  void getSectionList() async {
    isSearching = true;
    _initData();
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
      var macNameList = result.isEmpty ? [] : result.split('-');
      // 查询机床详情
      ResponseApiBody res2 =
          await CommonApi.getSectionDetail({"params": macNameList});
      if (res2.success == true) {
        // 查询成功
        var data2 = res2.data;
        var result2 = data2;
        sectionList = result2.isEmpty
            ? []
            : result2.map((e) {
                var index = result2.indexOf(e);
                return MacData(section: macNameList[index], data: e);
              }).toList();
      } else {
        // 查询失败
        isSearching = false;
        _initData();
        PopupMessage.showFailInfoBar(res2.message as String);
      }
      _initData();
    } else {
      // 查询失败
      isSearching = false;
      _initData();
      PopupMessage.showFailInfoBar(res.message as String);
    }
    query();
  }

  query() async {
    ResponseApiBody res = await CommonApi.fieldQuery({
      "params": ['CollectServer/EAtmMacDataCollectRange'],
    });
    if (res.success == true) {
      isSearching = false;
      _initData();
      // 查询成功
      selectedSections.clear();
      // 过滤掉现有机床中不存在的机床
      var macSectionlist =
          (res.data["CollectServer/EAtmMacDataCollectRange"]).split('-');
      selectedSections.addAll(macSectionlist.where((element) {
        return sectionList.any((e) => e.section == element);
      }));
      _initData();
    } else {
      isSearching = false;
      _initData();
      // 查询失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  void save() async {
    ResponseApiBody res = await CommonApi.fieldUpdate({
      "params": [
        {
          "key": "CollectServer/EAtmMacDataCollectRange",
          "value": selectedSections.where((element) => element != '').join('-'),
        }
      ]
    });
    if (res.success == true) {
      // 保存成功
      // changedList.clear();
      PopupMessage.showSuccessInfoBar('保存成功');
      _initData();
    } else {
      // 保存失败
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

class MacData {
  String? section;
  Map? data;
  MacData({this.section, this.data});
}
