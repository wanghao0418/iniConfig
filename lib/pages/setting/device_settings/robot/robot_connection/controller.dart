/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-15 11:17:42
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-13 16:13:55
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/robot/robot_connection/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:iniConfig/common/api/common.dart';

import '../../../../../common/components/field_change.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class RobotConnectionController extends GetxController {
  RobotConnectionController();
  RobotConnection robotConnection = RobotConnection();
  List<RenderFieldInfo> menuList = [
    RenderFieldInfo(
      section: "RobotInfo",
      field: "RobotPlaque",
      name: "机器人品牌",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
        section: "RobotInfo",
        field: "RobotType",
        name: "机器人连接类型",
        renderType: RenderType.radio,
        options: {"接口": "0", "dp": "1"}),
    RenderFieldInfo(
        section: "RobotInfo",
        field: "ServiceAddr",
        name: "机器人IP",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: "RobotInfo",
        field: "RobotName",
        name: "机器人名称",
        renderType: RenderType.input),
  ];
  List<String> changedList = [];
  var currentRobotType = ''.obs;

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = robotConnection.toJson();
    temp[field] = val;
    if (field == 'RobotInfo/RobotType') {
      currentRobotType.value = val;
    }
    robotConnection = RobotConnection.fromJson(temp);
  }

  String? getFieldValue(String field) {
    return robotConnection.toJson()[field];
  }

  void onFieldChange(String field, String value) {
    if (value == getFieldValue(field)) {
      return;
    }
    if (!changedList.contains(field)) {
      changedList.add(field);
    }
    setFieldValue(field, value);
    update(["robot_connection"]);
  }

  query() async {
    ResponseApiBody res = await CommonApi.fieldQuery({
      "params": robotConnection.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      robotConnection = RobotConnection.fromJson(res.data);
      currentRobotType.value = robotConnection.robotInfoRobotType ?? '';
      currentRobotType.listen((event) {
        if (currentRobotType.value == '1') {
          // 获取plc ip
          getIp();
        }
      });
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
    update(["robot_connection"]);
  }

  getIp() async {
    ResponseApiBody res = await CommonApi.fieldQuery({
      "params": ['SensorInfo/ServiceAddr'],
    });
    if (res.success == true) {
      onFieldChange(
          'RobotInfo/ServiceAddr', res.data['SensorInfo/ServiceAddr']);
    }
  }

  // get currentRobotType => getFieldValue('RobotInfo/RobotType').obs;

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

class RobotConnection {
  String? robotInfoRobotPlaque;
  String? robotInfoRobotType;
  String? robotInfoServiceAddr;
  String? robotInfoRobotName;

  RobotConnection(
      {this.robotInfoRobotPlaque,
      this.robotInfoRobotType,
      this.robotInfoServiceAddr,
      this.robotInfoRobotName});

  RobotConnection.fromJson(Map<String, dynamic> json) {
    robotInfoRobotPlaque = json['RobotInfo/RobotPlaque'];
    robotInfoRobotType = json['RobotInfo/RobotType'];
    robotInfoServiceAddr = json['RobotInfo/ServiceAddr'];
    robotInfoRobotName = json['RobotInfo/RobotName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RobotInfo/RobotPlaque'] = this.robotInfoRobotPlaque;
    data['RobotInfo/RobotType'] = this.robotInfoRobotType;
    data['RobotInfo/ServiceAddr'] = this.robotInfoServiceAddr;
    data['RobotInfo/RobotName'] = this.robotInfoRobotName;
    return data;
  }
}
