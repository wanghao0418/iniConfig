import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';

class PlcCommunicationProtocolController extends GetxController {
  PlcCommunicationProtocolController();
  List<RenderFieldInfo> renderList = [];
  PlcCommunicationProtocol plcCommunicationProtocol =
      PlcCommunicationProtocol();
  List<RenderFieldInfo> modbusAreaList = [
    RenderFieldInfo(
      section: 'Plc_M_Block',
      field: 'CMD_ID_R_OPUTS',
      name: '读取多个I点',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      section: 'Plc_M_Block',
      field: 'CMD_ID_R_IPUTS',
      name: '读取多个O点',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      section: 'Plc_M_Block',
      field: 'CMD_ID_R_REGS',
      name: '读取多个寄存器',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      section: 'Plc_M_Block',
      field: 'CMD_ID_W_OPUT',
      name: '写单个O点',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      section: 'Plc_M_Block',
      field: 'CMD_ID_W_OPUTS',
      name: '写多个O点',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      section: 'Plc_M_Block',
      field: 'CMD_ID_W_REGS',
      name: '写多寄存器',
      renderType: RenderType.input,
    ),
  ];
  // 命令区
  List<RenderFieldInfo> commandAreaList = [
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'RobotMainPrgRun',
        name: '机器人主程序运行',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'RobotPause',
        name: '机器人暂停继续',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'Buzzer',
        name: '蜂鸣器地址',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'GuideRun',
        name: '导轨运动标识',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'ServoAlarmReset',
        name: '伺服报警复位',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'OpenDoor',
        name: '货架电磁门开门',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'OpenDoor2',
        name: '货架电磁门开门',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'MachineRun',
        name: '机床启动的起始地址',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'MachineRest',
        name: '机床复位的起始地址',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'MahicneNumToPlc',
        name: '执行机器人任务时传递给PLC的机床号地址',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'StorageNumToPlc',
        name: '执行机器人任务时传递给PLC的货位号地址',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'ShelfUpLineCtrl',
        name: '货架上下线控制',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'MachineUpLineCtrl',
        name: '机床上下线控制',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'MachineStatusLightCtrl',
        name: '机床状态灯的控制',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'RotatShelfRun',
        name: '启动旋转货架旋转',
        renderType: RenderType.input),
  ];
  // 扩展区
  List<RenderFieldInfo> expandAreaList = [
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'RobotTaskType',
        name: '任务类型',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'TakeStorageNum',
        name: '取货位号',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'PutStorageNum',
        name: '放货位号',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'CmmMachineStatusByIO',
        name: 'IO给出的CMM机床状态',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'TransferShelfOnLineAsk',
        name: '装载站上线请求',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'TransferShelfOffLineAsk',
        name: '装载站下线请求',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'TransferStorageSensorStatus',
        name: '装载站货位状态',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'TransferShelfButtonStatus',
        name: '装载站货架按钮灯',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'TransferStorageRotatLocationStatus',
        name: '装载站旋定位状态',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'TransferDoorStatus',
        name: '装载站门状态',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'OilGrooveUpCtrl',
        name: '油槽升降地址',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'OilGroCtrlMacNum',
        name: '配合油槽升降的机床号',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'StopBlow',
        name: '机床吹气',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'ConnectStationOffX',
        name: '给机器人写接驳站偏移量X的起始地址',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'ConnectStationOffY',
        name: '给机器人写接驳站偏移量Y的起始地址',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'ConnectStationOffZ',
        name: '给机器人写接驳站偏移量Z的起始地址',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'MacStartPumpingAdd',
        name: '火花机抽油启动地址',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'MacPumpingStopTime',
        name: '火花机抽油时间地址',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: 'TranSportStorageStatus',
        name: '配合武城职接驳站单独拎出来用于判断接驳站货位状态',
        renderType: RenderType.input),
  ];
  // 监控区
  List<RenderFieldInfo> monitorAreaList = [
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "BaseInfo",
        name: "基础信息, 同时也是监控区的起始地址",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "ShelfDoor",
        name: "货架门",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "ShelfDoor2",
        name: "货架门",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MacFenceDoorStatus",
        name: "机床围栏门状态",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MacFenceDoorBrakingStatus",
        name: "机床围栏门急停",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "FencePneumaticDoorStatus",
        name: "机床外围的安全气动门状态(由plc控制)",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "FenceDoor",
        name: "围栏门",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "AccompanyPlat",
        name: "随行台and导轨",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MachineFinish",
        name: "PLC控制启动的机床",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MachineFinish2",
        name: "PLC控制启动的机床",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "ShelfOnlineAsk",
        name: "货架上线请求",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "ShelfOnlineAsk2",
        name: "货架上线请求",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "ShelfOfflineAsk",
        name: "货架下线请求",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "ShelfOfflineAsk2",
        name: "货架下线请求",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "ShelfOpenDoorAsk",
        name: "货架开门信号",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "ShelfEmergencyStop",
        name: "货架急停",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "ShelfEmergencyStop2",
        name: "货架急停",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "FenceEmergencyStop",
        name: "电脑柜and围栏门急停",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "ChuckLockUnLockStatus",
        name: "卡盘锁紧松开状态",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "ChuckAirtightness",
        name: "机床卡盘气密性状态",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "ChuckAirtightness2",
        name: "机床卡盘气密性状态",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "ChuckOpenCloseStatus",
        name: "卡盘锁紧/松开功能异常",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "ChuckOpenCloseStatus2",
        name: "卡盘锁紧/松开功能异常",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "PressureValue",
        name: "气压值",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MacAutoDoorStatus",
        name: "机床自动门异常",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MacAutoDoorStatus2",
        name: "机床自动门异常",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MacOriginPosCheck",
        name: "机床原点检测",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MacOriginPosCheck2",
        name: "机床原点检测",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MacOnlineAsk",
        name: "机床上线请求",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MacOnlineAsk2",
        name: "机床上线请求",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MacOfflineAsk",
        name: "机床下线请求",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MacOfflineAsk2",
        name: "机床下线请求",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MachineError",
        name: "机床报警",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MachineError2",
        name: "机床报警",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "RotatShelfScanFinish",
        name: "旋转货架扫描完成",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "RotatShelfScanFinish2",
        name: "旋转货架扫描完成",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MacObstructionCheck",
        name: "机床上料阻碍标识检测",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MacObstructionCheck2",
        name: "机床上料阻碍标识检测",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MacWasteMonitor",
        name: "机床废料监控",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "MacWasteMonitor2",
        name: "机床废料监控",
        renderType: RenderType.input),
  ];
  // 货位区
  List<RenderFieldInfo> locationAreaList = [
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "StorageSensorStatus",
        name: "货位状态地址",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "StorageLightCtrl",
        name: "货位灯的地址",
        renderType: RenderType.input),
  ];
  // 标识符
  List<RenderFieldInfo> identificationAreaList = [
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "CMD_IDF_PRESSURE",
        name: "压力标识",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "CMD_IDF_CLAMP",
        name: "卡爪夹取标识",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "CMD_IDF_ROBOT_CONTROL_CABINET",
        name: "机器人控制柜标识",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "CMD_IDF_ROBOT_HANDY_PANEL",
        name: "机器人手持盒标识",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "CMD_IDF_CHUCK_SCAN",
        name: "卡盘电极扫描标识",
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Plc_M_Block',
        field: "CMD_IDF_ROBOT_SAFE_POSITION",
        name: "机器人安全位置",
        renderType: RenderType.input),
    // RenderFieldInfo(
    //     section: 'PlcDefinition',
    //     field: "OkLight",
    //     name: "货位灯颜色的定义",
    //     renderType: RenderType.select,
    //     options: {"亮绿灯": "1", "亮红灯": "2", "亮黄灯": "3"}),
    // RenderFieldInfo(
    //     section: 'PlcDefinition',
    //     field: "NgLight",
    //     name: "货位灯颜色的定义",
    //     renderType: RenderType.select,
    //     options: {"亮绿灯": "1", "亮红灯": "2", "亮黄灯": "3"}),
    // RenderFieldInfo(
    //     section: 'PlcDefinition',
    //     field: "WarnLight",
    //     name: "货位灯颜色的定义",
    //     renderType: RenderType.select,
    //     options: {"亮绿灯": "1", "亮红灯": "2", "亮黄灯": "3"}),
  ];
  List<RenderFieldInfo> correspondingAreaList = [
    RenderFieldInfo(
        section: 'PlcDbBlock',
        field: "RfidRead",
        name: "对射货架货架初始读取地址",
        renderType: RenderType.input),
  ];
  List<String> changedList = [];
  _initData() {
    update(["plc_communication_protocol"]);
  }

  String? getFieldValue(String field) {
    return plcCommunicationProtocol.toJson()[field];
  }

  void setFieldValue(String field, String val) {
    var temp = plcCommunicationProtocol.toJson();
    temp[field] = val;
    plcCommunicationProtocol = PlcCommunicationProtocol.fromJson(temp);
  }

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void onFieldChange(String field, String value) {
    if (value == getFieldValue(field)) {
      return;
    }
    if (!changedList.contains(field)) {
      changedList.add(field);
    }
    setFieldValue(field, value);
    update(["plc_communication_protocol"]);
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

class PlcCommunicationProtocol {
  String? plcMBlockCMDIDROPUTS;
  String? plcMBlockCMDIDRIPUTS;
  String? plcMBlockCMDIDRREGS;
  String? plcMBlockCMDIDWOPUT;
  String? plcMBlockCMDIDWOPUTS;
  String? plcMBlockCMDIDWREGS;
  String? plcMBlockRobotMainPrgRun;
  String? plcMBlockRobotPause;
  String? plcMBlockBuzzer;
  String? plcMBlockGuideRun;
  String? plcMBlockServoAlarmReset;
  String? plcMBlockOpenDoor;
  String? plcMBlockOpenDoor2;
  String? plcMBlockMachineRun;
  String? plcMBlockMachineRest;
  String? plcMBlockMahicneNumToPlc;
  String? plcMBlockStorageNumToPlc;
  String? plcMBlockShelfUpLineCtrl;
  String? plcMBlockMachineUpLineCtrl;
  String? plcMBlockMachineStatusLightCtrl;
  String? plcMBlockRotatShelfRun;
  String? plcMBlockRobotTaskType;
  String? plcMBlockTakeStorageNum;
  String? plcMBlockPutStorageNum;
  String? plcMBlockCmmMachineStatusByIO;
  String? plcMBlockTransferShelfOnLineAsk;
  String? plcMBlockTransferShelfOffLineAsk;
  String? plcMBlockTransferStorageSensorStatus;
  String? plcMBlockTransferShelfButtonStatus;
  String? plcMBlockTransferStorageRotatLocationStatus;
  String? plcMBlockTransferDoorStatus;
  String? plcMBlockOilGrooveUpCtrl;
  String? plcMBlockOilGroCtrlMacNum;
  String? plcMBlockStopBlow;
  String? plcMBlockConnectStationOffX;
  String? plcMBlockConnectStationOffY;
  String? plcMBlockConnectStationOffZ;
  String? plcMBlockMacStartPumpingAdd;
  String? plcMBlockMacPumpingStopTime;
  String? plcMBlockTranSportStorageStatus;
  String? plcMBlockBaseInfo;
  String? plcMBlockShelfDoor;
  String? plcMBlockShelfDoor2;
  String? plcMBlockMacFenceDoorStatus;
  String? plcMBlockMacFenceDoorBrakingStatus;
  String? plcMBlockFencePneumaticDoorStatus;
  String? plcMBlockFenceDoor;
  String? plcMBlockAccompanyPlat;
  String? plcMBlockMachineFinish;
  String? plcMBlockMachineFinish2;
  String? plcMBlockShelfOnlineAsk;
  String? plcMBlockShelfOnlineAsk2;
  String? plcMBlockShelfOfflineAsk;
  String? plcMBlockShelfOfflineAsk2;
  String? plcMBlockShelfOpenDoorAsk;
  String? plcMBlockShelfEmergencyStop;
  String? plcMBlockShelfEmergencyStop2;
  String? plcMBlockFenceEmergencyStop;
  String? plcMBlockChuckLockUnLockStatus;
  String? plcMBlockChuckAirtightness;
  String? plcMBlockChuckAirtightness2;
  String? plcMBlockChuckOpenCloseStatus;
  String? plcMBlockChuckOpenCloseStatus2;
  String? plcMBlockPressureValue;
  String? plcMBlockMacAutoDoorStatus;
  String? plcMBlockMacAutoDoorStatus2;
  String? plcMBlockMacOriginPosCheck;
  String? plcMBlockMacOriginPosCheck2;
  String? plcMBlockMacOnlineAsk;
  String? plcMBlockMacOnlineAsk2;
  String? plcMBlockMacOfflineAsk;
  String? plcMBlockMacOfflineAsk2;
  String? plcMBlockMachineError;
  String? plcMBlockMachineError2;
  String? plcMBlockRotatShelfScanFinish;
  String? plcMBlockRotatShelfScanFinish2;
  String? plcMBlockMacObstructionCheck;
  String? plcMBlockMacObstructionCheck2;
  String? plcMBlockMacWasteMonitor;
  String? plcMBlockMacWasteMonitor2;
  String? plcMBlockStorageSensorStatus;
  String? plcMBlockStorageLightCtrl;
  String? plcMBlockCMDIDFPRESSURE;
  String? plcMBlockCMDIDFCLAMP;
  String? plcMBlockCMDIDFROBOTCONTROLCABINET;
  String? plcMBlockCMDIDFROBOTHANDYPANEL;
  String? plcMBlockCMDIDFCHUCKSCAN;
  String? plcMBlockCMDIDFROBOTSAFEPOSITION;
  String? plcDbBlockRfidRead;

  PlcCommunicationProtocol(
      {this.plcMBlockCMDIDROPUTS,
      this.plcMBlockCMDIDRIPUTS,
      this.plcMBlockCMDIDRREGS,
      this.plcMBlockCMDIDWOPUT,
      this.plcMBlockCMDIDWOPUTS,
      this.plcMBlockCMDIDWREGS,
      this.plcMBlockRobotMainPrgRun,
      this.plcMBlockRobotPause,
      this.plcMBlockBuzzer,
      this.plcMBlockGuideRun,
      this.plcMBlockServoAlarmReset,
      this.plcMBlockOpenDoor,
      this.plcMBlockOpenDoor2,
      this.plcMBlockMachineRun,
      this.plcMBlockMachineRest,
      this.plcMBlockMahicneNumToPlc,
      this.plcMBlockStorageNumToPlc,
      this.plcMBlockShelfUpLineCtrl,
      this.plcMBlockMachineUpLineCtrl,
      this.plcMBlockMachineStatusLightCtrl,
      this.plcMBlockRotatShelfRun,
      this.plcMBlockRobotTaskType,
      this.plcMBlockTakeStorageNum,
      this.plcMBlockPutStorageNum,
      this.plcMBlockCmmMachineStatusByIO,
      this.plcMBlockTransferShelfOnLineAsk,
      this.plcMBlockTransferShelfOffLineAsk,
      this.plcMBlockTransferStorageSensorStatus,
      this.plcMBlockTransferShelfButtonStatus,
      this.plcMBlockTransferStorageRotatLocationStatus,
      this.plcMBlockTransferDoorStatus,
      this.plcMBlockOilGrooveUpCtrl,
      this.plcMBlockOilGroCtrlMacNum,
      this.plcMBlockStopBlow,
      this.plcMBlockConnectStationOffX,
      this.plcMBlockConnectStationOffY,
      this.plcMBlockConnectStationOffZ,
      this.plcMBlockMacStartPumpingAdd,
      this.plcMBlockMacPumpingStopTime,
      this.plcMBlockTranSportStorageStatus,
      this.plcMBlockBaseInfo,
      this.plcMBlockShelfDoor,
      this.plcMBlockShelfDoor2,
      this.plcMBlockMacFenceDoorStatus,
      this.plcMBlockMacFenceDoorBrakingStatus,
      this.plcMBlockFencePneumaticDoorStatus,
      this.plcMBlockFenceDoor,
      this.plcMBlockAccompanyPlat,
      this.plcMBlockMachineFinish,
      this.plcMBlockMachineFinish2,
      this.plcMBlockShelfOnlineAsk,
      this.plcMBlockShelfOnlineAsk2,
      this.plcMBlockShelfOfflineAsk,
      this.plcMBlockShelfOfflineAsk2,
      this.plcMBlockShelfOpenDoorAsk,
      this.plcMBlockShelfEmergencyStop,
      this.plcMBlockShelfEmergencyStop2,
      this.plcMBlockFenceEmergencyStop,
      this.plcMBlockChuckLockUnLockStatus,
      this.plcMBlockChuckAirtightness,
      this.plcMBlockChuckAirtightness2,
      this.plcMBlockChuckOpenCloseStatus,
      this.plcMBlockChuckOpenCloseStatus2,
      this.plcMBlockPressureValue,
      this.plcMBlockMacAutoDoorStatus,
      this.plcMBlockMacAutoDoorStatus2,
      this.plcMBlockMacOriginPosCheck,
      this.plcMBlockMacOriginPosCheck2,
      this.plcMBlockMacOnlineAsk,
      this.plcMBlockMacOnlineAsk2,
      this.plcMBlockMacOfflineAsk,
      this.plcMBlockMacOfflineAsk2,
      this.plcMBlockMachineError,
      this.plcMBlockMachineError2,
      this.plcMBlockRotatShelfScanFinish,
      this.plcMBlockRotatShelfScanFinish2,
      this.plcMBlockMacObstructionCheck,
      this.plcMBlockMacObstructionCheck2,
      this.plcMBlockMacWasteMonitor,
      this.plcMBlockMacWasteMonitor2,
      this.plcMBlockStorageSensorStatus,
      this.plcMBlockStorageLightCtrl,
      this.plcMBlockCMDIDFPRESSURE,
      this.plcMBlockCMDIDFCLAMP,
      this.plcMBlockCMDIDFROBOTCONTROLCABINET,
      this.plcMBlockCMDIDFROBOTHANDYPANEL,
      this.plcMBlockCMDIDFCHUCKSCAN,
      this.plcMBlockCMDIDFROBOTSAFEPOSITION,
      this.plcDbBlockRfidRead});

  PlcCommunicationProtocol.fromJson(Map<String, dynamic> json) {
    plcMBlockCMDIDROPUTS = json['Plc_M_Block/CMD_ID_R_OPUTS'];
    plcMBlockCMDIDRIPUTS = json['Plc_M_Block/CMD_ID_R_IPUTS'];
    plcMBlockCMDIDRREGS = json['Plc_M_Block/CMD_ID_R_REGS'];
    plcMBlockCMDIDWOPUT = json['Plc_M_Block/CMD_ID_W_OPUT'];
    plcMBlockCMDIDWOPUTS = json['Plc_M_Block/CMD_ID_W_OPUTS'];
    plcMBlockCMDIDWREGS = json['Plc_M_Block/CMD_ID_W_REGS'];
    plcMBlockRobotMainPrgRun = json['Plc_M_Block/RobotMainPrgRun'];
    plcMBlockRobotPause = json['Plc_M_Block/RobotPause'];
    plcMBlockBuzzer = json['Plc_M_Block/Buzzer'];
    plcMBlockGuideRun = json['Plc_M_Block/GuideRun'];
    plcMBlockServoAlarmReset = json['Plc_M_Block/ServoAlarmReset'];
    plcMBlockOpenDoor = json['Plc_M_Block/OpenDoor'];
    plcMBlockOpenDoor2 = json['Plc_M_Block/OpenDoor2'];
    plcMBlockMachineRun = json['Plc_M_Block/MachineRun'];
    plcMBlockMachineRest = json['Plc_M_Block/MachineRest'];
    plcMBlockMahicneNumToPlc = json['Plc_M_Block/MahicneNumToPlc'];
    plcMBlockStorageNumToPlc = json['Plc_M_Block/StorageNumToPlc'];
    plcMBlockShelfUpLineCtrl = json['Plc_M_Block/ShelfUpLineCtrl'];
    plcMBlockMachineUpLineCtrl = json['Plc_M_Block/MachineUpLineCtrl'];
    plcMBlockMachineStatusLightCtrl =
        json['Plc_M_Block/MachineStatusLightCtrl'];
    plcMBlockRotatShelfRun = json['Plc_M_Block/RotatShelfRun'];
    plcMBlockRobotTaskType = json['Plc_M_Block/RobotTaskType'];
    plcMBlockTakeStorageNum = json['Plc_M_Block/TakeStorageNum'];
    plcMBlockPutStorageNum = json['Plc_M_Block/PutStorageNum'];
    plcMBlockCmmMachineStatusByIO = json['Plc_M_Block/CmmMachineStatusByIO'];
    plcMBlockTransferShelfOnLineAsk =
        json['Plc_M_Block/TransferShelfOnLineAsk'];
    plcMBlockTransferShelfOffLineAsk =
        json['Plc_M_Block/TransferShelfOffLineAsk'];
    plcMBlockTransferStorageSensorStatus =
        json['Plc_M_Block/TransferStorageSensorStatus'];
    plcMBlockTransferShelfButtonStatus =
        json['Plc_M_Block/TransferShelfButtonStatus'];
    plcMBlockTransferStorageRotatLocationStatus =
        json['Plc_M_Block/TransferStorageRotatLocationStatus'];
    plcMBlockTransferDoorStatus = json['Plc_M_Block/TransferDoorStatus'];
    plcMBlockOilGrooveUpCtrl = json['Plc_M_Block/OilGrooveUpCtrl'];
    plcMBlockOilGroCtrlMacNum = json['Plc_M_Block/OilGroCtrlMacNum'];
    plcMBlockStopBlow = json['Plc_M_Block/StopBlow'];
    plcMBlockConnectStationOffX = json['Plc_M_Block/ConnectStationOffX'];
    plcMBlockConnectStationOffY = json['Plc_M_Block/ConnectStationOffY'];
    plcMBlockConnectStationOffZ = json['Plc_M_Block/ConnectStationOffZ'];
    plcMBlockMacStartPumpingAdd = json['Plc_M_Block/MacStartPumpingAdd'];
    plcMBlockMacPumpingStopTime = json['Plc_M_Block/MacPumpingStopTime'];
    plcMBlockTranSportStorageStatus =
        json['Plc_M_Block/TranSportStorageStatus'];
    plcMBlockBaseInfo = json['Plc_M_Block/BaseInfo'];
    plcMBlockShelfDoor = json['Plc_M_Block/ShelfDoor'];
    plcMBlockShelfDoor2 = json['Plc_M_Block/ShelfDoor2'];
    plcMBlockMacFenceDoorStatus = json['Plc_M_Block/MacFenceDoorStatus'];
    plcMBlockMacFenceDoorBrakingStatus =
        json['Plc_M_Block/MacFenceDoorBrakingStatus'];
    plcMBlockFencePneumaticDoorStatus =
        json['Plc_M_Block/FencePneumaticDoorStatus'];
    plcMBlockFenceDoor = json['Plc_M_Block/FenceDoor'];
    plcMBlockAccompanyPlat = json['Plc_M_Block/AccompanyPlat'];
    plcMBlockMachineFinish = json['Plc_M_Block/MachineFinish'];
    plcMBlockMachineFinish2 = json['Plc_M_Block/MachineFinish2'];
    plcMBlockShelfOnlineAsk = json['Plc_M_Block/ShelfOnlineAsk'];
    plcMBlockShelfOnlineAsk2 = json['Plc_M_Block/ShelfOnlineAsk2'];
    plcMBlockShelfOfflineAsk = json['Plc_M_Block/ShelfOfflineAsk'];
    plcMBlockShelfOfflineAsk2 = json['Plc_M_Block/ShelfOfflineAsk2'];
    plcMBlockShelfOpenDoorAsk = json['Plc_M_Block/ShelfOpenDoorAsk'];
    plcMBlockShelfEmergencyStop = json['Plc_M_Block/ShelfEmergencyStop'];
    plcMBlockShelfEmergencyStop2 = json['Plc_M_Block/ShelfEmergencyStop2'];
    plcMBlockFenceEmergencyStop = json['Plc_M_Block/FenceEmergencyStop'];
    plcMBlockChuckLockUnLockStatus = json['Plc_M_Block/ChuckLockUnLockStatus'];
    plcMBlockChuckAirtightness = json['Plc_M_Block/ChuckAirtightness'];
    plcMBlockChuckAirtightness2 = json['Plc_M_Block/ChuckAirtightness2'];
    plcMBlockChuckOpenCloseStatus = json['Plc_M_Block/ChuckOpenCloseStatus'];
    plcMBlockChuckOpenCloseStatus2 = json['Plc_M_Block/ChuckOpenCloseStatus2'];
    plcMBlockPressureValue = json['Plc_M_Block/PressureValue'];
    plcMBlockMacAutoDoorStatus = json['Plc_M_Block/MacAutoDoorStatus'];
    plcMBlockMacAutoDoorStatus2 = json['Plc_M_Block/MacAutoDoorStatus2'];
    plcMBlockMacOriginPosCheck = json['Plc_M_Block/MacOriginPosCheck'];
    plcMBlockMacOriginPosCheck2 = json['Plc_M_Block/MacOriginPosCheck2'];
    plcMBlockMacOnlineAsk = json['Plc_M_Block/MacOnlineAsk'];
    plcMBlockMacOnlineAsk2 = json['Plc_M_Block/MacOnlineAsk2'];
    plcMBlockMacOfflineAsk = json['Plc_M_Block/MacOfflineAsk'];
    plcMBlockMacOfflineAsk2 = json['Plc_M_Block/MacOfflineAsk2'];
    plcMBlockMachineError = json['Plc_M_Block/MachineError'];
    plcMBlockMachineError2 = json['Plc_M_Block/MachineError2'];
    plcMBlockRotatShelfScanFinish = json['Plc_M_Block/RotatShelfScanFinish'];
    plcMBlockRotatShelfScanFinish2 = json['Plc_M_Block/RotatShelfScanFinish2'];
    plcMBlockMacObstructionCheck = json['Plc_M_Block/MacObstructionCheck'];
    plcMBlockMacObstructionCheck2 = json['Plc_M_Block/MacObstructionCheck2'];
    plcMBlockMacWasteMonitor = json['Plc_M_Block/MacWasteMonitor'];
    plcMBlockMacWasteMonitor2 = json['Plc_M_Block/MacWasteMonitor2'];
    plcMBlockStorageSensorStatus = json['Plc_M_Block/StorageSensorStatus'];
    plcMBlockStorageLightCtrl = json['Plc_M_Block/StorageLightCtrl'];
    plcMBlockCMDIDFPRESSURE = json['Plc_M_Block/CMD_IDF_PRESSURE'];
    plcMBlockCMDIDFCLAMP = json['Plc_M_Block/CMD_IDF_CLAMP'];
    plcMBlockCMDIDFROBOTCONTROLCABINET =
        json['Plc_M_Block/CMD_IDF_ROBOT_CONTROL_CABINET'];
    plcMBlockCMDIDFROBOTHANDYPANEL =
        json['Plc_M_Block/CMD_IDF_ROBOT_HANDY_PANEL'];
    plcMBlockCMDIDFCHUCKSCAN = json['Plc_M_Block/CMD_IDF_CHUCK_SCAN'];
    plcMBlockCMDIDFROBOTSAFEPOSITION =
        json['Plc_M_Block/CMD_IDF_ROBOT_SAFE_POSITION'];
    plcDbBlockRfidRead = json['PlcDbBlock/RfidRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Plc_M_Block/CMD_ID_R_OPUTS'] = this.plcMBlockCMDIDROPUTS;
    data['Plc_M_Block/CMD_ID_R_IPUTS'] = this.plcMBlockCMDIDRIPUTS;
    data['Plc_M_Block/CMD_ID_R_REGS'] = this.plcMBlockCMDIDRREGS;
    data['Plc_M_Block/CMD_ID_W_OPUT'] = this.plcMBlockCMDIDWOPUT;
    data['Plc_M_Block/CMD_ID_W_OPUTS'] = this.plcMBlockCMDIDWOPUTS;
    data['Plc_M_Block/CMD_ID_W_REGS'] = this.plcMBlockCMDIDWREGS;
    data['Plc_M_Block/RobotMainPrgRun'] = this.plcMBlockRobotMainPrgRun;
    data['Plc_M_Block/RobotPause'] = this.plcMBlockRobotPause;
    data['Plc_M_Block/Buzzer'] = this.plcMBlockBuzzer;
    data['Plc_M_Block/GuideRun'] = this.plcMBlockGuideRun;
    data['Plc_M_Block/ServoAlarmReset'] = this.plcMBlockServoAlarmReset;
    data['Plc_M_Block/OpenDoor'] = this.plcMBlockOpenDoor;
    data['Plc_M_Block/OpenDoor2'] = this.plcMBlockOpenDoor2;
    data['Plc_M_Block/MachineRun'] = this.plcMBlockMachineRun;
    data['Plc_M_Block/MachineRest'] = this.plcMBlockMachineRest;
    data['Plc_M_Block/MahicneNumToPlc'] = this.plcMBlockMahicneNumToPlc;
    data['Plc_M_Block/StorageNumToPlc'] = this.plcMBlockStorageNumToPlc;
    data['Plc_M_Block/ShelfUpLineCtrl'] = this.plcMBlockShelfUpLineCtrl;
    data['Plc_M_Block/MachineUpLineCtrl'] = this.plcMBlockMachineUpLineCtrl;
    data['Plc_M_Block/MachineStatusLightCtrl'] =
        this.plcMBlockMachineStatusLightCtrl;
    data['Plc_M_Block/RotatShelfRun'] = this.plcMBlockRotatShelfRun;
    data['Plc_M_Block/RobotTaskType'] = this.plcMBlockRobotTaskType;
    data['Plc_M_Block/TakeStorageNum'] = this.plcMBlockTakeStorageNum;
    data['Plc_M_Block/PutStorageNum'] = this.plcMBlockPutStorageNum;
    data['Plc_M_Block/CmmMachineStatusByIO'] =
        this.plcMBlockCmmMachineStatusByIO;
    data['Plc_M_Block/TransferShelfOnLineAsk'] =
        this.plcMBlockTransferShelfOnLineAsk;
    data['Plc_M_Block/TransferShelfOffLineAsk'] =
        this.plcMBlockTransferShelfOffLineAsk;
    data['Plc_M_Block/TransferStorageSensorStatus'] =
        this.plcMBlockTransferStorageSensorStatus;
    data['Plc_M_Block/TransferShelfButtonStatus'] =
        this.plcMBlockTransferShelfButtonStatus;
    data['Plc_M_Block/TransferStorageRotatLocationStatus'] =
        this.plcMBlockTransferStorageRotatLocationStatus;
    data['Plc_M_Block/TransferDoorStatus'] = this.plcMBlockTransferDoorStatus;
    data['Plc_M_Block/OilGrooveUpCtrl'] = this.plcMBlockOilGrooveUpCtrl;
    data['Plc_M_Block/OilGroCtrlMacNum'] = this.plcMBlockOilGroCtrlMacNum;
    data['Plc_M_Block/StopBlow'] = this.plcMBlockStopBlow;
    data['Plc_M_Block/ConnectStationOffX'] = this.plcMBlockConnectStationOffX;
    data['Plc_M_Block/ConnectStationOffY'] = this.plcMBlockConnectStationOffY;
    data['Plc_M_Block/ConnectStationOffZ'] = this.plcMBlockConnectStationOffZ;
    data['Plc_M_Block/MacStartPumpingAdd'] = this.plcMBlockMacStartPumpingAdd;
    data['Plc_M_Block/MacPumpingStopTime'] = this.plcMBlockMacPumpingStopTime;
    data['Plc_M_Block/TranSportStorageStatus'] =
        this.plcMBlockTranSportStorageStatus;
    data['Plc_M_Block/BaseInfo'] = this.plcMBlockBaseInfo;
    data['Plc_M_Block/ShelfDoor'] = this.plcMBlockShelfDoor;
    data['Plc_M_Block/ShelfDoor2'] = this.plcMBlockShelfDoor2;
    data['Plc_M_Block/MacFenceDoorStatus'] = this.plcMBlockMacFenceDoorStatus;
    data['Plc_M_Block/MacFenceDoorBrakingStatus'] =
        this.plcMBlockMacFenceDoorBrakingStatus;
    data['Plc_M_Block/FencePneumaticDoorStatus'] =
        this.plcMBlockFencePneumaticDoorStatus;
    data['Plc_M_Block/FenceDoor'] = this.plcMBlockFenceDoor;
    data['Plc_M_Block/AccompanyPlat'] = this.plcMBlockAccompanyPlat;
    data['Plc_M_Block/MachineFinish'] = this.plcMBlockMachineFinish;
    data['Plc_M_Block/MachineFinish2'] = this.plcMBlockMachineFinish2;
    data['Plc_M_Block/ShelfOnlineAsk'] = this.plcMBlockShelfOnlineAsk;
    data['Plc_M_Block/ShelfOnlineAsk2'] = this.plcMBlockShelfOnlineAsk2;
    data['Plc_M_Block/ShelfOfflineAsk'] = this.plcMBlockShelfOfflineAsk;
    data['Plc_M_Block/ShelfOfflineAsk2'] = this.plcMBlockShelfOfflineAsk2;
    data['Plc_M_Block/ShelfOpenDoorAsk'] = this.plcMBlockShelfOpenDoorAsk;
    data['Plc_M_Block/ShelfEmergencyStop'] = this.plcMBlockShelfEmergencyStop;
    data['Plc_M_Block/ShelfEmergencyStop2'] = this.plcMBlockShelfEmergencyStop2;
    data['Plc_M_Block/FenceEmergencyStop'] = this.plcMBlockFenceEmergencyStop;
    data['Plc_M_Block/ChuckLockUnLockStatus'] =
        this.plcMBlockChuckLockUnLockStatus;
    data['Plc_M_Block/ChuckAirtightness'] = this.plcMBlockChuckAirtightness;
    data['Plc_M_Block/ChuckAirtightness2'] = this.plcMBlockChuckAirtightness2;
    data['Plc_M_Block/ChuckOpenCloseStatus'] =
        this.plcMBlockChuckOpenCloseStatus;
    data['Plc_M_Block/ChuckOpenCloseStatus2'] =
        this.plcMBlockChuckOpenCloseStatus2;
    data['Plc_M_Block/PressureValue'] = this.plcMBlockPressureValue;
    data['Plc_M_Block/MacAutoDoorStatus'] = this.plcMBlockMacAutoDoorStatus;
    data['Plc_M_Block/MacAutoDoorStatus2'] = this.plcMBlockMacAutoDoorStatus2;
    data['Plc_M_Block/MacOriginPosCheck'] = this.plcMBlockMacOriginPosCheck;
    data['Plc_M_Block/MacOriginPosCheck2'] = this.plcMBlockMacOriginPosCheck2;
    data['Plc_M_Block/MacOnlineAsk'] = this.plcMBlockMacOnlineAsk;
    data['Plc_M_Block/MacOnlineAsk2'] = this.plcMBlockMacOnlineAsk2;
    data['Plc_M_Block/MacOfflineAsk'] = this.plcMBlockMacOfflineAsk;
    data['Plc_M_Block/MacOfflineAsk2'] = this.plcMBlockMacOfflineAsk2;
    data['Plc_M_Block/MachineError'] = this.plcMBlockMachineError;
    data['Plc_M_Block/MachineError2'] = this.plcMBlockMachineError2;
    data['Plc_M_Block/RotatShelfScanFinish'] =
        this.plcMBlockRotatShelfScanFinish;
    data['Plc_M_Block/RotatShelfScanFinish2'] =
        this.plcMBlockRotatShelfScanFinish2;
    data['Plc_M_Block/MacObstructionCheck'] = this.plcMBlockMacObstructionCheck;
    data['Plc_M_Block/MacObstructionCheck2'] =
        this.plcMBlockMacObstructionCheck2;
    data['Plc_M_Block/MacWasteMonitor'] = this.plcMBlockMacWasteMonitor;
    data['Plc_M_Block/MacWasteMonitor2'] = this.plcMBlockMacWasteMonitor2;
    data['Plc_M_Block/StorageSensorStatus'] = this.plcMBlockStorageSensorStatus;
    data['Plc_M_Block/StorageLightCtrl'] = this.plcMBlockStorageLightCtrl;
    data['Plc_M_Block/CMD_IDF_PRESSURE'] = this.plcMBlockCMDIDFPRESSURE;
    data['Plc_M_Block/CMD_IDF_CLAMP'] = this.plcMBlockCMDIDFCLAMP;
    data['Plc_M_Block/CMD_IDF_ROBOT_CONTROL_CABINET'] =
        this.plcMBlockCMDIDFROBOTCONTROLCABINET;
    data['Plc_M_Block/CMD_IDF_ROBOT_HANDY_PANEL'] =
        this.plcMBlockCMDIDFROBOTHANDYPANEL;
    data['Plc_M_Block/CMD_IDF_CHUCK_SCAN'] = this.plcMBlockCMDIDFCHUCKSCAN;
    data['Plc_M_Block/CMD_IDF_ROBOT_SAFE_POSITION'] =
        this.plcMBlockCMDIDFROBOTSAFEPOSITION;
    data['PlcDbBlock/RfidRead'] = this.plcDbBlockRfidRead;
    return data;
  }
}

// class PlcCommunicationProtocol {
//   String? cMDIDROPUTS;
//   String? cMDIDRIPUTS;
//   String? cMDIDRREGS;
//   String? cMDIDWOPUT;
//   String? cMDIDWOPUTS;
//   String? cMDIDWREGS;
//   String? robotMainPrgRun;
//   String? robotPause;
//   String? buzzer;
//   String? guideRun;
//   String? servoAlarmReset;
//   String? openDoor;
//   String? openDoor2;
//   String? machineRun;
//   String? machineRest;
//   String? mahicneNumToPlc;
//   String? storageNumToPlc;
//   String? shelfUpLineCtrl;
//   String? machineUpLineCtrl;
//   String? machineStatusLightCtrl;
//   String? rotatShelfRun;
//   String? robotTaskType;
//   String? takeStorageNum;
//   String? putStorageNum;
//   String? cmmMachineStatusByIO;
//   String? transferShelfOnLineAsk;
//   String? transferShelfOffLineAsk;
//   String? transferStorageSensorStatus;
//   String? transferShelfButtonStatus;
//   String? transferStorageRotatLocationStatus;
//   String? transferDoorStatus;
//   String? oilGrooveUpCtrl;
//   String? oilGroCtrlMacNum;
//   String? stopBlow;
//   String? connectStationOffX;
//   String? connectStationOffY;
//   String? connectStationOffZ;
//   String? macStartPumpingAdd;
//   String? macPumpingStopTime;
//   String? tranSportStorageStatus;
//   String? baseInfo;
//   String? shelfDoor;
//   String? shelfDoor2;
//   String? macFenceDoorStatus;
//   String? macFenceDoorBrakingStatus;
//   String? fencePneumaticDoorStatus;
//   String? fenceDoor;
//   String? accompanyPlat;
//   String? machineFinish;
//   String? machineFinish2;
//   String? shelfOnlineAsk;
//   String? shelfOnlineAsk2;
//   String? shelfOfflineAsk;
//   String? shelfOfflineAsk2;
//   String? shelfOpenDoorAsk;
//   String? shelfEmergencyStop;
//   String? shelfEmergencyStop2;
//   String? fenceEmergencyStop;
//   String? chuckLockUnLockStatus;
//   String? chuckAirtightness;
//   String? chuckAirtightness2;
//   String? chuckOpenCloseStatus;
//   String? chuckOpenCloseStatus2;
//   String? pressureValue;
//   String? macAutoDoorStatus;
//   String? macAutoDoorStatus2;
//   String? macOriginPosCheck;
//   String? macOriginPosCheck2;
//   String? macOnlineAsk;
//   String? macOnlineAsk2;
//   String? macOfflineAsk;
//   String? macOfflineAsk2;
//   String? machineError;
//   String? machineError2;
//   String? rotatShelfScanFinish;
//   String? rotatShelfScanFinish2;
//   String? macObstructionCheck;
//   String? macObstructionCheck2;
//   String? macWasteMonitor;
//   String? macWasteMonitor2;
//   String? storageSensorStatus;
//   String? storageLightCtrl;
//   String? cMDIDFPRESSURE;
//   String? cMDIDFCLAMP;
//   String? cMDIDFROBOTCONTROLCABINET;
//   String? cMDIDFROBOTHANDYPANEL;
//   String? cMDIDFCHUCKSCAN;
//   String? cMDIDFROBOTSAFEPOSITION;
//   String? okLight;
//   String? ngLight;
//   String? warnLight;
//   String? rfidRead;
//   String? ask;
//   String? type;
//   String? takeNum;
//   String? takeShelfNum;
//   String? takeStorageType;
//   String? putMachineNum;
//   String? putDirection;
//   String? takeMachineNum;
//   String? takeDirection;
//   String? putNum;
//   String? putShelfNum;
//   String? putStorageType;
//   String? finish;
//   String? loopFinish;
//   String? onScanChuck;
//   String? takeWight;
//   String? putWeight;
//   String? workpiecePosOffsetX;
//   String? workpiecePosOffsetY;
//   String? workpiecePosOffsetZ;
//   String? onJumpRobotTask;

//   PlcCommunicationProtocol(
//       {this.cMDIDROPUTS,
//       this.cMDIDRIPUTS,
//       this.cMDIDRREGS,
//       this.cMDIDWOPUT,
//       this.cMDIDWOPUTS,
//       this.cMDIDWREGS,
//       this.robotMainPrgRun,
//       this.robotPause,
//       this.buzzer,
//       this.guideRun,
//       this.servoAlarmReset,
//       this.openDoor,
//       this.openDoor2,
//       this.machineRun,
//       this.machineRest,
//       this.mahicneNumToPlc,
//       this.storageNumToPlc,
//       this.shelfUpLineCtrl,
//       this.machineUpLineCtrl,
//       this.machineStatusLightCtrl,
//       this.rotatShelfRun,
//       this.robotTaskType,
//       this.takeStorageNum,
//       this.putStorageNum,
//       this.cmmMachineStatusByIO,
//       this.transferShelfOnLineAsk,
//       this.transferShelfOffLineAsk,
//       this.transferStorageSensorStatus,
//       this.transferShelfButtonStatus,
//       this.transferStorageRotatLocationStatus,
//       this.transferDoorStatus,
//       this.oilGrooveUpCtrl,
//       this.oilGroCtrlMacNum,
//       this.stopBlow,
//       this.connectStationOffX,
//       this.connectStationOffY,
//       this.connectStationOffZ,
//       this.macStartPumpingAdd,
//       this.macPumpingStopTime,
//       this.tranSportStorageStatus,
//       this.baseInfo,
//       this.shelfDoor,
//       this.shelfDoor2,
//       this.macFenceDoorStatus,
//       this.macFenceDoorBrakingStatus,
//       this.fencePneumaticDoorStatus,
//       this.fenceDoor,
//       this.accompanyPlat,
//       this.machineFinish,
//       this.machineFinish2,
//       this.shelfOnlineAsk,
//       this.shelfOnlineAsk2,
//       this.shelfOfflineAsk,
//       this.shelfOfflineAsk2,
//       this.shelfOpenDoorAsk,
//       this.shelfEmergencyStop,
//       this.shelfEmergencyStop2,
//       this.fenceEmergencyStop,
//       this.chuckLockUnLockStatus,
//       this.chuckAirtightness,
//       this.chuckAirtightness2,
//       this.chuckOpenCloseStatus,
//       this.chuckOpenCloseStatus2,
//       this.pressureValue,
//       this.macAutoDoorStatus,
//       this.macAutoDoorStatus2,
//       this.macOriginPosCheck,
//       this.macOriginPosCheck2,
//       this.macOnlineAsk,
//       this.macOnlineAsk2,
//       this.macOfflineAsk,
//       this.macOfflineAsk2,
//       this.machineError,
//       this.machineError2,
//       this.rotatShelfScanFinish,
//       this.rotatShelfScanFinish2,
//       this.macObstructionCheck,
//       this.macObstructionCheck2,
//       this.macWasteMonitor,
//       this.macWasteMonitor2,
//       this.storageSensorStatus,
//       this.storageLightCtrl,
//       this.cMDIDFPRESSURE,
//       this.cMDIDFCLAMP,
//       this.cMDIDFROBOTCONTROLCABINET,
//       this.cMDIDFROBOTHANDYPANEL,
//       this.cMDIDFCHUCKSCAN,
//       this.cMDIDFROBOTSAFEPOSITION,
//       this.okLight,
//       this.ngLight,
//       this.warnLight,
//       this.rfidRead,
//       this.ask,
//       this.type,
//       this.takeNum,
//       this.takeShelfNum,
//       this.takeStorageType,
//       this.putMachineNum,
//       this.putDirection,
//       this.takeMachineNum,
//       this.takeDirection,
//       this.putNum,
//       this.putShelfNum,
//       this.putStorageType,
//       this.finish,
//       this.loopFinish,
//       this.onScanChuck,
//       this.takeWight,
//       this.putWeight,
//       this.workpiecePosOffsetX,
//       this.workpiecePosOffsetY,
//       this.workpiecePosOffsetZ,
//       this.onJumpRobotTask});

//   PlcCommunicationProtocol.fromJson(Map<String, dynamic> json) {
//     cMDIDROPUTS = json['CMD_ID_R_OPUTS'];
//     cMDIDRIPUTS = json['CMD_ID_R_IPUTS'];
//     cMDIDRREGS = json['CMD_ID_R_REGS'];
//     cMDIDWOPUT = json['CMD_ID_W_OPUT'];
//     cMDIDWOPUTS = json['CMD_ID_W_OPUTS'];
//     cMDIDWREGS = json['CMD_ID_W_REGS'];
//     robotMainPrgRun = json['RobotMainPrgRun'];
//     robotPause = json['RobotPause'];
//     buzzer = json['Buzzer'];
//     guideRun = json['GuideRun'];
//     servoAlarmReset = json['ServoAlarmReset'];
//     openDoor = json['OpenDoor'];
//     openDoor2 = json['OpenDoor2'];
//     machineRun = json['MachineRun'];
//     machineRest = json['MachineRest'];
//     mahicneNumToPlc = json['MahicneNumToPlc'];
//     storageNumToPlc = json['StorageNumToPlc'];
//     shelfUpLineCtrl = json['ShelfUpLineCtrl'];
//     machineUpLineCtrl = json['MachineUpLineCtrl'];
//     machineStatusLightCtrl = json['MachineStatusLightCtrl'];
//     rotatShelfRun = json['RotatShelfRun'];
//     robotTaskType = json['RobotTaskType'];
//     takeStorageNum = json['TakeStorageNum'];
//     putStorageNum = json['PutStorageNum'];
//     cmmMachineStatusByIO = json['CmmMachineStatusByIO'];
//     transferShelfOnLineAsk = json['TransferShelfOnLineAsk'];
//     transferShelfOffLineAsk = json['TransferShelfOffLineAsk'];
//     transferStorageSensorStatus = json['TransferStorageSensorStatus'];
//     transferShelfButtonStatus = json['TransferShelfButtonStatus'];
//     transferStorageRotatLocationStatus =
//         json['TransferStorageRotatLocationStatus'];
//     transferDoorStatus = json['TransferDoorStatus'];
//     oilGrooveUpCtrl = json['OilGrooveUpCtrl'];
//     oilGroCtrlMacNum = json['OilGroCtrlMacNum'];
//     stopBlow = json['StopBlow'];
//     connectStationOffX = json['ConnectStationOffX'];
//     connectStationOffY = json['ConnectStationOffY'];
//     connectStationOffZ = json['ConnectStationOffZ'];
//     macStartPumpingAdd = json['MacStartPumpingAdd'];
//     macPumpingStopTime = json['MacPumpingStopTime'];
//     tranSportStorageStatus = json['TranSportStorageStatus'];
//     baseInfo = json['BaseInfo'];
//     shelfDoor = json['ShelfDoor'];
//     shelfDoor2 = json['ShelfDoor2'];
//     macFenceDoorStatus = json['MacFenceDoorStatus'];
//     macFenceDoorBrakingStatus = json['MacFenceDoorBrakingStatus'];
//     fencePneumaticDoorStatus = json['FencePneumaticDoorStatus'];
//     fenceDoor = json['FenceDoor'];
//     accompanyPlat = json['AccompanyPlat'];
//     machineFinish = json['MachineFinish'];
//     machineFinish2 = json['MachineFinish2'];
//     shelfOnlineAsk = json['ShelfOnlineAsk'];
//     shelfOnlineAsk2 = json['ShelfOnlineAsk2'];
//     shelfOfflineAsk = json['ShelfOfflineAsk'];
//     shelfOfflineAsk2 = json['ShelfOfflineAsk2'];
//     shelfOpenDoorAsk = json['ShelfOpenDoorAsk'];
//     shelfEmergencyStop = json['ShelfEmergencyStop'];
//     shelfEmergencyStop2 = json['ShelfEmergencyStop2'];
//     fenceEmergencyStop = json['FenceEmergencyStop'];
//     chuckLockUnLockStatus = json['ChuckLockUnLockStatus'];
//     chuckAirtightness = json['ChuckAirtightness'];
//     chuckAirtightness2 = json['ChuckAirtightness2'];
//     chuckOpenCloseStatus = json['ChuckOpenCloseStatus'];
//     chuckOpenCloseStatus2 = json['ChuckOpenCloseStatus2'];
//     pressureValue = json['PressureValue'];
//     macAutoDoorStatus = json['MacAutoDoorStatus'];
//     macAutoDoorStatus2 = json['MacAutoDoorStatus2'];
//     macOriginPosCheck = json['MacOriginPosCheck'];
//     macOriginPosCheck2 = json['MacOriginPosCheck2'];
//     macOnlineAsk = json['MacOnlineAsk'];
//     macOnlineAsk2 = json['MacOnlineAsk2'];
//     macOfflineAsk = json['MacOfflineAsk'];
//     macOfflineAsk2 = json['MacOfflineAsk2'];
//     machineError = json['MachineError'];
//     machineError2 = json['MachineError2'];
//     rotatShelfScanFinish = json['RotatShelfScanFinish'];
//     rotatShelfScanFinish2 = json['RotatShelfScanFinish2'];
//     macObstructionCheck = json['MacObstructionCheck'];
//     macObstructionCheck2 = json['MacObstructionCheck2'];
//     macWasteMonitor = json['MacWasteMonitor'];
//     macWasteMonitor2 = json['MacWasteMonitor2'];
//     storageSensorStatus = json['StorageSensorStatus'];
//     storageLightCtrl = json['StorageLightCtrl'];
//     cMDIDFPRESSURE = json['CMD_IDF_PRESSURE'];
//     cMDIDFCLAMP = json['CMD_IDF_CLAMP'];
//     cMDIDFROBOTCONTROLCABINET = json['CMD_IDF_ROBOT_CONTROL_CABINET'];
//     cMDIDFROBOTHANDYPANEL = json['CMD_IDF_ROBOT_HANDY_PANEL'];
//     cMDIDFCHUCKSCAN = json['CMD_IDF_CHUCK_SCAN'];
//     cMDIDFROBOTSAFEPOSITION = json['CMD_IDF_ROBOT_SAFE_POSITION'];
//     okLight = json['OkLight'];
//     ngLight = json['NgLight'];
//     warnLight = json['WarnLight'];
//     rfidRead = json['RfidRead'];
//     ask = json['Ask'];
//     type = json['Type'];
//     takeNum = json['TakeNum'];
//     takeShelfNum = json['TakeShelfNum'];
//     takeStorageType = json['TakeStorageType'];
//     putMachineNum = json['PutMachineNum'];
//     putDirection = json['PutDirection'];
//     takeMachineNum = json['TakeMachineNum'];
//     takeDirection = json['TakeDirection'];
//     putNum = json['PutNum'];
//     putShelfNum = json['PutShelfNum'];
//     putStorageType = json['PutStorageType'];
//     finish = json['Finish'];
//     loopFinish = json['LoopFinish'];
//     onScanChuck = json['OnScanChuck'];
//     takeWight = json['TakeWight'];
//     putWeight = json['PutWeight'];
//     workpiecePosOffsetX = json['WorkpiecePosOffsetX'];
//     workpiecePosOffsetY = json['WorkpiecePosOffsetY'];
//     workpiecePosOffsetZ = json['WorkpiecePosOffsetZ'];
//     onJumpRobotTask = json['OnJumpRobotTask'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['CMD_ID_R_OPUTS'] = this.cMDIDROPUTS;
//     data['CMD_ID_R_IPUTS'] = this.cMDIDRIPUTS;
//     data['CMD_ID_R_REGS'] = this.cMDIDRREGS;
//     data['CMD_ID_W_OPUT'] = this.cMDIDWOPUT;
//     data['CMD_ID_W_OPUTS'] = this.cMDIDWOPUTS;
//     data['CMD_ID_W_REGS'] = this.cMDIDWREGS;
//     data['RobotMainPrgRun'] = this.robotMainPrgRun;
//     data['RobotPause'] = this.robotPause;
//     data['Buzzer'] = this.buzzer;
//     data['GuideRun'] = this.guideRun;
//     data['ServoAlarmReset'] = this.servoAlarmReset;
//     data['OpenDoor'] = this.openDoor;
//     data['OpenDoor2'] = this.openDoor2;
//     data['MachineRun'] = this.machineRun;
//     data['MachineRest'] = this.machineRest;
//     data['MahicneNumToPlc'] = this.mahicneNumToPlc;
//     data['StorageNumToPlc'] = this.storageNumToPlc;
//     data['ShelfUpLineCtrl'] = this.shelfUpLineCtrl;
//     data['MachineUpLineCtrl'] = this.machineUpLineCtrl;
//     data['MachineStatusLightCtrl'] = this.machineStatusLightCtrl;
//     data['RotatShelfRun'] = this.rotatShelfRun;
//     data['RobotTaskType'] = this.robotTaskType;
//     data['TakeStorageNum'] = this.takeStorageNum;
//     data['PutStorageNum'] = this.putStorageNum;
//     data['CmmMachineStatusByIO'] = this.cmmMachineStatusByIO;
//     data['TransferShelfOnLineAsk'] = this.transferShelfOnLineAsk;
//     data['TransferShelfOffLineAsk'] = this.transferShelfOffLineAsk;
//     data['TransferStorageSensorStatus'] = this.transferStorageSensorStatus;
//     data['TransferShelfButtonStatus'] = this.transferShelfButtonStatus;
//     data['TransferStorageRotatLocationStatus'] =
//         this.transferStorageRotatLocationStatus;
//     data['TransferDoorStatus'] = this.transferDoorStatus;
//     data['OilGrooveUpCtrl'] = this.oilGrooveUpCtrl;
//     data['OilGroCtrlMacNum'] = this.oilGroCtrlMacNum;
//     data['StopBlow'] = this.stopBlow;
//     data['ConnectStationOffX'] = this.connectStationOffX;
//     data['ConnectStationOffY'] = this.connectStationOffY;
//     data['ConnectStationOffZ'] = this.connectStationOffZ;
//     data['MacStartPumpingAdd'] = this.macStartPumpingAdd;
//     data['MacPumpingStopTime'] = this.macPumpingStopTime;
//     data['TranSportStorageStatus'] = this.tranSportStorageStatus;
//     data['BaseInfo'] = this.baseInfo;
//     data['ShelfDoor'] = this.shelfDoor;
//     data['ShelfDoor2'] = this.shelfDoor2;
//     data['MacFenceDoorStatus'] = this.macFenceDoorStatus;
//     data['MacFenceDoorBrakingStatus'] = this.macFenceDoorBrakingStatus;
//     data['FencePneumaticDoorStatus'] = this.fencePneumaticDoorStatus;
//     data['FenceDoor'] = this.fenceDoor;
//     data['AccompanyPlat'] = this.accompanyPlat;
//     data['MachineFinish'] = this.machineFinish;
//     data['MachineFinish2'] = this.machineFinish2;
//     data['ShelfOnlineAsk'] = this.shelfOnlineAsk;
//     data['ShelfOnlineAsk2'] = this.shelfOnlineAsk2;
//     data['ShelfOfflineAsk'] = this.shelfOfflineAsk;
//     data['ShelfOfflineAsk2'] = this.shelfOfflineAsk2;
//     data['ShelfOpenDoorAsk'] = this.shelfOpenDoorAsk;
//     data['ShelfEmergencyStop'] = this.shelfEmergencyStop;
//     data['ShelfEmergencyStop2'] = this.shelfEmergencyStop2;
//     data['FenceEmergencyStop'] = this.fenceEmergencyStop;
//     data['ChuckLockUnLockStatus'] = this.chuckLockUnLockStatus;
//     data['ChuckAirtightness'] = this.chuckAirtightness;
//     data['ChuckAirtightness2'] = this.chuckAirtightness2;
//     data['ChuckOpenCloseStatus'] = this.chuckOpenCloseStatus;
//     data['ChuckOpenCloseStatus2'] = this.chuckOpenCloseStatus2;
//     data['PressureValue'] = this.pressureValue;
//     data['MacAutoDoorStatus'] = this.macAutoDoorStatus;
//     data['MacAutoDoorStatus2'] = this.macAutoDoorStatus2;
//     data['MacOriginPosCheck'] = this.macOriginPosCheck;
//     data['MacOriginPosCheck2'] = this.macOriginPosCheck2;
//     data['MacOnlineAsk'] = this.macOnlineAsk;
//     data['MacOnlineAsk2'] = this.macOnlineAsk2;
//     data['MacOfflineAsk'] = this.macOfflineAsk;
//     data['MacOfflineAsk2'] = this.macOfflineAsk2;
//     data['MachineError'] = this.machineError;
//     data['MachineError2'] = this.machineError2;
//     data['RotatShelfScanFinish'] = this.rotatShelfScanFinish;
//     data['RotatShelfScanFinish2'] = this.rotatShelfScanFinish2;
//     data['MacObstructionCheck'] = this.macObstructionCheck;
//     data['MacObstructionCheck2'] = this.macObstructionCheck2;
//     data['MacWasteMonitor'] = this.macWasteMonitor;
//     data['MacWasteMonitor2'] = this.macWasteMonitor2;
//     data['StorageSensorStatus'] = this.storageSensorStatus;
//     data['StorageLightCtrl'] = this.storageLightCtrl;
//     data['CMD_IDF_PRESSURE'] = this.cMDIDFPRESSURE;
//     data['CMD_IDF_CLAMP'] = this.cMDIDFCLAMP;
//     data['CMD_IDF_ROBOT_CONTROL_CABINET'] = this.cMDIDFROBOTCONTROLCABINET;
//     data['CMD_IDF_ROBOT_HANDY_PANEL'] = this.cMDIDFROBOTHANDYPANEL;
//     data['CMD_IDF_CHUCK_SCAN'] = this.cMDIDFCHUCKSCAN;
//     data['CMD_IDF_ROBOT_SAFE_POSITION'] = this.cMDIDFROBOTSAFEPOSITION;
//     data['OkLight'] = this.okLight;
//     data['NgLight'] = this.ngLight;
//     data['WarnLight'] = this.warnLight;
//     data['RfidRead'] = this.rfidRead;
//     data['Ask'] = this.ask;
//     data['Type'] = this.type;
//     data['TakeNum'] = this.takeNum;
//     data['TakeShelfNum'] = this.takeShelfNum;
//     data['TakeStorageType'] = this.takeStorageType;
//     data['PutMachineNum'] = this.putMachineNum;
//     data['PutDirection'] = this.putDirection;
//     data['TakeMachineNum'] = this.takeMachineNum;
//     data['TakeDirection'] = this.takeDirection;
//     data['PutNum'] = this.putNum;
//     data['PutShelfNum'] = this.putShelfNum;
//     data['PutStorageType'] = this.putStorageType;
//     data['Finish'] = this.finish;
//     data['LoopFinish'] = this.loopFinish;
//     data['OnScanChuck'] = this.onScanChuck;
//     data['TakeWight'] = this.takeWight;
//     data['PutWeight'] = this.putWeight;
//     data['WorkpiecePosOffsetX'] = this.workpiecePosOffsetX;
//     data['WorkpiecePosOffsetY'] = this.workpiecePosOffsetY;
//     data['WorkpiecePosOffsetZ'] = this.workpiecePosOffsetZ;
//     data['OnJumpRobotTask'] = this.onJumpRobotTask;
//     return data;
//   }

//   operator []=(String key, dynamic value) {
//     // set the value for the given key
//   }

//   getValueByKey(String key) {
//     // get the value for the given key
//   }

//   setValueByKey(String key, dynamic value) {
//     // set the value for the given key
//   }
// }
