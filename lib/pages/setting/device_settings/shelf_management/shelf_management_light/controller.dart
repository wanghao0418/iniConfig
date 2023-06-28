import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/components/field_change.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

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
    // RenderFieldInfo(
    //     section: "MoreLightsInfo",
    //     field: "StorageLightDeviceNode",
    //     name: "存储灯设备节点",
    //     renderType: RenderType.input),
    RenderFieldInfo(
        section: "MoreLightsInfo",
        field: "SenSorLightColorSet",
        name: "传感器灯颜色设置",
        renderType: RenderType.input),
  ];
  List<String> changedList = [];
  List sectionList = [];
  var currentSection = "".obs;

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
    _initData();
  }

  void onSectionChange(String section) {
    currentSection.value = section;
    _initData();
  }

  void getSectionList() async {
    ResponseApiBody res = await CommonApi.getSectionList({
      "params": [
        {
          "list_node": "StorageLightDevice",
          "parent_node": null,
        }
      ],
    });
    if (res.success == true) {
      // 查询成功
      var data = res.data;
      sectionList = ((data as List).first as String).split('-');
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
          "list_node": "TcpScanDriverInfo",
          "parent_node": null,
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
    var res = await CommonApi.deleteSection({
      "params": [
        {
          "list_node": currentSection.value,
          "parent_node": null,
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
    getSectionList();
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
