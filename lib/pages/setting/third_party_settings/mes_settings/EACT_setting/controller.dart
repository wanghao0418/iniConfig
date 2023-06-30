import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/components/index.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class EactSettingController extends GetxController {
  EactSettingController();
  EACTSetting eactSetting = EACTSetting();
  List<RenderField> menuList = [
    RenderFieldGroup(groupName: "公共设置", children: [
      RenderFieldInfo(
          field: "ServerIp",
          section: "EActServer",
          name: "EACT服务器IP（与EACT客户端通讯）",
          renderType: RenderType.input),
      RenderFieldInfo(
          field: "ServerPort",
          section: "EActServer",
          name: "EACT服务器端口",
          renderType: RenderType.input)
    ]),
    RenderFieldGroup(groupName: "加工相关", children: [
      RenderFieldInfo(
          field: "FancMode",
          section: "EActServer",
          name: "FAUC模式",
          renderType: RenderType.radio,
          options: {"合并NC加工程式": "1"}),
      RenderFieldInfo(
          field: "EactUnitePrg",
          section: "EActServer",
          name: "程式是否由Eact合并",
          renderType: RenderType.radio,
          options: {"不合并": "0", "Eact合并": "1"}),
      RenderFieldInfo(
        field: "MachineMarkCode",
        section: "EActServer",
        name: "机床标识码，供半自动化合并程式使用机床标识码，对应eact 的CMMBarCode或者 CNCBarCode",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldGroup(groupName: "检测相关", children: [
      RenderFieldInfo(
        field: "CmmSPsync",
        section: "EActServer",
        name: "是否开放SP， 同步检测结果",
        renderType: RenderType.toggleSwitch,
      ),
      RenderFieldInfo(
          field: "WorkReport",
          section: "EActServer",
          name: "给ECT报工",
          renderType: RenderType.select,
          options: {"不需要": "0", "放电报工": "1", "加工检测报工": "2"}),
      RenderFieldInfo(
          field: "EDMReportHandleMark",
          section: "EActServer",
          name: "WorkReport 为2时，放电是否手动报工",
          renderType: RenderType.radio,
          options: {"自动模式": "0", "手动模式": "1"}),
    ])
  ];

  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = eactSetting.toJson();
    temp[field] = val;
    eactSetting = EACTSetting.fromJson(temp);
  }

  String? getFieldValue(String field) {
    return eactSetting.toJson()[field];
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
      "params": eactSetting.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      eactSetting = EACTSetting.fromJson(res.data);
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
    update(["eact_setting"]);
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

class EACTSetting {
  String? eActServerServerIp;
  String? eActServerServerPort;
  String? eActServerFancMode;
  String? eActServerEactUnitePrg;
  String? eActServerMachineMarkCode;
  String? eActServerCmmSPsync;
  String? eActServerWorkReport;
  String? eActServerEDMReportHandleMark;

  EACTSetting(
      {this.eActServerServerIp,
      this.eActServerServerPort,
      this.eActServerFancMode,
      this.eActServerEactUnitePrg,
      this.eActServerMachineMarkCode,
      this.eActServerCmmSPsync,
      this.eActServerWorkReport,
      this.eActServerEDMReportHandleMark});

  EACTSetting.fromJson(Map<String, dynamic> json) {
    eActServerServerIp = json['EActServer/ServerIp'];
    eActServerServerPort = json['EActServer/ServerPort'];
    eActServerFancMode = json['EActServer/FancMode'];
    eActServerEactUnitePrg = json['EActServer/EactUnitePrg'];
    eActServerMachineMarkCode = json['EActServer/MachineMarkCode'];
    eActServerCmmSPsync = json['EActServer/CmmSPsync'];
    eActServerWorkReport = json['EActServer/WorkReport'];
    eActServerEDMReportHandleMark = json['EActServer/EDMReportHandleMark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EActServer/ServerIp'] = this.eActServerServerIp;
    data['EActServer/ServerPort'] = this.eActServerServerPort;
    data['EActServer/FancMode'] = this.eActServerFancMode;
    data['EActServer/EactUnitePrg'] = this.eActServerEactUnitePrg;
    data['EActServer/MachineMarkCode'] = this.eActServerMachineMarkCode;
    data['EActServer/CmmSPsync'] = this.eActServerCmmSPsync;
    data['EActServer/WorkReport'] = this.eActServerWorkReport;
    data['EActServer/EDMReportHandleMark'] = this.eActServerEDMReportHandleMark;
    return data;
  }
}
