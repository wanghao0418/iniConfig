import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';

class ShelfManagementLightController extends GetxController {
  ShelfManagementLightController();
  ShelfManagementLight shelfManagementLight = ShelfManagementLight();
  List<RenderFieldInfo> menuList = [
    RenderFieldInfo(
      section: "MoreLightsInfo",
      field: "SenSorLightCtrlMode",
      name: "使用七色灯的标志",
      renderType: RenderType.toggleSwitch,
      options: {"自动": "0", "手动": "1"},
    ),
    RenderFieldInfo(
        section: "MoreLightsInfo",
        field: "StorageLightDeviceNode",
        name: "存储灯设备节点",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: "MoreLightsInfo",
        field: "SenSorLightColorSet",
        name: "传感器灯颜色设置",
        renderType: RenderType.input),
  ];
  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = shelfManagementLight.toJson();
    temp[field] = val;
    shelfManagementLight = ShelfManagementLight.fromJson(temp);
  }

  String? getFieldValue(String field) {
    return shelfManagementLight.toJson()[field];
  }

  void onFieldChange(String field, String value) {
    if (value == getFieldValue(field)) {
      return;
    }
    if (!changedList.contains(field)) {
      changedList.add(field);
    }
    setFieldValue(field, value);
    update(["shelf_management_light"]);
  }

  _initData() {
    update(["shelf_management_light"]);
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

class ShelfManagementLight {
  String? moreLightsInfoSenSorLightCtrlMode;
  String? moreLightsInfoStorageLightDeviceNode;
  String? moreLightsInfoSenSorLightColorSet;

  ShelfManagementLight(
      {this.moreLightsInfoSenSorLightCtrlMode,
      this.moreLightsInfoStorageLightDeviceNode,
      this.moreLightsInfoSenSorLightColorSet});

  ShelfManagementLight.fromJson(Map<String, dynamic> json) {
    moreLightsInfoSenSorLightCtrlMode =
        json['MoreLightsInfo/SenSorLightCtrlMode'];
    moreLightsInfoStorageLightDeviceNode =
        json['MoreLightsInfo/StorageLightDeviceNode'];
    moreLightsInfoSenSorLightColorSet =
        json['MoreLightsInfo/SenSorLightColorSet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MoreLightsInfo/SenSorLightCtrlMode'] =
        this.moreLightsInfoSenSorLightCtrlMode;
    data['MoreLightsInfo/StorageLightDeviceNode'] =
        this.moreLightsInfoStorageLightDeviceNode;
    data['MoreLightsInfo/SenSorLightColorSet'] =
        this.moreLightsInfoSenSorLightColorSet;
    return data;
  }
}
