/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-15 14:14:25
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-30 13:25:28
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/robot/robot_communication_protocol/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:get/get.dart';
import 'package:iniConfig/common/api/plc.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/components/field_change.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class RobotCommunicationProtocolController extends GetxController {
  RobotCommunicationProtocolController();
  RobotCommunicationProtocol robotCommunicationProtocol =
      RobotCommunicationProtocol();
  List<RenderFieldInfo> menuList = [
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "Ask",
        name: "机器人与软件交互状态（ASK）",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "Type",
        name: "任务类型(TYPE)",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "TakeNum",
        name: "取货位号,（从货架上取）(TAKE)",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "TakeShelfNum",
        name: "取货架号",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "TakeStorageType",
        name: "取货位类型",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "PutMachineNum",
        name: "放机床号（放到机床上）",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "PutDirection",
        name: "放料基准角(上料到机床，对应放机床号)",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "TakeMachineNum",
        name: "取机床号（从机床上取走）",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "TakeDirection",
        name: "取料基准角(从机床上取走，对应取机床号)",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "PutNum",
        name: "放货位号(PUT)（放回货位）",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "PutShelfNum",
        name: "放货架号",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "PutStorageType",
        name: "放货位类型",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "Finish",
        name: "任务完成（FINISH）",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "LoopFinish",
        name: "结束机器人当前主程序（跳过FINISH）",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "OnScanChuck",
        name: "扫描卡盘时处理的位置",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "TakeWight",
        name: "取工件的重量",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "PutWeight",
        name: "放工件的重量",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "WorkpiecePosOffsetX",
        name: "接驳站视觉定位偏移量X",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "WorkpiecePosOffsetY",
        name: "接驳站视觉定位偏移量Y",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'RobotTaskPosition',
        field: "WorkpiecePosOffsetZ",
        name: "接驳站视觉定位偏移量Z",
        renderType: RenderType.input),
    // RenderFieldInfo(
    //     section: 'JumpRobotTaskNode',
    //     field: "OnJumpRobotTask",
    //     name: "需要跳过的机器人任务任务码-任务码-任务码-任务码",
    //     renderType: RenderType.input),
  ];
  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = robotCommunicationProtocol.toJson();
    temp[field] = val;
    robotCommunicationProtocol = RobotCommunicationProtocol.fromJson(temp);
  }

  String? getFieldValue(String field) {
    return robotCommunicationProtocol.toJson()[field];
  }

  void onFieldChange(String field, String value) {
    if (value == getFieldValue(field)) {
      return;
    }
    if (!changedList.contains(field)) {
      changedList.add(field);
    }
    setFieldValue(field, value);
    update(["robot_communication_protocol"]);
  }

  query() async {
    ResponseApiBody res = await PlcApi.fieldQuery({
      "params": robotCommunicationProtocol.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      robotCommunicationProtocol =
          RobotCommunicationProtocol.fromJson(res.data);
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
    update(["robot_communication_protocol"]);
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

class RobotCommunicationProtocol {
  String? robotTaskPositionAsk;
  String? robotTaskPositionType;
  String? robotTaskPositionTakeNum;
  String? robotTaskPositionTakeShelfNum;
  String? robotTaskPositionTakeStorageType;
  String? robotTaskPositionPutMachineNum;
  String? robotTaskPositionPutDirection;
  String? robotTaskPositionTakeMachineNum;
  String? robotTaskPositionTakeDirection;
  String? robotTaskPositionPutNum;
  String? robotTaskPositionPutShelfNum;
  String? robotTaskPositionPutStorageType;
  String? robotTaskPositionFinish;
  String? robotTaskPositionLoopFinish;
  String? robotTaskPositionOnScanChuck;
  String? robotTaskPositionTakeWight;
  String? robotTaskPositionPutWeight;
  String? robotTaskPositionWorkpiecePosOffsetX;
  String? robotTaskPositionWorkpiecePosOffsetY;
  String? robotTaskPositionWorkpiecePosOffsetZ;

  RobotCommunicationProtocol(
      {this.robotTaskPositionAsk,
      this.robotTaskPositionType,
      this.robotTaskPositionTakeNum,
      this.robotTaskPositionTakeShelfNum,
      this.robotTaskPositionTakeStorageType,
      this.robotTaskPositionPutMachineNum,
      this.robotTaskPositionPutDirection,
      this.robotTaskPositionTakeMachineNum,
      this.robotTaskPositionTakeDirection,
      this.robotTaskPositionPutNum,
      this.robotTaskPositionPutShelfNum,
      this.robotTaskPositionPutStorageType,
      this.robotTaskPositionFinish,
      this.robotTaskPositionLoopFinish,
      this.robotTaskPositionOnScanChuck,
      this.robotTaskPositionTakeWight,
      this.robotTaskPositionPutWeight,
      this.robotTaskPositionWorkpiecePosOffsetX,
      this.robotTaskPositionWorkpiecePosOffsetY,
      this.robotTaskPositionWorkpiecePosOffsetZ});

  RobotCommunicationProtocol.fromJson(Map<String, dynamic> json) {
    robotTaskPositionAsk = json['RobotTaskPosition/Ask'];
    robotTaskPositionType = json['RobotTaskPosition/Type'];
    robotTaskPositionTakeNum = json['RobotTaskPosition/TakeNum'];
    robotTaskPositionTakeShelfNum = json['RobotTaskPosition/TakeShelfNum'];
    robotTaskPositionTakeStorageType =
        json['RobotTaskPosition/TakeStorageType'];
    robotTaskPositionPutMachineNum = json['RobotTaskPosition/PutMachineNum'];
    robotTaskPositionPutDirection = json['RobotTaskPosition/PutDirection'];
    robotTaskPositionTakeMachineNum = json['RobotTaskPosition/TakeMachineNum'];
    robotTaskPositionTakeDirection = json['RobotTaskPosition/TakeDirection'];
    robotTaskPositionPutNum = json['RobotTaskPosition/PutNum'];
    robotTaskPositionPutShelfNum = json['RobotTaskPosition/PutShelfNum'];
    robotTaskPositionPutStorageType = json['RobotTaskPosition/PutStorageType'];
    robotTaskPositionFinish = json['RobotTaskPosition/Finish'];
    robotTaskPositionLoopFinish = json['RobotTaskPosition/LoopFinish'];
    robotTaskPositionOnScanChuck = json['RobotTaskPosition/OnScanChuck'];
    robotTaskPositionTakeWight = json['RobotTaskPosition/TakeWight'];
    robotTaskPositionPutWeight = json['RobotTaskPosition/PutWeight'];
    robotTaskPositionWorkpiecePosOffsetX =
        json['RobotTaskPosition/WorkpiecePosOffsetX'];
    robotTaskPositionWorkpiecePosOffsetY =
        json['RobotTaskPosition/WorkpiecePosOffsetY'];
    robotTaskPositionWorkpiecePosOffsetZ =
        json['RobotTaskPosition/WorkpiecePosOffsetZ'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RobotTaskPosition/Ask'] = this.robotTaskPositionAsk;
    data['RobotTaskPosition/Type'] = this.robotTaskPositionType;
    data['RobotTaskPosition/TakeNum'] = this.robotTaskPositionTakeNum;
    data['RobotTaskPosition/TakeShelfNum'] = this.robotTaskPositionTakeShelfNum;
    data['RobotTaskPosition/TakeStorageType'] =
        this.robotTaskPositionTakeStorageType;
    data['RobotTaskPosition/PutMachineNum'] =
        this.robotTaskPositionPutMachineNum;
    data['RobotTaskPosition/PutDirection'] = this.robotTaskPositionPutDirection;
    data['RobotTaskPosition/TakeMachineNum'] =
        this.robotTaskPositionTakeMachineNum;
    data['RobotTaskPosition/TakeDirection'] =
        this.robotTaskPositionTakeDirection;
    data['RobotTaskPosition/PutNum'] = this.robotTaskPositionPutNum;
    data['RobotTaskPosition/PutShelfNum'] = this.robotTaskPositionPutShelfNum;
    data['RobotTaskPosition/PutStorageType'] =
        this.robotTaskPositionPutStorageType;
    data['RobotTaskPosition/Finish'] = this.robotTaskPositionFinish;
    data['RobotTaskPosition/LoopFinish'] = this.robotTaskPositionLoopFinish;
    data['RobotTaskPosition/OnScanChuck'] = this.robotTaskPositionOnScanChuck;
    data['RobotTaskPosition/TakeWight'] = this.robotTaskPositionTakeWight;
    data['RobotTaskPosition/PutWeight'] = this.robotTaskPositionPutWeight;
    data['RobotTaskPosition/WorkpiecePosOffsetX'] =
        this.robotTaskPositionWorkpiecePosOffsetX;
    data['RobotTaskPosition/WorkpiecePosOffsetY'] =
        this.robotTaskPositionWorkpiecePosOffsetY;
    data['RobotTaskPosition/WorkpiecePosOffsetZ'] =
        this.robotTaskPositionWorkpiecePosOffsetZ;
    return data;
  }
}
