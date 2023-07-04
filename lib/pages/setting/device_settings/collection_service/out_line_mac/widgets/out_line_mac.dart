/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 17:30:48
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-03 09:36:53
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/collection_service/out_line_mac/widgets/out_line_mac.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/api/common.dart';
import '../../../../../../common/components/field_change.dart';
import '../../../../../../common/components/field_group.dart';
import '../../../../../../common/utils/http.dart';
import '../../../../../../common/utils/popup_message.dart';

class OutLineMac extends StatefulWidget {
  const OutLineMac({Key? key, required this.section}) : super(key: key);
  final String section;
  @override
  _OutLineMacState createState() => _OutLineMacState();
}

class _OutLineMacState extends State<OutLineMac> {
  late OutLineMacInfo outLineMacInfo;
  List<RenderField> macInfoMenuList = [
    RenderFieldInfo(
      field: 'MachineNum',
      section: 'TestCMMInfo',
      name: "机床号",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'ServiceAddr',
      section: 'TestCMMInfo',
      name: "机床IP",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'ServicePort',
      section: 'TestCMMInfo',
      name: "机床端口",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'ServiceMonitorPort',
      section: 'TestCMMInfo',
      name: "机床的第二个端口（一般不用）",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'MachineUser',
      section: 'TestCMMInfo',
      name: "机床用户",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'MachinePassowrd',
      section: 'TestCMMInfo',
      name: "机床密码",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'MachineName',
      section: 'TestCMMInfo',
      name: "机床名称，不同机床间不能重复",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
        field: 'MacSystemType',
        section: 'TestCMMInfo',
        name: "机床系统类型",
        renderType: RenderType.select,
        options: {
          "发那科": "FANUC",
          "海德汉": "HDH",
          "海克斯康": "HEXAGON",
          "哈斯": "HASS",
          "精雕": "JD",
          "牧野EDM": "MAKINO",
          "沙迪克": "SODICK",
          "视觉检测": "VISUALRATE",
          "蔡司检测": "ZEISS",
          "测试": "TEST",
          "烘干": "DRY",
          "清洗": "CLEAN",
          "三菱": "SLCNC",
          "KND": "KND",
          "广数": "GSK",
          "大隈（wei）": "OKUMA"
        }),
    RenderFieldInfo(
      field: 'MacSystemVersion',
      section: 'TestCMMInfo',
      name: "机床系统版本",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
        field: 'MacBrand',
        section: 'TestCMMInfo',
        name: "机床品牌",
        renderType: RenderType.select,
        options: {
          "发那科": "FANUC",
          "海德汉": "HDH",
          "海克斯康": "HEXAGON",
          "哈斯": "HASS",
          "精雕": "JD",
          "牧野EDM": "MAKINO",
          "沙迪克": "SODICK",
          "视觉检测": "VISUALRATE",
          "蔡司检测": "ZEISS",
          "测试": "TEST",
          "烘干": "DRY",
          "清洗": "CLEAN",
          "三菱": "SLCNC",
          "KND": "KND",
          "广数": "GSK",
          "大隈（wei）": "OKUMA"
        }),
    RenderFieldInfo(
      field: 'MachineAxes',
      section: 'TestCMMInfo',
      name: "机床轴数",
      renderType: RenderType.numberInput,
    ),
  ];
  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = outLineMacInfo.toSectionMap();
    temp[field] = val;
    outLineMacInfo = OutLineMacInfo.fromSectionJson(temp, widget.section);
  }

  String? getFieldValue(String field) {
    return outLineMacInfo.toSectionMap()[field];
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
    for (var element in macInfoMenuList) {
      if (element is RenderFieldInfo) {
        element.section = widget.section;
      } else if (element is RenderFieldGroup) {
        for (var element in element.children) {
          if (element is RenderFieldInfo) element.section = widget.section;
        }
      }
    }
    setState(() {});
  }

  getSectionDetail() async {
    ResponseApiBody res = await CommonApi.getSectionDetail({
      "params": [widget.section]
    });
    if (res.success == true) {
      outLineMacInfo = OutLineMacInfo.fromSectionJson(
          (res.data as List).first, widget.section);
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
    outLineMacInfo = OutLineMacInfo(section: widget.section);
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
                icon: Icon(FluentIcons.save)),
            CommandBarSeparator(),
            CommandBarButton(
                label: Text('测试'),
                onPressed: test,
                icon: Icon(FluentIcons.test_plan)),
          ])),
          5.verticalSpacingRadius,
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              ...macInfoMenuList.map((e) {
                if (e is RenderFieldGroup) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 5.r),
                    child: FieldGroup(
                      groupName: e.groupName,
                      getValue: getFieldValue,
                      children: e.children,
                      isChanged: isChanged,
                      onChanged: (field, value) {
                        onFieldChange(field, value);
                      },
                    ),
                  );
                } else {
                  return FieldChange(
                    renderFieldInfo: e as RenderFieldInfo,
                    showValue: getFieldValue(e.fieldKey),
                    isChanged: isChanged(e.fieldKey),
                    onChanged: (field, value) {
                      onFieldChange(field, value);
                    },
                  );
                }
              }).toList()
            ],
          )))
        ],
      ),
    );
  }
}

class OutLineMacInfo {
  final String section;
  String? machineNum;
  String? serviceAddr;
  String? servicePort;
  String? serviceMonitorPort;
  String? machineUser;
  String? machinePassowrd;
  String? machineName;
  String? macSystemType;
  String? macSystemVersion;
  String? macBrand;
  String? machineAxes;

  OutLineMacInfo(
      {required this.section,
      this.machineNum,
      this.serviceAddr,
      this.servicePort,
      this.serviceMonitorPort,
      this.machineUser,
      this.machinePassowrd,
      this.machineName,
      this.macSystemType,
      this.macSystemVersion,
      this.macBrand,
      this.machineAxes});

  OutLineMacInfo.fromSectionJson(Map<String, dynamic> json, this.section) {
    machineNum = json['$section/MachineNum'];
    serviceAddr = json['$section/ServiceAddr'];
    servicePort = json['$section/ServicePort'];
    serviceMonitorPort = json['$section/ServiceMonitorPort'];
    machineUser = json['$section/MachineUser'];
    machinePassowrd = json['$section/MachinePassowrd'];
    machineName = json['$section/MachineName'];
    macSystemType = json['$section/MacSystemType'];
    macSystemVersion = json['$section/MacSystemVersion'];
    macBrand = json['$section/MacBrand'];
    machineAxes = json['$section/MachineAxes'];
  }

  Map<String, dynamic> toSectionMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$section/MachineNum'] = this.machineNum;
    data['$section/ServiceAddr'] = this.serviceAddr;
    data['$section/ServicePort'] = this.servicePort;
    data['$section/ServiceMonitorPort'] = this.serviceMonitorPort;
    data['$section/MachineUser'] = this.machineUser;
    data['$section/MachinePassowrd'] = this.machinePassowrd;
    data['$section/MachineName'] = this.machineName;
    data['$section/MacSystemType'] = this.macSystemType;
    data['$section/MacSystemVersion'] = this.macSystemVersion;
    data['$section/MacBrand'] = this.macBrand;
    data['$section/MachineAxes'] = this.machineAxes;
    return data;
  }
}
