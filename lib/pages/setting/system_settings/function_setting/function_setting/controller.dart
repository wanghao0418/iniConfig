import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iniConfig/common/index.dart';
import 'package:iniConfig/pages/setting/system_settings/function_setting/function_setting/subComponents/fixed_quality_setting.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class FunctionSettingController extends GetxController {
  FunctionSettingController();
  FunctionSetting functionSetting = FunctionSetting();
  List<RenderField> menuList = [
    RenderFieldGroup(groupName: "工件密度设置", children: [
      RenderFieldInfo(
        field: 'FixtureQualit',
        section: 'WorkpriceInfo',
        renderType: RenderType.custom,
        name: "固定质量",
      ),
      RenderFieldInfo(
          field: '8.89',
          section: 'WorkpriceInfo',
          renderType: RenderType.customMultipleChoice,
          name: "密度8.89对应的工件材料",
          splitKey: '-'),
      RenderFieldInfo(
          field: '1.85',
          section: 'WorkpriceInfo',
          renderType: RenderType.customMultipleChoice,
          name: "密度1.85对应的工件材料",
          splitKey: '-'),
    ]),
    RenderFieldGroup(groupName: "界面设置", children: [
      RenderFieldInfo(
          field: 'CheckStrorageExist',
          section: 'AutoUiConfig',
          renderType: RenderType.radio,
          name: "货位左上角勾选框存在表示",
          options: {"不显示": "0", "显示": "1"}),
      RenderFieldInfo(
          field: 'ProgressBarMode',
          section: 'AutoUiConfig',
          renderType: RenderType.radio,
          name: "滚动条显示标志",
          options: {"不显示": "0", "显示": "1"}),
      RenderFieldInfo(
        field: 'WidgetPage',
        section: 'AutoUiConfig',
        renderType: RenderType.input,
        name: "界面查询界面隐藏配置",
      ),
      RenderFieldInfo(
          field: 'MacUiWidgetePage',
          section: 'AutoUiConfig',
          renderType: RenderType.select,
          name: "机床管理隐藏对应的对应的界面",
          options: {
            "隐藏自动化机床界面": "1",
            "隐藏刀具管理界面": "2",
            "隐藏出入库记录界面": "3",
            "隐藏设备刀库界面": "4",
            "隐藏寿命监控界面": "5",
            "隐藏其他设备界面": "6",
            "全部显示": "0"
          }),
      RenderFieldInfo(
          field: 'ShowTipInfoMark',
          section: 'AutoUiConfig',
          renderType: RenderType.radio,
          name: "货位悬浮框提示标志",
          options: {"不显示": "0", "显示": "1"}),
      RenderFieldInfo(
        field: 'DeskTipShowTime',
        section: 'AutoUiConfig',
        renderType: RenderType.numberInput,
        name: "显示桌面右下角的弹窗提示（输入秒数）",
      ),
      RenderFieldInfo(
          field: 'BtnStartUpMachineMark',
          section: 'AutoUiConfig',
          renderType: RenderType.radio,
          name: "机床管理界面一键启动按钮是否显示",
          options: {"不显示": "0", "显示": "1"}),
      RenderFieldInfo(
          field: 'BtnSetUpMachineMark',
          section: 'AutoUiConfig',
          renderType: RenderType.radio,
          name: "机床管理界面设置按钮隐藏按钮是否显示",
          options: {"不显示": "0", "显示": "1"}),
      RenderFieldInfo(
          field: 'CtrlButtonStyle',
          section: 'AutoUiConfig',
          renderType: RenderType.select,
          name: "状态栏控制按钮配置",
          options: {
            "显示开始，停止按钮": "1",
            "显示开始，停止，继续，暂停按钮": "2",
            "全部按钮显示": "3",
            "显示继续按钮": "4",
            "显示开始，停止，启动运行按钮": "6"
          }),
      RenderFieldInfo(
          field: 'AgvOperBtnShowMark',
          section: 'AutoUiConfig',
          renderType: RenderType.radio,
          name: "agv操作按钮显示标志",
          options: {"不显示": "0", "显示": "1"}),
    ]),
    RenderFieldGroup(groupName: "安全设置", children: [
      RenderFieldInfo(
        field: 'AddSteelSetOff',
        section: 'SysInfo',
        renderType: RenderType.radio,
        name: "钢件偏移量的标识",
        options: {"不显示": "0", "显示": "1"},
      ),
      RenderFieldInfo(
        field: 'AddSteelClampFace',
        section: 'SysInfo',
        renderType: RenderType.radio,
        name: "钢件程序选面标识（精英扫描时查询程序用到）",
        options: {"不显示": "0", "显示": "1"},
      ),
      RenderFieldInfo(
        field: 'CheckFenceDoorMark',
        section: 'SysInfo',
        renderType: RenderType.radio,
        name: "检查围栏门标志",
        options: {"检查": "0", "不检查（威迪亚）": "1"},
      ),
      RenderFieldInfo(
        field: 'PreReportCheck',
        section: 'SysInfo',
        renderType: RenderType.radio,
        name: "前置报工校验，前置工艺没扫成，设置异常",
        options: {"不检验": "0", "检验": "1"},
      ),
      RenderFieldInfo(
        field: 'ThreeDimensionalElectrodeMark',
        section: 'SysInfo',
        renderType: RenderType.radio,
        name: "标识校验电极是立体工的标识",
        options: {"不校验": "0", "校验": "1"},
      ),
      RenderFieldInfo(
        field: 'ScanSkipCheckPrgCraft',
        section: 'SysInfo',
        renderType: RenderType.input,
        name: "扫描时跳过程序检查标志,配置在此的不需要校验程序",
      ),
      RenderFieldInfo(
        field: 'SkipCraftReprocessCheck',
        section: 'SysInfo',
        renderType: RenderType.customMultipleChoice,
        name: "跳过工序校验结果表，配置在此的不需要校验结果表",
        splitKey: '#',
      ),
      RenderFieldInfo(
        field: 'OvertimeAlarmDuration',
        section: 'SysInfo',
        renderType: RenderType.numberInput,
        name: "超时报警蜂鸣时长,单位：秒(配置多少秒后，蜂鸣取消，机器人继续)",
      ),
      RenderFieldInfo(
        field: 'ClampHightLowMark',
        section: 'SysInfo',
        renderType: RenderType.radio,
        name: "获取电极的装夹高度最低下限",
        options: {"不获取": "0", "获取": "1"},
      ),
    ])
  ];

  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = functionSetting.toJson();
    temp[field] = val;
    functionSetting = FunctionSetting.fromJson(temp);
  }

  String? getFieldValue(String field) {
    return functionSetting.toJson()[field];
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
      "params": functionSetting.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      functionSetting = FunctionSetting.fromJson(res.data);
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

  // 定制组件------------------------

  Widget _buildFixedQuality(BuildContext context, RenderFieldInfo info) {
    return FilledButton(
        child: const Text('编辑'),
        onPressed: () {
          var _key = GlobalKey();
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  constraints: const BoxConstraints(maxWidth: 500),
                  title: Text('${info.name}').fontSize(24.sp),
                  content: SizedBox(
                    height: 300,
                    child: FixedQualitySetting(
                      key: _key,
                      showValue: getFieldValue(info.fieldKey) ?? '',
                    ),
                  ),
                  actions: [
                    Button(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消')),
                    FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          var state =
                              _key.currentState! as FixedQualitySettingState;
                          var value = state.currentValue;
                          onFieldChange(info.fieldKey, value);
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  _initData() {
    update(["function_setting"]);
  }

  initMenu() {
    for (var element in menuList) {
      if (element is RenderFieldGroup) {
        for (var item in element.children) {
          if (item is RenderFieldInfo) {
            if (item.field == 'FixtureQualit') {
              item.builder = (context) {
                return _buildFixedQuality(context, item);
              };
            }
          }
        }
      } else if (element is RenderFieldInfo) {}
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    initMenu();
    query();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

class FunctionSetting {
  String? workpriceInfoFixtureQualit;
  String? workpriceInfo889;
  String? workpriceInfo185;
  String? autoUiConfigCheckStrorageExist;
  String? autoUiConfigProgressBarMode;
  String? autoUiConfigWidgetPage;
  String? autoUiConfigMacUiWidgetePage;
  String? autoUiConfigShowTipInfoMark;
  String? autoUiConfigDeskTipShowTime;
  String? autoUiConfigBtnStartUpMachineMark;
  String? autoUiConfigBtnSetUpMachineMark;
  String? autoUiConfigCtrlButtonStyle;
  String? autoUiConfigAgvOperBtnShowMark;
  String? sysInfoAddSteelSetOff;
  String? sysInfoAddSteelClampFace;
  String? sysInfoCheckFenceDoorMark;
  String? sysInfoPreReportCheck;
  String? sysInfoThreeDimensionalElectrodeMark;
  String? sysInfoScanSkipCheckPrgCraft;
  String? sysInfoSkipCraftReprocessCheck;
  String? sysInfoOvertimeAlarmDuration;
  String? sysInfoClampHightLowMark;

  FunctionSetting(
      {this.workpriceInfoFixtureQualit,
      this.workpriceInfo889,
      this.workpriceInfo185,
      this.autoUiConfigCheckStrorageExist,
      this.autoUiConfigProgressBarMode,
      this.autoUiConfigWidgetPage,
      this.autoUiConfigMacUiWidgetePage,
      this.autoUiConfigShowTipInfoMark,
      this.autoUiConfigDeskTipShowTime,
      this.autoUiConfigBtnStartUpMachineMark,
      this.autoUiConfigBtnSetUpMachineMark,
      this.autoUiConfigCtrlButtonStyle,
      this.autoUiConfigAgvOperBtnShowMark,
      this.sysInfoAddSteelSetOff,
      this.sysInfoAddSteelClampFace,
      this.sysInfoCheckFenceDoorMark,
      this.sysInfoPreReportCheck,
      this.sysInfoThreeDimensionalElectrodeMark,
      this.sysInfoScanSkipCheckPrgCraft,
      this.sysInfoSkipCraftReprocessCheck,
      this.sysInfoOvertimeAlarmDuration,
      this.sysInfoClampHightLowMark});

  FunctionSetting.fromJson(Map<String, dynamic> json) {
    workpriceInfoFixtureQualit = json['WorkpriceInfo/FixtureQualit'];
    workpriceInfo889 = json['WorkpriceInfo/8.89'];
    workpriceInfo185 = json['WorkpriceInfo/1.85'];
    autoUiConfigCheckStrorageExist = json['AutoUiConfig/CheckStrorageExist'];
    autoUiConfigProgressBarMode = json['AutoUiConfig/ProgressBarMode'];
    autoUiConfigWidgetPage = json['AutoUiConfig/WidgetPage'];
    autoUiConfigMacUiWidgetePage = json['AutoUiConfig/MacUiWidgetePage'];
    autoUiConfigShowTipInfoMark = json['AutoUiConfig/ShowTipInfoMark'];
    autoUiConfigDeskTipShowTime = json['AutoUiConfig/DeskTipShowTime'];
    autoUiConfigBtnStartUpMachineMark =
        json['AutoUiConfig/BtnStartUpMachineMark'];
    autoUiConfigBtnSetUpMachineMark = json['AutoUiConfig/BtnSetUpMachineMark'];
    autoUiConfigCtrlButtonStyle = json['AutoUiConfig/CtrlButtonStyle'];
    autoUiConfigAgvOperBtnShowMark = json['AutoUiConfig/AgvOperBtnShowMark'];
    sysInfoAddSteelSetOff = json['SysInfo/AddSteelSetOff'];
    sysInfoAddSteelClampFace = json['SysInfo/AddSteelClampFace'];
    sysInfoCheckFenceDoorMark = json['SysInfo/CheckFenceDoorMark'];
    sysInfoPreReportCheck = json['SysInfo/PreReportCheck'];
    sysInfoThreeDimensionalElectrodeMark =
        json['SysInfo/ThreeDimensionalElectrodeMark'];
    sysInfoScanSkipCheckPrgCraft = json['SysInfo/ScanSkipCheckPrgCraft'];
    sysInfoSkipCraftReprocessCheck = json['SysInfo/SkipCraftReprocessCheck'];
    sysInfoOvertimeAlarmDuration = json['SysInfo/OvertimeAlarmDuration'];
    sysInfoClampHightLowMark = json['SysInfo/ClampHightLowMark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WorkpriceInfo/FixtureQualit'] = this.workpriceInfoFixtureQualit;
    data['WorkpriceInfo/8.89'] = this.workpriceInfo889;
    data['WorkpriceInfo/1.85'] = this.workpriceInfo185;
    data['AutoUiConfig/CheckStrorageExist'] =
        this.autoUiConfigCheckStrorageExist;
    data['AutoUiConfig/ProgressBarMode'] = this.autoUiConfigProgressBarMode;
    data['AutoUiConfig/WidgetPage'] = this.autoUiConfigWidgetPage;
    data['AutoUiConfig/MacUiWidgetePage'] = this.autoUiConfigMacUiWidgetePage;
    data['AutoUiConfig/ShowTipInfoMark'] = this.autoUiConfigShowTipInfoMark;
    data['AutoUiConfig/DeskTipShowTime'] = this.autoUiConfigDeskTipShowTime;
    data['AutoUiConfig/BtnStartUpMachineMark'] =
        this.autoUiConfigBtnStartUpMachineMark;
    data['AutoUiConfig/BtnSetUpMachineMark'] =
        this.autoUiConfigBtnSetUpMachineMark;
    data['AutoUiConfig/CtrlButtonStyle'] = this.autoUiConfigCtrlButtonStyle;
    data['AutoUiConfig/AgvOperBtnShowMark'] =
        this.autoUiConfigAgvOperBtnShowMark;
    data['SysInfo/AddSteelSetOff'] = this.sysInfoAddSteelSetOff;
    data['SysInfo/AddSteelClampFace'] = this.sysInfoAddSteelClampFace;
    data['SysInfo/CheckFenceDoorMark'] = this.sysInfoCheckFenceDoorMark;
    data['SysInfo/PreReportCheck'] = this.sysInfoPreReportCheck;
    data['SysInfo/ThreeDimensionalElectrodeMark'] =
        this.sysInfoThreeDimensionalElectrodeMark;
    data['SysInfo/ScanSkipCheckPrgCraft'] = this.sysInfoScanSkipCheckPrgCraft;
    data['SysInfo/SkipCraftReprocessCheck'] =
        this.sysInfoSkipCraftReprocessCheck;
    data['SysInfo/OvertimeAlarmDuration'] = this.sysInfoOvertimeAlarmDuration;
    data['SysInfo/ClampHightLowMark'] = this.sysInfoClampHightLowMark;
    return data;
  }
}
