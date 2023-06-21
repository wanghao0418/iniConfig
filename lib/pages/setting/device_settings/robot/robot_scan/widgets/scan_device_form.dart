/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-16 17:13:14
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-21 18:19:22
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/robot/robot_scan/widgets/scan_device.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';

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
        name: '条码枪头部标识, 瑞德 配 BO',
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

  onSave() {
    if (changedList.length == 0) {
      return;
    }
    var dataList = _makeParams();
    changedList = [];
    setState(() {});
    return dataList;
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
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

  ScanDevice(
      {required this.section,
      this.serviceType,
      this.serviceAddr,
      this.servicePort,
      this.leftReadPos,
      this.rightReadPos,
      this.readUnitSize,
      this.scanTimes,
      this.scanHeadFlag});

  ScanDevice.fromJson(Map<String, dynamic> json, this.section) {
    serviceType = json['ServiceType'];
    serviceAddr = json['ServiceAddr'];
    servicePort = json['ServicePort'];
    leftReadPos = json['LeftReadPos'];
    rightReadPos = json['RightReadPos'];
    readUnitSize = json['ReadUnitSize'];
    scanTimes = json['ScanTimes'];
    scanHeadFlag = json['ScanHeadFlag'];
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
    return data;
  }
}
