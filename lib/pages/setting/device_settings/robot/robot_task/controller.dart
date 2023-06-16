import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';

class RobotTaskController extends GetxController {
  RobotTaskController();
  RobotTask robotTask = RobotTask();
  List<RenderFieldInfo> menuList = [
    RenderFieldInfo(
      section: "RobotTaskConfig",
      field: "RobotClampType",
      name: "卡爪个数",
      renderType: RenderType.radio,
      options: {"单卡爪": "1", "双卡爪": "2"},
    ),
    RenderFieldInfo(
        section: "RobotTaskConfig",
        field: "AheadTaskWaitTime",
        name: "提前上料时等待时间拿回（分钟）",
        renderType: RenderType.numberInput),
    RenderFieldInfo(
        section: "RobotTaskConfig",
        field: "RobotWaitFinishTime",
        name: "机器人任务发出去默认等待时间,单位：分钟",
        renderType: RenderType.numberInput),
    RenderFieldInfo(
        section: "RobotTaskConfig",
        field: "OnJumpRobotTask",
        name: "需要跳过的机器人任务任务码-任务码-任务码-任务码",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: "RobotTaskConfig",
        field: "RobotCarryWorkpieceTaskType",
        name: "机器人把工件从装载站/接驳站搬运到货架的方式",
        renderType: RenderType.select,
        options: {
          "默认普通的任务8": "0",
          "任务9，搬运任务自带扫描芯片属性": "1",
          "8+1(搬运任务+扫描任务)": "3"
        }),
    RenderFieldInfo(
        section: "RobotTaskConfig",
        field: "TransferUIShow",
        name: "机器人界面显示标志",
        renderType: RenderType.toggleSwitch,
        options: {"显示": "1", "不显示": "0"}),
    RenderFieldInfo(
        section: "RobotTaskConfig",
        field: "TaskType",
        name: "机器人可执行任务配置",
        renderType: RenderType.input),
  ];
  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = robotTask.toJson();
    temp[field] = val;
    robotTask = RobotTask.fromJson(temp);
  }

  String? getFieldValue(String field) {
    return robotTask.toJson()[field];
  }

  void onFieldChange(String field, String value) {
    if (value == getFieldValue(field)) {
      return;
    }
    if (!changedList.contains(field)) {
      changedList.add(field);
    }
    setFieldValue(field, value);
    update(["robot_task"]);
  }

  _initData() {
    update(["robot_task"]);
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

class RobotTask {
  String? robotTaskConfigRobotClampType;
  String? robotTaskConfigAheadTaskWaitTime;
  String? robotTaskConfigRobotWaitFinishTime;
  String? robotTaskConfigOnJumpRobotTask;
  String? robotTaskConfigRobotCarryWorkpieceTaskType;
  String? robotTaskConfigTransferUIShow;
  String? robotTaskConfigTaskType;

  RobotTask(
      {this.robotTaskConfigRobotClampType,
      this.robotTaskConfigAheadTaskWaitTime,
      this.robotTaskConfigRobotWaitFinishTime,
      this.robotTaskConfigOnJumpRobotTask,
      this.robotTaskConfigRobotCarryWorkpieceTaskType,
      this.robotTaskConfigTransferUIShow,
      this.robotTaskConfigTaskType});

  RobotTask.fromJson(Map<String, dynamic> json) {
    robotTaskConfigRobotClampType = json['RobotTaskConfig/RobotClampType'];
    robotTaskConfigAheadTaskWaitTime =
        json['RobotTaskConfig/AheadTaskWaitTime'];
    robotTaskConfigRobotWaitFinishTime =
        json['RobotTaskConfig/RobotWaitFinishTime'];
    robotTaskConfigOnJumpRobotTask = json['RobotTaskConfig/OnJumpRobotTask'];
    robotTaskConfigRobotCarryWorkpieceTaskType =
        json['RobotTaskConfig/RobotCarryWorkpieceTaskType'];
    robotTaskConfigTransferUIShow = json['RobotTaskConfig/TransferUIShow'];
    robotTaskConfigTaskType = json['RobotTaskConfig/TaskType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RobotTaskConfig/RobotClampType'] = this.robotTaskConfigRobotClampType;
    data['RobotTaskConfig/AheadTaskWaitTime'] =
        this.robotTaskConfigAheadTaskWaitTime;
    data['RobotTaskConfig/RobotWaitFinishTime'] =
        this.robotTaskConfigRobotWaitFinishTime;
    data['RobotTaskConfig/OnJumpRobotTask'] =
        this.robotTaskConfigOnJumpRobotTask;
    data['RobotTaskConfig/RobotCarryWorkpieceTaskType'] =
        this.robotTaskConfigRobotCarryWorkpieceTaskType;
    data['RobotTaskConfig/TransferUIShow'] = this.robotTaskConfigTransferUIShow;
    data['RobotTaskConfig/TaskType'] = this.robotTaskConfigTaskType;
    return data;
  }
}
