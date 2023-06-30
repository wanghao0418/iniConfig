/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 09:22:59
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-30 11:25:18
 * @FilePath: /eatm_ini_config/lib/pages/setting/store_settings/clamping_management/tray_settings/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/components/field_change.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class TraySettingsController extends GetxController {
  TraySettingsController();
  List<RenderFieldInfo> menuList = [
    RenderFieldInfo(
        field: 'AddFixtureType',
        section: 'FixtureInfo',
        name: '添加托盘类型',
        renderType: RenderType.radio,
        options: {"不添加托盘类型": "0", "添加托盘类型": "1"}),
    RenderFieldInfo(
      field: '1',
      section: 'FixtureInfo',
      name: '托盘类型1',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: '2',
      section: 'FixtureInfo',
      name: '托盘类型2',
      renderType: RenderType.input,
    ),
  ];
  List<String> changedList = [];
  TraySettings traySettings = TraySettings();

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  String? getFieldValue(String field) {
    return traySettings.toJson()[field];
  }

  void setFieldValue(String field, String val) {
    var temp = traySettings.toJson();
    temp[field] = val;
    traySettings = TraySettings.fromJson(temp);
  }

  // 通用的修改字段方法
  onFieldChange(String field, String val) {
    if (getFieldValue(field) == val) {
      return;
    }
    if (!changedList.contains(field)) {
      changedList.add(field);
    }
    setFieldValue(field, val);
    update(["tray_settings"]);
  }

  query() async {
    ResponseApiBody res = await CommonApi.fieldQuery({
      "params": traySettings.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      traySettings = TraySettings.fromJson(res.data);
      _initData();
    } else {
      // 保存失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  _makeParams() {
    List<Map<String, dynamic>> params = [];
    for (var element in changedList) {
      params.add({"key": element, "value": getFieldValue(element)});
    }
    return params;
  }

  // 保存
  save() async {
    if (changedList.isEmpty) {
      return;
    }
    // 组装传参
    List<Map<String, dynamic>> params = _makeParams();
    print(params);
    ResponseApiBody res = await CommonApi.fieldUpdate({"params": params});
    if (res.success == true) {
      // 保存成功
      changedList.clear();
      PopupMessage.showSuccessInfoBar('保存成功');
      _initData();
    } else {
      // 保存失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  _initData() {
    update(["tray_settings"]);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    query();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

class TraySettings {
  String? fixtureInfoAddFixtureType;
  String? fixtureInfo1;
  String? fixtureInfo2;

  TraySettings(
      {this.fixtureInfoAddFixtureType, this.fixtureInfo1, this.fixtureInfo2});

  TraySettings.fromJson(Map<String, dynamic> json) {
    fixtureInfoAddFixtureType = json['FixtureInfo/AddFixtureType'];
    fixtureInfo1 = json['FixtureInfo/1'];
    fixtureInfo2 = json['FixtureInfo/2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FixtureInfo/AddFixtureType'] = this.fixtureInfoAddFixtureType;
    data['FixtureInfo/1'] = this.fixtureInfo1;
    data['FixtureInfo/2'] = this.fixtureInfo2;
    return data;
  }
}
