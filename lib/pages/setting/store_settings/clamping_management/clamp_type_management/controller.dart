import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/components/field_change.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

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

  query() async {
    ResponseApiBody res = await CommonApi.fieldQuery({
      "params": clampTypeManagement.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      clampTypeManagement = ClampTypeManagement.fromJson(res.data);
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
