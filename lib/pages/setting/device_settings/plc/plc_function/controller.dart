import 'package:get/get.dart';

import '../../../../../common/api/plc.dart';
import '../../../../../common/components/field_change.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class PlcFunctionController extends GetxController {
  PlcFunctionController();
  PlcFunction plcFunction = PlcFunction();
  List<RenderFieldInfo> functionList = [
    RenderFieldInfo(
        section: 'PlcDefinition',
        field: 'OkLight',
        name: 'OK灯',
        renderType: RenderType.select,
        options: {"亮绿灯": "1", "亮红灯": "2", "亮黄灯": "3"}),
    RenderFieldInfo(
        section: 'PlcDefinition',
        field: 'NgLight',
        name: 'NG灯',
        renderType: RenderType.select,
        options: {"亮绿灯": "1", "亮红灯": "2", "亮黄灯": "3"}),
    RenderFieldInfo(
        section: 'PlcDefinition',
        field: 'WarnLight',
        name: '警告灯',
        renderType: RenderType.select,
        options: {"亮绿灯": "1", "亮红灯": "2", "亮黄灯": "3"}),
  ];
  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  String? getFieldValue(String field) {
    return plcFunction.toJson()[field];
  }

  void setFieldValue(String field, String val) {
    var temp = plcFunction.toJson();
    temp[field] = val;
    plcFunction = PlcFunction.fromJson(temp);
  }

  void onFieldChange(String field, String value) {
    if (value == getFieldValue(field)) {
      return;
    }
    if (!changedList.contains(field)) {
      changedList.add(field);
    }
    setFieldValue(field, value);
    update(["plc_function"]);
  }

  query() async {
    ResponseApiBody res = await PlcApi.fieldQuery({
      "params": plcFunction.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      plcFunction = PlcFunction.fromJson(res.data);
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
    if (changedList.isEmpty) return;
    // 组装传参
    List<Map<String, dynamic>> params = _makeParams();
    print(params);
    ResponseApiBody res = await PlcApi.fieldUpdate({"params": params});
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
    update(["plc_function"]);
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

class PlcFunction {
  String? plcDefinitionOkLight;
  String? plcDefinitionNgLight;
  String? plcDefinitionWarnLight;

  PlcFunction(
      {this.plcDefinitionOkLight,
      this.plcDefinitionNgLight,
      this.plcDefinitionWarnLight});

  PlcFunction.fromJson(Map<String, dynamic> json) {
    plcDefinitionOkLight = json['PlcDefinition/OkLight'];
    plcDefinitionNgLight = json['PlcDefinition/NgLight'];
    plcDefinitionWarnLight = json['PlcDefinition/WarnLight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PlcDefinition/OkLight'] = this.plcDefinitionOkLight;
    data['PlcDefinition/NgLight'] = this.plcDefinitionNgLight;
    data['PlcDefinition/WarnLight'] = this.plcDefinitionWarnLight;
    return data;
  }
}
