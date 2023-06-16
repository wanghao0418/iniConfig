/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-15 11:17:42
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-15 14:01:28
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/robot/robot_connection/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';

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

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = robotConnection.toJson();
    temp[field] = val;
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

  _initData() {
    update(["robot_connection"]);
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
