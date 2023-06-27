/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-26 17:52:43
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-26 19:16:27
 * @FilePath: /eatm_ini_config/lib/pages/setting/system_settings/behavior_setting/behavior_setting/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/components/index.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class BehaviorSettingController extends GetxController {
  BehaviorSettingController();
  BehaviorSetting behaviorSetting = BehaviorSetting();
  List<RenderField> menuList = [
    RenderFieldGroup(groupName: "机床卡盘扫描模式", children: [
      RenderFieldInfo(
          field: "ScanType",
          section: "MachineScanTask",
          name: "扫描类型",
          renderType: RenderType.select,
          options: {"默认扫描方式，只要不下线，就只扫描一次": "0", "只要初始上料 就扫描": "1", "不扫描": "2"}),
      RenderFieldInfo(
          field: "ScanClean",
          section: "MachineScanTask",
          name: "扫描清洗模式",
          renderType: RenderType.select,
          options: {"默认扫描方式，只要不下线，就只扫描一次": "0", "只要初始上料 就扫描": "1", "不扫描": "2"}),
    ]),
    RenderFieldGroup(groupName: "全局设置", children: [
      RenderFieldInfo(
        field: "SysName",
        section: "SysInfo",
        name: "界面上显示的软件名称",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: "SysWareHouseName",
        section: "SysInfo",
        name: "仓库名称#仓库号",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: "ReallyProjectName",
        section: "SysInfo",
        name: "项目名称",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: "logPrintTimes",
        section: "SysInfo",
        name: "部分日志的打印时间默认30天",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: "CollectCycleTime",
        section: "SysInfo",
        name: "采集线程时间单位：毫秒（1000毫秒为1秒）",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
          field: "WorkpieceHeightSrc",
          section: "SysInfo",
          name: "标记工件测高来源",
          renderType: RenderType.radio,
          options: {"数据库测高值": "0", "电极夹具高度+数据库电极尺寸高度": "1"}),
      RenderFieldInfo(
        field: "ElecFixtureHeight",
        section: "SysInfo",
        name: "电极的夹具高度",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
          field: "RunMode",
          section: "SysInfo",
          name: "系统运行模式",
          renderType: RenderType.radio,
          options: {"项目运行模式": "0", "模拟运行模式(连接虚拟设备)": "1"}),
      RenderFieldInfo(
          field: "CycleRun",
          section: "SysInfo",
          name: "是否循环运行",
          renderType: RenderType.radio,
          options: {"不循环": "0", "循环运行(不记录数据-展会模式)": "1", "循环运行(记录数据)": "2"}),
      RenderFieldInfo(
          field: "PrgDownMode",
          section: "SysInfo",
          name: "程式下载类型",
          renderType: RenderType.radio,
          options: {"自动": "0", "手选": "1"}),
      RenderFieldInfo(
        field: "MachineOnlineSync",
        section: "SysInfo",
        name: "机床关联设置",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: "CheckElecCncToolMark",
          section: "SysInfo",
          name: "检查电极加工刀具标志",
          renderType: RenderType.radio,
          options: {"不检查": "0", "检查": "1"}),
      RenderFieldInfo(
          field: "EdmMoreSteelTask",
          section: "SysInfo",
          name: "手动上钢件是否是多钢件连续放电",
          renderType: RenderType.radio,
          options: {"单钢件放完下线": "0", "多钢件连续放电": "1"}),
      RenderFieldInfo(
          field: "DealPlanProduceMark",
          section: "SysInfo",
          name: "处理排产计划标志",
          renderType: RenderType.radio,
          options: {"不处理": "0", "处理排产": "1"}),
      RenderFieldInfo(
        field: "ReWorkSelectPrgMark",
        section: "SysInfo",
        name: "标记工艺返工是否 选程序,工艺",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: "ShelfIsOffLine",
          section: "SysInfo",
          name: "单个货架完成是否需要下线",
          renderType: RenderType.radio,
          options: {"下线": "0", "不下线": "1"}),
      RenderFieldInfo(
          field: "ShelfOfflineMode",
          section: "SysInfo",
          name: "当前机器人操作货架下线模式",
          renderType: RenderType.radio,
          options: {"下线所有货架": "0", "只下线当前货架": "1"}),
      RenderFieldInfo(
          field: "CheckProcessStepSwitch",
          section: "SysInfo",
          name: "工艺区分工步开关",
          renderType: RenderType.radio,
          options: {"不分工步": "0", "分工步": "1"}),
      RenderFieldInfo(
          field: "IsProcessQuadrantAngle",
          section: "SysInfo",
          name: "是否需要调用修改象限角的exe",
          renderType: RenderType.radio,
          options: {"不调用": "0", "调用": "1"}),
      RenderFieldInfo(
          field: "RobotCarryWorkpieceTaskType",
          section: "SysInfo",
          name: "机器人把工件从装载站/接驳站搬运到货架的方式",
          renderType: RenderType.radio,
          options: {
            "默认普通的任务8": "0",
            "任务9，搬运任务自带扫描芯片属性": "1",
            "8+1(搬运任务+扫描任务)": "3"
          }),
    ]),
    RenderFieldGroup(groupName: "导入外部表设置", children: [
      RenderFieldInfo(
          field: "nType",
          section: "SysInfo",
          name: "导入外部表类型",
          renderType: RenderType.radio,
          options: {"表数据直接在EATM表中": "1", "表数据来源于外部视图或者其他表结构": "2"}),
      RenderFieldInfo(
          field: "ImportTable",
          section: "SysInfo",
          name: "导入外部表",
          renderType: RenderType.radio,
          options: {
            "工艺表-车床表": "2",
            "工艺表-加工(CNC)表": "3",
            "工艺表-检测表": "4",
            "工艺表-放电表": "5"
          }),
    ]),
    RenderFieldGroup(groupName: "外界设置", children: [
      RenderFieldInfo(
        field: "TOTAL_FENCE_COUNT",
        section: "SysInfo",
        name: "围栏门个数",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: "TOTAL_MacFenceDoor_COUNT",
        section: "SysInfo",
        name: "机床围栏门个数",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: "TOTAL_ACCOMPANY_STORAGE",
        section: "SysInfo",
        name: "随形台",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldGroup(groupName: "加工工艺", children: [
      RenderFieldInfo(
          field: "GetServerPrgWorkOrderMark",
          section: "SysInfo",
          name: "获取服务器获上程序工单信息",
          renderType: RenderType.radio,
          options: {"不去查找": "0", "ftp": "1", "共享": "2"}),
      RenderFieldInfo(
        field: "WorkOrderProgramName",
        section: "SysInfo",
        name: "工作单程序名称",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: "WorkOrderToolNumName",
        section: "SysInfo",
        name: "工作单刀号",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: "WorkOrderTimeName",
        section: "SysInfo",
        name: "工作单时间",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: "workOrderElecPath",
        section: "SysInfo",
        name: "工作单路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: "WorkOrderHeaderName",
        section: "SysInfo",
        name: "工作单头部名称",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: "WorkOrderFirstPageName",
        section: "SysInfo",
        name: "工作单首页名称",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: "WorkExcelFileName",
        section: "SysInfo",
        name: "工作表文件名称",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: "SteelCCNCFinishUpClean",
        section: "SysInfo",
        name: "区分钢件粗加工完时否需要上清洗机",
        renderType: RenderType.radio,
        options: {"上": "0", "不上": "1"},
      ),
    ]),
    RenderFieldGroup(groupName: "检测工艺", children: [
      RenderFieldInfo(
        field: "CmmTimeoutRework",
        section: "SysInfo",
        name: "自动返工检测时长(小时)",
        renderType: RenderType.numberInput,
      ),
    ]),
    RenderFieldGroup(groupName: "放电工艺", children: [
      RenderFieldInfo(
        field: "EdmDatumheight",
        section: "SysInfo",
        name: "基准求高度",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: "EdmDatumRadius",
        section: "SysInfo",
        name: "基准求半径",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: "positionerBall",
        section: "SysInfo",
        name: "记录分中球的位置和芯片Id;例如货位号#条码#机床名",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldGroup(groupName: "第三方全局配置", children: [
      RenderFieldInfo(
        field: "HeadHightMark",
        section: "ThirdGloelConfig",
        name: "从半自动获取电极的头部高度标识",
        renderType: RenderType.toggleSwitch,
      ),
      RenderFieldInfo(
        field: "ReportSwitch",
        section: "ThirdGloelConfig",
        name: "报工",
        renderType: RenderType.radio,
        options: {"不报工": "0", "eman": "1", "eact": "2"},
      ),
      RenderFieldInfo(
        field: "CheckScheduleTimeMark",
        section: "ThirdGloelConfig",
        name: "查询数据库排程时间标志（目前只有武汉工程需要用到）",
        renderType: RenderType.toggleSwitch,
      ),
    ]),
    RenderFieldGroup(groupName: "本地服务", children: [
      RenderFieldInfo(
        field: "StartServerMark",
        section: "LocalServerConfig",
        name: "开启服务标识，大于0，开启服务端，IP为软件所在电脑IP",
        renderType: RenderType.select,
        options: {"不启用": "0", "武汉工程": "1", "精英放电": "2", "一汽线体": "3"},
      ),
      RenderFieldInfo(
        field: "ServerPort",
        section: "LocalServerConfig",
        name: "AGV和半自动一键上传启动",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldGroup(groupName: "新界面配置", children: [
      RenderFieldInfo(
        field: "UseLocalPort",
        section: "LocalServerConfig",
        name: "端口",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: "UserNewUiMark",
        section: "LocalServerConfig",
        name: "使用标志",
        renderType: RenderType.toggleSwitch,
      ),
    ])
  ];

  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = behaviorSetting.toJson();
    temp[field] = val;
    behaviorSetting = BehaviorSetting.fromJson(temp);
  }

  String? getFieldValue(String field) {
    return behaviorSetting.toJson()[field];
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

  query() async {
    ResponseApiBody res = await CommonApi.fieldQuery({
      "params": behaviorSetting.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      behaviorSetting = BehaviorSetting.fromJson(res.data);
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
    update(["behavior_setting"]);
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

class BehaviorSetting {
  String? machineScanTaskScanType;
  String? machineScanTaskScanClean;
  String? sysInfoSysName;
  String? sysInfoSysWareHouseName;
  String? sysInfoReallyProjectName;
  String? sysInfoLogPrintTimes;
  String? sysInfoCollectCycleTime;
  String? sysInfoWorkpieceHeightSrc;
  String? sysInfoElecFixtureHeight;
  String? sysInfoRunMode;
  String? sysInfoCycleRun;
  String? sysInfoPrgDownMode;
  String? sysInfoMachineOnlineSync;
  String? sysInfoCheckElecCncToolMark;
  String? sysInfoEdmMoreSteelTask;
  String? sysInfoDealPlanProduceMark;
  String? sysInfoReWorkSelectPrgMark;
  String? sysInfoShelfIsOffLine;
  String? sysInfoShelfOfflineMode;
  String? sysInfoCheckProcessStepSwitch;
  String? sysInfoIsProcessQuadrantAngle;
  String? sysInfoRobotCarryWorkpieceTaskType;
  String? sysInfoNType;
  String? sysInfoImportTable;
  String? sysInfoTOTALFENCECOUNT;
  String? sysInfoTOTALMacFenceDoorCOUNT;
  String? sysInfoTOTALACCOMPANYSTORAGE;
  String? sysInfoGetServerPrgWorkOrderMark;
  String? sysInfoWorkOrderProgramName;
  String? sysInfoWorkOrderToolNumName;
  String? sysInfoWorkOrderTimeName;
  String? sysInfoWorkOrderElecPath;
  String? sysInfoWorkOrderHeaderName;
  String? sysInfoWorkOrderFirstPageName;
  String? sysInfoWorkExcelFileName;
  String? sysInfoSteelCCNCFinishUpClean;
  String? sysInfoCmmTimeoutRework;
  String? sysInfoEdmDatumheight;
  String? sysInfoEdmDatumRadius;
  String? sysInfoPositionerBall;
  String? thirdGloelConfigHeadHightMark;
  String? thirdGloelConfigReportSwitch;
  String? thirdGloelConfigCheckScheduleTimeMark;
  String? localServerConfigStartServerMark;
  String? localServerConfigServerPort;
  String? localServerConfigUseLocalPort;
  String? localServerConfigUserNewUiMark;

  BehaviorSetting(
      {this.machineScanTaskScanType,
      this.machineScanTaskScanClean,
      this.sysInfoSysName,
      this.sysInfoSysWareHouseName,
      this.sysInfoReallyProjectName,
      this.sysInfoLogPrintTimes,
      this.sysInfoCollectCycleTime,
      this.sysInfoWorkpieceHeightSrc,
      this.sysInfoElecFixtureHeight,
      this.sysInfoRunMode,
      this.sysInfoCycleRun,
      this.sysInfoPrgDownMode,
      this.sysInfoMachineOnlineSync,
      this.sysInfoCheckElecCncToolMark,
      this.sysInfoEdmMoreSteelTask,
      this.sysInfoDealPlanProduceMark,
      this.sysInfoReWorkSelectPrgMark,
      this.sysInfoShelfIsOffLine,
      this.sysInfoShelfOfflineMode,
      this.sysInfoCheckProcessStepSwitch,
      this.sysInfoIsProcessQuadrantAngle,
      this.sysInfoRobotCarryWorkpieceTaskType,
      this.sysInfoNType,
      this.sysInfoImportTable,
      this.sysInfoTOTALFENCECOUNT,
      this.sysInfoTOTALMacFenceDoorCOUNT,
      this.sysInfoTOTALACCOMPANYSTORAGE,
      this.sysInfoGetServerPrgWorkOrderMark,
      this.sysInfoWorkOrderProgramName,
      this.sysInfoWorkOrderToolNumName,
      this.sysInfoWorkOrderTimeName,
      this.sysInfoWorkOrderElecPath,
      this.sysInfoWorkOrderHeaderName,
      this.sysInfoWorkOrderFirstPageName,
      this.sysInfoWorkExcelFileName,
      this.sysInfoSteelCCNCFinishUpClean,
      this.sysInfoCmmTimeoutRework,
      this.sysInfoEdmDatumheight,
      this.sysInfoEdmDatumRadius,
      this.sysInfoPositionerBall,
      this.thirdGloelConfigHeadHightMark,
      this.thirdGloelConfigReportSwitch,
      this.thirdGloelConfigCheckScheduleTimeMark,
      this.localServerConfigStartServerMark,
      this.localServerConfigServerPort,
      this.localServerConfigUseLocalPort,
      this.localServerConfigUserNewUiMark});

  BehaviorSetting.fromJson(Map<String, dynamic> json) {
    machineScanTaskScanType = json['MachineScanTask/ScanType'];
    machineScanTaskScanClean = json['MachineScanTask/ScanClean'];
    sysInfoSysName = json['SysInfo/SysName'];
    sysInfoSysWareHouseName = json['SysInfo/SysWareHouseName'];
    sysInfoReallyProjectName = json['SysInfo/ReallyProjectName'];
    sysInfoLogPrintTimes = json['SysInfo/logPrintTimes'];
    sysInfoCollectCycleTime = json['SysInfo/CollectCycleTime'];
    sysInfoWorkpieceHeightSrc = json['SysInfo/WorkpieceHeightSrc'];
    sysInfoElecFixtureHeight = json['SysInfo/ElecFixtureHeight'];
    sysInfoRunMode = json['SysInfo/RunMode'];
    sysInfoCycleRun = json['SysInfo/CycleRun'];
    sysInfoPrgDownMode = json['SysInfo/PrgDownMode'];
    sysInfoMachineOnlineSync = json['SysInfo/MachineOnlineSync'];
    sysInfoCheckElecCncToolMark = json['SysInfo/CheckElecCncToolMark'];
    sysInfoEdmMoreSteelTask = json['SysInfo/EdmMoreSteelTask'];
    sysInfoDealPlanProduceMark = json['SysInfo/DealPlanProduceMark'];
    sysInfoReWorkSelectPrgMark = json['SysInfo/ReWorkSelectPrgMark'];
    sysInfoShelfIsOffLine = json['SysInfo/ShelfIsOffLine'];
    sysInfoShelfOfflineMode = json['SysInfo/ShelfOfflineMode'];
    sysInfoCheckProcessStepSwitch = json['SysInfo/CheckProcessStepSwitch'];
    sysInfoIsProcessQuadrantAngle = json['SysInfo/IsProcessQuadrantAngle'];
    sysInfoRobotCarryWorkpieceTaskType =
        json['SysInfo/RobotCarryWorkpieceTaskType'];
    sysInfoNType = json['SysInfo/nType'];
    sysInfoImportTable = json['SysInfo/ImportTable'];
    sysInfoTOTALFENCECOUNT = json['SysInfo/TOTAL_FENCE_COUNT'];
    sysInfoTOTALMacFenceDoorCOUNT = json['SysInfo/TOTAL_MacFenceDoor_COUNT'];
    sysInfoTOTALACCOMPANYSTORAGE = json['SysInfo/TOTAL_ACCOMPANY_STORAGE'];
    sysInfoGetServerPrgWorkOrderMark =
        json['SysInfo/GetServerPrgWorkOrderMark'];
    sysInfoWorkOrderProgramName = json['SysInfo/WorkOrderProgramName'];
    sysInfoWorkOrderToolNumName = json['SysInfo/WorkOrderToolNumName'];
    sysInfoWorkOrderTimeName = json['SysInfo/WorkOrderTimeName'];
    sysInfoWorkOrderElecPath = json['SysInfo/workOrderElecPath'];
    sysInfoWorkOrderHeaderName = json['SysInfo/WorkOrderHeaderName'];
    sysInfoWorkOrderFirstPageName = json['SysInfo/WorkOrderFirstPageName'];
    sysInfoWorkExcelFileName = json['SysInfo/WorkExcelFileName'];
    sysInfoSteelCCNCFinishUpClean = json['SysInfo/SteelCCNCFinishUpClean'];
    sysInfoCmmTimeoutRework = json['SysInfo/CmmTimeoutRework'];
    sysInfoEdmDatumheight = json['SysInfo/EdmDatumheight'];
    sysInfoEdmDatumRadius = json['SysInfo/EdmDatumRadius'];
    sysInfoPositionerBall = json['SysInfo/positionerBall'];
    thirdGloelConfigHeadHightMark = json['ThirdGloelConfig/HeadHightMark'];
    thirdGloelConfigReportSwitch = json['ThirdGloelConfig/ReportSwitch'];
    thirdGloelConfigCheckScheduleTimeMark =
        json['ThirdGloelConfig/CheckScheduleTimeMark'];
    localServerConfigStartServerMark =
        json['LocalServerConfig/StartServerMark'];
    localServerConfigServerPort = json['LocalServerConfig/ServerPort'];
    localServerConfigUseLocalPort = json['LocalServerConfig/UseLocalPort'];
    localServerConfigUserNewUiMark = json['LocalServerConfig/UserNewUiMark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MachineScanTask/ScanType'] = this.machineScanTaskScanType;
    data['MachineScanTask/ScanClean'] = this.machineScanTaskScanClean;
    data['SysInfo/SysName'] = this.sysInfoSysName;
    data['SysInfo/SysWareHouseName'] = this.sysInfoSysWareHouseName;
    data['SysInfo/ReallyProjectName'] = this.sysInfoReallyProjectName;
    data['SysInfo/logPrintTimes'] = this.sysInfoLogPrintTimes;
    data['SysInfo/CollectCycleTime'] = this.sysInfoCollectCycleTime;
    data['SysInfo/WorkpieceHeightSrc'] = this.sysInfoWorkpieceHeightSrc;
    data['SysInfo/ElecFixtureHeight'] = this.sysInfoElecFixtureHeight;
    data['SysInfo/RunMode'] = this.sysInfoRunMode;
    data['SysInfo/CycleRun'] = this.sysInfoCycleRun;
    data['SysInfo/PrgDownMode'] = this.sysInfoPrgDownMode;
    data['SysInfo/MachineOnlineSync'] = this.sysInfoMachineOnlineSync;
    data['SysInfo/CheckElecCncToolMark'] = this.sysInfoCheckElecCncToolMark;
    data['SysInfo/EdmMoreSteelTask'] = this.sysInfoEdmMoreSteelTask;
    data['SysInfo/DealPlanProduceMark'] = this.sysInfoDealPlanProduceMark;
    data['SysInfo/ReWorkSelectPrgMark'] = this.sysInfoReWorkSelectPrgMark;
    data['SysInfo/ShelfIsOffLine'] = this.sysInfoShelfIsOffLine;
    data['SysInfo/ShelfOfflineMode'] = this.sysInfoShelfOfflineMode;
    data['SysInfo/CheckProcessStepSwitch'] = this.sysInfoCheckProcessStepSwitch;
    data['SysInfo/IsProcessQuadrantAngle'] = this.sysInfoIsProcessQuadrantAngle;
    data['SysInfo/RobotCarryWorkpieceTaskType'] =
        this.sysInfoRobotCarryWorkpieceTaskType;
    data['SysInfo/nType'] = this.sysInfoNType;
    data['SysInfo/ImportTable'] = this.sysInfoImportTable;
    data['SysInfo/TOTAL_FENCE_COUNT'] = this.sysInfoTOTALFENCECOUNT;
    data['SysInfo/TOTAL_MacFenceDoor_COUNT'] =
        this.sysInfoTOTALMacFenceDoorCOUNT;
    data['SysInfo/TOTAL_ACCOMPANY_STORAGE'] = this.sysInfoTOTALACCOMPANYSTORAGE;
    data['SysInfo/GetServerPrgWorkOrderMark'] =
        this.sysInfoGetServerPrgWorkOrderMark;
    data['SysInfo/WorkOrderProgramName'] = this.sysInfoWorkOrderProgramName;
    data['SysInfo/WorkOrderToolNumName'] = this.sysInfoWorkOrderToolNumName;
    data['SysInfo/WorkOrderTimeName'] = this.sysInfoWorkOrderTimeName;
    data['SysInfo/workOrderElecPath'] = this.sysInfoWorkOrderElecPath;
    data['SysInfo/WorkOrderHeaderName'] = this.sysInfoWorkOrderHeaderName;
    data['SysInfo/WorkOrderFirstPageName'] = this.sysInfoWorkOrderFirstPageName;
    data['SysInfo/WorkExcelFileName'] = this.sysInfoWorkExcelFileName;
    data['SysInfo/SteelCCNCFinishUpClean'] = this.sysInfoSteelCCNCFinishUpClean;
    data['SysInfo/CmmTimeoutRework'] = this.sysInfoCmmTimeoutRework;
    data['SysInfo/EdmDatumheight'] = this.sysInfoEdmDatumheight;
    data['SysInfo/EdmDatumRadius'] = this.sysInfoEdmDatumRadius;
    data['SysInfo/positionerBall'] = this.sysInfoPositionerBall;
    data['ThirdGloelConfig/HeadHightMark'] = this.thirdGloelConfigHeadHightMark;
    data['ThirdGloelConfig/ReportSwitch'] = this.thirdGloelConfigReportSwitch;
    data['ThirdGloelConfig/CheckScheduleTimeMark'] =
        this.thirdGloelConfigCheckScheduleTimeMark;
    data['LocalServerConfig/StartServerMark'] =
        this.localServerConfigStartServerMark;
    data['LocalServerConfig/ServerPort'] = this.localServerConfigServerPort;
    data['LocalServerConfig/UseLocalPort'] = this.localServerConfigUseLocalPort;
    data['LocalServerConfig/UserNewUiMark'] =
        this.localServerConfigUserNewUiMark;
    return data;
  }
}
