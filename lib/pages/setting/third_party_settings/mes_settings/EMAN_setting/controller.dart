import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/components/index.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class EmanSettingController extends GetxController {
  EmanSettingController();
  EMANSetting eMANSetting = EMANSetting();
  List<RenderField> menuList = [
    RenderFieldInfo(
        field: "MacEscapeChineName",
        section: "EManServer",
        name: "机床转义名称",
        renderType: RenderType.input),
    RenderFieldInfo(
        field: "MacMonitorId",
        section: "EManServer",
        name: "机床监控ID",
        renderType: RenderType.input),
    RenderFieldInfo(
        field: "ServerIp",
        section: "EManServer",
        name: "Eman服务IP",
        renderType: RenderType.input),
    RenderFieldInfo(
        field: "ServerPort",
        section: "EManServer",
        name: "Eman服务端口",
        renderType: RenderType.input),
    RenderFieldInfo(
        field: "EnterpriseCopid",
        section: "EManServer",
        name: "企业ID",
        renderType: RenderType.input),
    RenderFieldInfo(
        field: "WorkpieceCraft",
        section: "EManServer",
        name: "EMan与EAtm对应工艺",
        renderType: RenderType.input),
    RenderFieldInfo(
        field: "LoginUser",
        section: "EManServer",
        name: "Eman登陆用户名",
        renderType: RenderType.input),
    RenderFieldInfo(
        field: "CheckBomTotalMark",
        section: "EManServer",
        name: "检查bom总数",
        renderType: RenderType.toggleSwitch),
    RenderFieldInfo(
        field: "EmanReportMode",
        section: "EManServer",
        name: "eman报工模式",
        renderType: RenderType.select,
        options: {
          "新框架报工": "0",
          "老框架报工": "1",
          "一汽": "2",
          "标准接口": "3",
          "威戈尔": "4"
        }),
    RenderFieldInfo(
        field: "EmanReportType",
        section: "EManServer",
        name: "零件工艺配置",
        renderType: RenderType.input),
    RenderFieldInfo(
        field: "EmanProjectName",
        section: "EManServer",
        name: "eman对应的工厂名",
        renderType: RenderType.input),
    RenderFieldInfo(
        field: "ResourceGroupName",
        section: "EManServer",
        name: "资源组名称",
        renderType: RenderType.input),
    RenderFieldInfo(
        field: "AgvStart",
        section: "EManServer",
        name: "agv是否开启",
        renderType: RenderType.radio,
        options: {"开启": "1", "不开启": "0"}),
    RenderFieldInfo(
      field: "ConnectingNumUp",
      section: "EManServer",
      name: "接驳站的编号上",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: "ConnectingNumDown",
      section: "EManServer",
      name: "接驳站的编号下",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: "UseEmancraftRoute",
      section: "EManServer",
      name: "是否启用eman工艺路线",
      renderType: RenderType.toggleSwitch,
    ),
    RenderFieldInfo(
      field: "SchedulingQueryDays",
      section: "EManServer",
      name: "排产计划查询时长(天)，默认15天",
      renderType: RenderType.numberInput,
    ),
    RenderFieldInfo(
        field: "AppointMachine",
        section: "EManServer",
        name: "指定机床",
        renderType: RenderType.select,
        options: {"默认": "0", "走Eman指定路线": "1"}),
    RenderFieldInfo(
        field: "PrgDownSource",
        section: "EManServer",
        name: "prg下载源",
        renderType: RenderType.select,
        options: {"默认从eman下载": "0", "从别的途径": "1"}),
    RenderFieldInfo(
      field: "ProduceReGroupName",
      section: "EManServer",
      name: "生产资源组名称",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: "Dimensionalwork",
      section: "EManServer",
      name: "获取立体工电极标识 从eman获取电极的尺寸",
      renderType: RenderType.numberInput,
    ),
  ];

  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = eMANSetting.toJson();
    temp[field] = val;
    eMANSetting = EMANSetting.fromJson(temp);
  }

  String? getFieldValue(String field) {
    return eMANSetting.toJson()[field];
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
      "params": eMANSetting.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      eMANSetting = EMANSetting.fromJson(res.data);
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
    update(["eman_setting"]);
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

class EMANSetting {
  String? eManServerMacEscapeChineName;
  String? eManServerMacMonitorId;
  String? eManServerServerIp;
  String? eManServerServerPort;
  String? eManServerEnterpriseCopid;
  String? eManServerWorkpieceCraft;
  String? eManServerLoginUser;
  String? eManServerCheckBomTotalMark;
  String? eManServerEmanReportMode;
  String? eManServerEmanReportType;
  String? eManServerEmanProjectName;
  String? eManServerResourceGroupName;
  String? eManServerAgvStart;
  String? eManServerConnectingNumUp;
  String? eManServerConnectingNumDown;
  String? eManServerUseEmancraftRoute;
  String? eManServerSchedulingQueryDays;
  String? eManServerAppointMachine;
  String? eManServerPrgDownSource;
  String? eManServerProduceReGroupName;
  String? eManServerDimensionalwork;

  EMANSetting(
      {this.eManServerMacEscapeChineName,
      this.eManServerMacMonitorId,
      this.eManServerServerIp,
      this.eManServerServerPort,
      this.eManServerEnterpriseCopid,
      this.eManServerWorkpieceCraft,
      this.eManServerLoginUser,
      this.eManServerCheckBomTotalMark,
      this.eManServerEmanReportMode,
      this.eManServerEmanReportType,
      this.eManServerEmanProjectName,
      this.eManServerResourceGroupName,
      this.eManServerAgvStart,
      this.eManServerConnectingNumUp,
      this.eManServerConnectingNumDown,
      this.eManServerUseEmancraftRoute,
      this.eManServerSchedulingQueryDays,
      this.eManServerAppointMachine,
      this.eManServerPrgDownSource,
      this.eManServerProduceReGroupName,
      this.eManServerDimensionalwork});

  EMANSetting.fromJson(Map<String, dynamic> json) {
    eManServerMacEscapeChineName = json['EManServer/MacEscapeChineName'];
    eManServerMacMonitorId = json['EManServer/MacMonitorId'];
    eManServerServerIp = json['EManServer/ServerIp'];
    eManServerServerPort = json['EManServer/ServerPort'];
    eManServerEnterpriseCopid = json['EManServer/EnterpriseCopid'];
    eManServerWorkpieceCraft = json['EManServer/WorkpieceCraft'];
    eManServerLoginUser = json['EManServer/LoginUser'];
    eManServerCheckBomTotalMark = json['EManServer/CheckBomTotalMark'];
    eManServerEmanReportMode = json['EManServer/EmanReportMode'];
    eManServerEmanReportType = json['EManServer/EmanReportType'];
    eManServerEmanProjectName = json['EManServer/EmanProjectName'];
    eManServerResourceGroupName = json['EManServer/ResourceGroupName'];
    eManServerAgvStart = json['EManServer/AgvStart'];
    eManServerConnectingNumUp = json['EManServer/ConnectingNumUp'];
    eManServerConnectingNumDown = json['EManServer/ConnectingNumDown'];
    eManServerUseEmancraftRoute = json['EManServer/UseEmancraftRoute'];
    eManServerSchedulingQueryDays = json['EManServer/SchedulingQueryDays'];
    eManServerAppointMachine = json['EManServer/AppointMachine'];
    eManServerPrgDownSource = json['EManServer/PrgDownSource'];
    eManServerProduceReGroupName = json['EManServer/ProduceReGroupName'];
    eManServerDimensionalwork = json['EManServer/Dimensionalwork'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EManServer/MacEscapeChineName'] = this.eManServerMacEscapeChineName;
    data['EManServer/MacMonitorId'] = this.eManServerMacMonitorId;
    data['EManServer/ServerIp'] = this.eManServerServerIp;
    data['EManServer/ServerPort'] = this.eManServerServerPort;
    data['EManServer/EnterpriseCopid'] = this.eManServerEnterpriseCopid;
    data['EManServer/WorkpieceCraft'] = this.eManServerWorkpieceCraft;
    data['EManServer/LoginUser'] = this.eManServerLoginUser;
    data['EManServer/CheckBomTotalMark'] = this.eManServerCheckBomTotalMark;
    data['EManServer/EmanReportMode'] = this.eManServerEmanReportMode;
    data['EManServer/EmanReportType'] = this.eManServerEmanReportType;
    data['EManServer/EmanProjectName'] = this.eManServerEmanProjectName;
    data['EManServer/ResourceGroupName'] = this.eManServerResourceGroupName;
    data['EManServer/AgvStart'] = this.eManServerAgvStart;
    data['EManServer/ConnectingNumUp'] = this.eManServerConnectingNumUp;
    data['EManServer/ConnectingNumDown'] = this.eManServerConnectingNumDown;
    data['EManServer/UseEmancraftRoute'] = this.eManServerUseEmancraftRoute;
    data['EManServer/SchedulingQueryDays'] = this.eManServerSchedulingQueryDays;
    data['EManServer/AppointMachine'] = this.eManServerAppointMachine;
    data['EManServer/PrgDownSource'] = this.eManServerPrgDownSource;
    data['EManServer/ProduceReGroupName'] = this.eManServerProduceReGroupName;
    data['EManServer/Dimensionalwork'] = this.eManServerDimensionalwork;
    return data;
  }
}
