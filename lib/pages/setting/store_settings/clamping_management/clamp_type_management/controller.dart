import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';

class ClampTypeManagementController extends GetxController {
  ClampTypeManagementController();
  List<RenderFieldInfo> menuList = [
    RenderFieldInfo(
      field: 'STEEL',
      section: 'FixtureTypeInfo',
      name: '钢件夹具类型',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'ELEC',
      section: 'FixtureTypeInfo',
      name: '电极夹具类型',
      renderType: RenderType.input,
    ),
  ];
  List<String> changedList = [];
  ClampTypeManagement clampTypeManagement = ClampTypeManagement();

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  String? getFieldValue(String field) {
    return clampTypeManagement.toJson()[field];
  }

  void setFieldValue(String field, String val) {
    var temp = clampTypeManagement.toJson();
    temp[field] = val;
    clampTypeManagement = ClampTypeManagement.fromJson(temp);
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
    update(["clamp_type_management"]);
  }

  _initData() {
    update(["clamp_type_management"]);
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

class ClampTypeManagement {
  String? fixtureTypeInfoSTEEL;
  String? fixtureTypeInfoELEC;

  ClampTypeManagement({this.fixtureTypeInfoSTEEL, this.fixtureTypeInfoELEC});

  ClampTypeManagement.fromJson(Map<String, dynamic> json) {
    fixtureTypeInfoSTEEL = json['FixtureTypeInfo/STEEL'];
    fixtureTypeInfoELEC = json['FixtureTypeInfo/ELEC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FixtureTypeInfo/STEEL'] = this.fixtureTypeInfoSTEEL;
    data['FixtureTypeInfo/ELEC'] = this.fixtureTypeInfoELEC;
    return data;
  }
}
