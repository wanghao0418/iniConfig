/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-14 15:30:08
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-30 11:19:59
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/plc/plc_connection/controller.dart
 * @Description: plc连接设置
 */
import 'package:get/get.dart';
import 'package:iniConfig/common/api/common.dart';

import '../../../../../common/components/field_change.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class PlcConnectionController extends GetxController {
  PlcConnectionController();
  PlcConnection plcConnection = PlcConnection();
  List<RenderFieldInfo> connectList = [
    RenderFieldInfo(
        section: 'SensorInfo',
        field: 'ServiceAddr',
        name: '服务地址',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'SensorInfo',
        field: 'ServicePort',
        name: '服务端口',
        renderType: RenderType.input),
  ];

  List<String> changedList = [];

  void onFieldChange(String field, String value) {
    if (value == plcConnection.toJson()[field]) {
      return;
    }
    if (!changedList.contains(field)) {
      changedList.add(field);
    }
    var json = plcConnection.toJson();
    json[field] = value;
    plcConnection = PlcConnection.fromJson(json);
    update(["plc_connection"]);
  }

  String? getFieldValue(String field) {
    return plcConnection.toJson()[field];
  }

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  query() async {
    ResponseApiBody res = await CommonApi.fieldQuery({
      "params": plcConnection.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      plcConnection = PlcConnection.fromJson(res.data);
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
    update(["plc_connection"]);
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

class PlcConnection {
  String? sensorInfoServiceAddr;
  String? sensorInfoServicePort;

  PlcConnection({this.sensorInfoServiceAddr, this.sensorInfoServicePort});

  PlcConnection.fromJson(Map<String, dynamic> json) {
    sensorInfoServiceAddr = json['SensorInfo/ServiceAddr'];
    sensorInfoServicePort = json['SensorInfo/ServicePort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SensorInfo/ServiceAddr'] = this.sensorInfoServiceAddr;
    data['SensorInfo/ServicePort'] = this.sensorInfoServicePort;
    return data;
  }
}

// class PlcConnection {
//   String? serviceAddr;
//   String? servicePort;

//   PlcConnection({this.serviceAddr, this.servicePort});

//   PlcConnection.fromJson(Map<String, dynamic> json) {
//     serviceAddr = json['ServiceAddr'];
//     servicePort = json['ServicePort'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ServiceAddr'] = this.serviceAddr;
//     data['ServicePort'] = this.servicePort;
//     return data;
//   }
// }
