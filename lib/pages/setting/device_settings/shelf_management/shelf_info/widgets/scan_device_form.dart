/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-16 17:13:14
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 13:54:42
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/robot/robot_scan/widgets/scan_device.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/api/common.dart';
import 'package:iniConfig/common/style/global_theme.dart';
import 'package:iniConfig/common/utils/http.dart';
import 'package:iniConfig/common/utils/popup_message.dart';

import '../../../../../../common/components/field_change.dart';

class ScanDeviceForm extends StatefulWidget {
  const ScanDeviceForm({Key? key, required this.section}) : super(key: key);
  final String section;
  @override
  ScanDeviceStateForm createState() => ScanDeviceStateForm();
}

class ScanDeviceStateForm extends State<ScanDeviceForm> {
  final List<RenderFieldInfo> menuList = [
    RenderFieldInfo(
        section: 'ScanDevice',
        field: 'ServiceType',
        name: '扫描设备类型',
        renderType: RenderType.select,
        options: {
          "条码枪": "1",
          "巴鲁夫读头": "2",
          "倍加福读头": "3",
          "欧姆龙读头": "4",
          "plc读头": "5"
        }),
    RenderFieldInfo(
        section: 'ScanDevice',
        field: 'ServiceAddr',
        name: 'IP',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'ScanDevice',
        field: 'ServicePort',
        name: '端口',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'ScanDevice',
        field: 'LeftReadPos',
        name: '读取的字符串左边截取位置',
        renderType: RenderType.numberInput),
    RenderFieldInfo(
        section: 'ScanDevice',
        field: 'RightReadPos',
        name: '读取的字符串右边截取位置',
        renderType: RenderType.numberInput),
    RenderFieldInfo(
        section: 'ScanDevice',
        field: 'ReadUnitSize',
        name: '单个芯片的存储大小',
        renderType: RenderType.numberInput),
    RenderFieldInfo(
        section: 'ScanDevice',
        field: 'ScanTimes',
        name: '扫描设备总的扫描次数',
        renderType: RenderType.numberInput),
    RenderFieldInfo(
        section: 'ScanDevice',
        field: 'ScanHeadFlag',
        name: '条码枪头部标识',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'ScanDevice',
        field: 'IsScanMark',
        name: '是否有检验码',
        renderType: RenderType.toggleSwitch),
    RenderFieldInfo(
        section: 'ScanDevice',
        field: 'ScanStartMark',
        name: '条码起始校验码',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'ScanDevice',
        field: 'ScanEndMark',
        name: '条码结束校验码',
        renderType: RenderType.input),
  ];
  late ScanDevice scanDevice;
  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = scanDevice.toUpdateMap();
    temp[field] = val;
    scanDevice = ScanDevice.fromSectionJson(temp, widget.section);
  }

  String? getFieldValue(String field) {
    return scanDevice.toUpdateMap()[field];
  }

  void onFieldChange(String field, String value) {
    if (value == getFieldValue(field)) {
      return;
    }
    if (!changedList.contains(field)) {
      changedList.add(field);
    }
    setFieldValue(field, value);
    setState(() {});
  }

  initMenu() {
    for (var element in menuList) {
      element.section = widget.section;
    }
    setState(() {});
  }

  getSectionDetail() async {
    ResponseApiBody res = await CommonApi.getSectionDetail({
      "params": [widget.section]
    });
    if (res.success == true) {
      scanDevice =
          ScanDevice.fromSectionJson((res.data as List).first, widget.section);
      setState(() {});
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  save() async {
    if (changedList.isEmpty) {
      return;
    }
    var dataList = _makeParams();
    ResponseApiBody res = await CommonApi.fieldUpdate({"params": dataList});
    if (res.success == true) {
      PopupMessage.showSuccessInfoBar('保存成功');
      changedList = [];
      setState(() {});
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  test() {
    PopupMessage.showWarningInfoBar('暂未开放');
  }

  _makeParams() {
    List<Map<String, dynamic>> params = [];
    for (var element in changedList) {
      params.add({"key": element, "value": getFieldValue(element)});
    }
    return params;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scanDevice = ScanDevice(section: widget.section);
    initMenu();
    getSectionDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            CommandBarCard(
                child: CommandBar(primaryItems: [
              CommandBarButton(
                  label: Text('保存'),
                  onPressed: save,
                  icon: Icon(
                    FluentIcons.save,
                    color: GlobalTheme.instance.buttonIconColor,
                  )),
              CommandBarSeparator(
                color: GlobalTheme.instance.buttonIconColor,
              ),
              CommandBarButton(
                  label: Text('测试'),
                  onPressed: test,
                  icon: Icon(
                    FluentIcons.test_plan,
                    color: GlobalTheme.instance.buttonIconColor,
                  )),
            ])),
            5.verticalSpacingRadius,
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  ...menuList.map((e) => FieldChange(
                        renderFieldInfo: e,
                        showValue: getFieldValue(e.fieldKey),
                        isChanged: isChanged(e.fieldKey),
                        onChanged: (field, value) {
                          onFieldChange(field, value);
                        },
                      ))
                ],
              ),
            ))
          ],
        ));
  }
}

class ScanDevice {
  String section;
  String? serviceType;
  String? serviceAddr;
  String? servicePort;
  String? leftReadPos;
  String? rightReadPos;
  String? readUnitSize;
  String? scanTimes;
  String? scanHeadFlag;
  String? isScanMark;
  String? scanStartMark;
  String? scanEndMark;

  ScanDevice(
      {required this.section,
      this.serviceType,
      this.serviceAddr,
      this.servicePort,
      this.leftReadPos,
      this.rightReadPos,
      this.readUnitSize,
      this.scanTimes,
      this.scanHeadFlag,
      this.isScanMark,
      this.scanStartMark,
      this.scanEndMark});

  ScanDevice.fromJson(Map<String, dynamic> json, this.section) {
    serviceType = json['ServiceType'];
    serviceAddr = json['ServiceAddr'];
    servicePort = json['ServicePort'];
    leftReadPos = json['LeftReadPos'];
    rightReadPos = json['RightReadPos'];
    readUnitSize = json['ReadUnitSize'];
    scanTimes = json['ScanTimes'];
    scanHeadFlag = json['ScanHeadFlag'];
    isScanMark = json['IsScanMark'];
    scanStartMark = json['ScanStartMark'];
    scanEndMark = json['ScanEndMark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ServiceType'] = this.serviceType;
    data['ServiceAddr'] = this.serviceAddr;
    data['ServicePort'] = this.servicePort;
    data['LeftReadPos'] = this.leftReadPos;
    data['RightReadPos'] = this.rightReadPos;
    data['ReadUnitSize'] = this.readUnitSize;
    data['ScanTimes'] = this.scanTimes;
    data['ScanHeadFlag'] = this.scanHeadFlag;
    data['IsScanMark'] = this.isScanMark;
    data['ScanStartMark'] = this.scanStartMark;
    data['ScanEndMark'] = this.scanEndMark;
    return data;
  }

  ScanDevice.fromSectionJson(Map<String, dynamic> json, this.section) {
    var sectionStr = section;
    serviceType = json['${sectionStr}/ServiceType'];
    serviceAddr = json['${sectionStr}/ServiceAddr'];
    servicePort = json['${sectionStr}/ServicePort'];
    leftReadPos = json['${sectionStr}/LeftReadPos'];
    rightReadPos = json['${sectionStr}/RightReadPos'];
    readUnitSize = json['${sectionStr}/ReadUnitSize'];
    scanTimes = json['${sectionStr}/ScanTimes'];
    scanHeadFlag = json['${sectionStr}/ScanHeadFlag'];
    isScanMark = json['${sectionStr}/IsScanMark'];
    scanStartMark = json['${sectionStr}/ScanStartMark'];
    scanEndMark = json['${sectionStr}/ScanEndMark'];
  }

  Map<String, dynamic> toUpdateMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    var sectionStr = this.section;
    data['${sectionStr}/ServiceType'] = this.serviceType;
    data['${sectionStr}/ServiceAddr'] = this.serviceAddr;
    data['${sectionStr}/ServicePort'] = this.servicePort;
    data['${sectionStr}/LeftReadPos'] = this.leftReadPos;
    data['${sectionStr}/RightReadPos'] = this.rightReadPos;
    data['${sectionStr}/ReadUnitSize'] = this.readUnitSize;
    data['${sectionStr}/ScanTimes'] = this.scanTimes;
    data['${sectionStr}/ScanHeadFlag'] = this.scanHeadFlag;
    data['${sectionStr}/IsScanMark'] = this.isScanMark;
    data['${sectionStr}/ScanStartMark'] = this.scanStartMark;
    data['${sectionStr}/ScanEndMark'] = this.scanEndMark;
    return data;
  }
}
