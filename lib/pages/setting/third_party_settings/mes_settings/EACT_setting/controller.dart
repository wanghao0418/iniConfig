import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

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
      // RenderFieldInfo(
      //   field: "MachineMarkCode",
      //   section: "EActServer",
      //   name: "机床标识码，供半自动化合并程式使用机床标识码，对应eact 的CMMBarCode或者 CNCBarCode",
      //   renderType: RenderType.input,
      // ),
    ]),
    RenderCustomByTag(tag: "table"),
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
  late final PlutoGridStateManager stateManager;
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
      getSectionList();
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

  get currentMachineMarkCode =>
      getFieldValue('EActServer/MachineMarkCode') ?? '';
  // get currentMacMonitorId => getFieldValue('EManServer/MacMonitorId') ?? '';

  List<MacCorrespond> macCorrespondList = [];

  final List<PlutoRow> rows = [];

  // 获取线内机床列表
  void getSectionList() async {
    ResponseApiBody res = await CommonApi.getSectionList({
      "params": [
        {
          "list_node": "MachineInfo",
          "parent_node": "NULL",
        }
      ],
    });
    if (res.success == true) {
      // 查询成功
      var data = res.data;
      var result = (data as List).first as String;
      macCorrespondList = result.isEmpty
          ? []
          : result.split('-').map((e) => MacCorrespond(macSection: e)).toList();
      // 获取已有值并赋值
      initMacCorrespondList();
    } else {
      // 查询失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  initMacCorrespondList() {
    Map markCodeMap = {};
    if (currentMachineMarkCode.isNotEmpty) {
      var markCodeList = currentMachineMarkCode.split('#');
      print(markCodeList);
      for (var element in markCodeList) {
        var temp = element.split('&');
        print(temp);
        markCodeMap[temp[0]] = temp[1];

        for (var e in macCorrespondList) {
          if (e.macSection == temp[0]) {
            e.correspondMacMarkCode = temp[1];
          }
        }
      }
    }

    // Map idMap = {};
    // if (currentMacMonitorId.isNotEmpty) {
    //   var idList = currentMacMonitorId.split('#');
    //   print(idList);
    //   for (var element in idList) {
    //     var temp = element.split('&');
    //     print(temp);
    //     idMap[temp[0]] = temp[1];

    //     for (var e in macCorrespondList) {
    //       if (e.macSection == temp[0]) {
    //         e.correspondMacMonitorId = temp[1];
    //       }
    //     }
    //   }
    // }
    print(markCodeMap);
    // print(idMap);
    initTableRow();
  }

  initTableRow() {
    for (var element in macCorrespondList) {
      stateManager.appendRows([
        PlutoRow(
          cells: {
            'macSection': PlutoCell(value: element.macSection!),
            'correspondMacMarkCode':
                PlutoCell(value: element.correspondMacMarkCode ?? ''),
            // 'correspondMacMonitorId':
            //     PlutoCell(value: element.correspondMacMonitorId ?? ''),
          },
        )
      ]);
    }
    _initData();
  }

  onTableCellChanged(PlutoGridOnChangedEvent event) {
    print(event);
    var currentRow = stateManager.rows.elementAt(event.rowIdx);
    var macSection = currentRow.cells.entries
        .where((element) => element.key == 'macSection')
        .first
        .value
        .value;
    var changedKey = currentRow.cells.entries.elementAt(event.columnIdx).key;
    print(macSection);
    print(changedKey);
    MacCorrespond macCorrespond = macCorrespondList
        .firstWhere((element) => element.macSection == macSection);
    if (changedKey == 'correspondMacMarkCode') {
      macCorrespond.correspondMacMarkCode = event.value;
    }

    // else if (changedKey == 'correspondMacMonitorId') {
    //   macCorrespond.correspondMacMonitorId = event.value;
    // }
    updateMacCorrespondFields();
  }

  updateMacCorrespondFields() {
    var macMarkCode = '';
    for (var element in macCorrespondList) {
      if (element.correspondMacMarkCode != null &&
          element.correspondMacMarkCode != '') {
        macMarkCode +=
            '${element.macSection}&${element.correspondMacMarkCode}#';
      }
    }
    macMarkCode = macMarkCode.isNotEmpty
        ? macMarkCode.substring(0, macMarkCode.length - 1)
        : "";

    if (macMarkCode != currentMachineMarkCode) {
      setFieldValue('EActServer/MachineMarkCode', macMarkCode);
      changedList.add('EActServer/MachineMarkCode');
    }
    // if (macMonitorId != currentMacMonitorId) {
    //   setFieldValue('EManServer/MacMonitorId', macMonitorId);
    //   changedList.add('EManServer/MacMonitorId');
    // }
    _initData();
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

class MacCorrespond {
  String? macSection;
  String? correspondMacMarkCode;

  MacCorrespond({this.macSection, this.correspondMacMarkCode});

  MacCorrespond.fromJson(Map<String, dynamic> json) {
    macSection = json['MacSection'];
    correspondMacMarkCode = json['CorrespondMacMarkCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MacSection'] = this.macSection;
    data['CorrespondMacMarkCode'] = this.correspondMacMarkCode;
    return data;
  }
}
