import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/components/field_change.dart';
import '../../../../../../common/components/field_group.dart';

class StorageLightDevice extends StatefulWidget {
  const StorageLightDevice({Key? key, required this.section}) : super(key: key);
  final String section;

  @override
  _StorageLightDeviceState createState() => _StorageLightDeviceState();
}

class _StorageLightDeviceState extends State<StorageLightDevice> {
  late StorageLight storageLight;
  List<RenderField> menuList = [
    RenderFieldInfo(
      field: 'LightIpAddr',
      section: 'StorageLightDevice',
      name: "光源IP地址",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'Port',
      section: 'StorageLightDevice',
      name: "端口",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'ShelfRange',
      section: 'StorageLightDevice',
      name: "架位范围",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'OneTimeCtrlCountMax',
      section: 'StorageLightDevice',
      name: "每一次控制灯最大数量,默认是1，物理限制是18个",
      renderType: RenderType.numberInput,
    ),
    RenderFieldInfo(
      field: 'Circuit',
      section: 'StorageLightDevice',
      name: "一个设备最多可以控制的路数",
      renderType: RenderType.numberInput,
    ),
  ];
  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = storageLight.toSectionMap();
    temp[field] = val;
    storageLight = StorageLight.fromSectionJson(temp, widget.section);
  }

  String? getFieldValue(String field) {
    return storageLight.toSectionMap()[field];
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
      if (element is RenderFieldInfo) {
        element.section = widget.section;
      } else if (element is RenderFieldGroup) {
        for (var element in element.children) {
          element.section = widget.section;
        }
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storageLight = StorageLight(section: widget.section);
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
          ...menuList.map((e) {
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
      )),
    );
  }
}

class StorageLight {
  final String section;
  String? lightIpAddr;
  String? port;
  String? shelfRange;
  String? oneTimeCtrlCountMax;
  String? circuit;

  StorageLight(
      {required this.section,
      this.lightIpAddr,
      this.port,
      this.shelfRange,
      this.oneTimeCtrlCountMax,
      this.circuit});

  StorageLight.fromJson(Map<String, dynamic> json, this.section) {
    lightIpAddr = json['LightIpAddr'];
    port = json['Port'];
    shelfRange = json['ShelfRange'];
    oneTimeCtrlCountMax = json['OneTimeCtrlCountMax'];
    circuit = json['Circuit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LightIpAddr'] = this.lightIpAddr;
    data['Port'] = this.port;
    data['ShelfRange'] = this.shelfRange;
    data['OneTimeCtrlCountMax'] = this.oneTimeCtrlCountMax;
    data['Circuit'] = this.circuit;
    return data;
  }

  Map<String, String?> toSectionMap() {
    final Map<String, String?> data = new Map<String, String?>();
    data['$section/LightIpAddr'] = this.lightIpAddr;
    data['$section/Port'] = this.port;
    data['$section/ShelfRange'] = this.shelfRange;
    data['$section/OneTimeCtrlCountMax'] = this.oneTimeCtrlCountMax;
    data['$section/Circuit'] = this.circuit;
    return data;
  }

  StorageLight.fromSectionJson(Map<String, dynamic> json, this.section) {
    lightIpAddr = json['$section/LightIpAddr'];
    port = json['$section/Port'];
    shelfRange = json['$section/ShelfRange'];
    oneTimeCtrlCountMax = json['$section/OneTimeCtrlCountMax'];
    circuit = json['$section/Circuit'];
  }
}
