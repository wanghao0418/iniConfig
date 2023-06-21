/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-20 09:26:12
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-21 13:51:33
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/shelf_management/shelf_info/widgets/shelf_info_setting.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../../../common/components/field_change.dart';
import '../../../robot/robot_scan/widgets/scan_device_form.dart';

class ShelfInfoSetting extends StatefulWidget {
  const ShelfInfoSetting({Key? key, required this.section}) : super(key: key);
  final String section;

  @override
  _ShelfInfoSettingState createState() => _ShelfInfoSettingState();
}

class _ShelfInfoSettingState extends State<ShelfInfoSetting> {
  final List<RenderFieldInfo> menuList = [
    RenderFieldInfo(
      section: 'Shelf',
      field: 'ShelfNum',
      name: '货架号',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
        section: 'Shelf',
        field: 'ShelfSensorType',
        name: '货架传感类型',
        renderType: RenderType.select,
        options: {"无传感器": "0", "平板": "1", "旋转": "2", "对射": "3"}),
    RenderFieldInfo(
      section: 'Shelf',
      field: 'ScanDeviceIndex',
      name: '分层条码枪设置，旋转货架不同层用不同的条码枪',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
        section: 'Shelf',
        field: 'ShelfFuncType',
        name: '货架功能类型',
        renderType: RenderType.select,
        options: {
          "加工": "work",
          "装载": "transfer",
          "接驳": "connection",
          "预调": "preset"
        }),
    RenderFieldInfo(
        section: 'Shelf',
        field: 'RowColl',
        name: '行列配置',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'Shelf',
        field: 'CraftPriority',
        name: '工艺优先级配置',
        renderType: RenderType.select,
        options: {
          "数据库读取": "0",
          "工艺来自配置文件，不更新工艺表": "1",
          "工艺来自配置文件，会更新工艺表": "2"
        }),
    RenderFieldInfo(
        section: 'Shelf',
        field: 'CraftLimit',
        name: '货架限制工艺',
        renderType: RenderType.numberInput),
    RenderFieldInfo(
        section: 'Shelf',
        field: 'isNoScan',
        name: '货架是否扫描',
        renderType: RenderType.radio,
        options: {"扫描": "0", "不扫描": "1"}),
    RenderFieldInfo(
        section: 'Shelf',
        field: 'IOlimit',
        name: 'IO限制',
        renderType: RenderType.select,
        options: {"出+入": "0", "只入": "1", "只出": "2"}),
    RenderFieldInfo(
        section: 'Shelf',
        field: 'ScanDeviceLimit',
        name: '条扫描设备限制',
        renderType: RenderType.numberInput),
    RenderFieldInfo(
        section: 'Shelf',
        field: 'MoreWorkpieceMark',
        name: '更多工件标记',
        renderType: RenderType.select,
        options: {
          "不查托盘表": "0",
          "查托盘表，匹配监控编号": "1",
          "查托盘表匹配barcode": "2",
          "匹配sn": "3",
        }),
    RenderFieldInfo(
        section: 'Shelf',
        field: 'Locationfunction',
        name: '货位功能',
        renderType: RenderType.select,
        options: {
          "通用": "0",
          "入库货位": "1",
          "出库货位---只是适用接驳站": "2",
        }),
    RenderFieldInfo(
      section: 'Shelf',
      field: 'ShelfDeviceCode',
      name: '货位设备编号-芯片号-及夹具限制',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      section: 'Shelf',
      field: 'UpLineLightSync',
      name: '上线按钮灯同步，入库时写9的灯，出库时写10的灯',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      section: 'Shelf',
      field: 'WorkWidthLimit',
      name: '货位宽度，长电极占用使用',
      renderType: RenderType.numberInput,
    ),
  ];
  late Shelf shelf;
  List<String> changedList = [];
  List deviceList = ["0", "1", "2", "3"];
  var currentDeviceId = '0';

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = shelf.toSectionMap();
    temp[field] = val;
    shelf = Shelf.fromSectionJson(temp, widget.section);
  }

  String? getFieldValue(String field) {
    return shelf.toSectionMap()[field];
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

  onDeviceChange(String deviceId) {
    currentDeviceId = deviceId;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shelf = Shelf(section: widget.section);
    initMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          ...menuList.map((e) {
            if (e.field == 'ScanDeviceIndex') {
              return getFieldValue('${widget.section}/ShelfSensorType') == '2'
                  ? Container(
                      margin: EdgeInsets.only(bottom: 5.r),
                      child: Expander(
                        headerHeight: 70,
                        header: Padding(
                          padding: EdgeInsets.only(left: 40.r),
                          child: Text('分层条码枪设置')
                              .fontWeight(FontWeight.bold)
                              .fontSize(16),
                        ),
                        content: SizedBox(
                            height: 500,
                            child: Column(
                              children: [
                                CommandBarCard(
                                    child: CommandBar(primaryItems: [
                                  CommandBarButton(
                                      label: Text('新增'),
                                      onPressed: () {},
                                      icon: Icon(FluentIcons.add)),
                                  CommandBarSeparator(),
                                  CommandBarButton(
                                      label: Text('删除'),
                                      onPressed: () {},
                                      icon: Icon(FluentIcons.delete)),
                                  CommandBarSeparator(),
                                  CommandBarButton(
                                      label: Text('保存'),
                                      onPressed: () {},
                                      icon: Icon(FluentIcons.save)),
                                  CommandBarSeparator(),
                                  CommandBarButton(
                                      label: Text('测试'),
                                      onPressed: () {},
                                      icon: Icon(FluentIcons.test_plan)),
                                ])),
                                5.verticalSpacingRadius,
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 200,
                                        color:
                                            FluentTheme.of(context).cardColor,
                                        child: ListView.builder(
                                            itemCount: deviceList.length,
                                            itemBuilder: (context, index) {
                                              final contact = deviceList[index];
                                              return ListTile.selectable(
                                                title: Text(contact),
                                                selected:
                                                    currentDeviceId == contact,
                                                onSelectionChange: (v) =>
                                                    onDeviceChange(contact),
                                              );
                                            }),
                                      ),
                                      10.horizontalSpaceRadius,
                                      Expanded(
                                          child: Container(
                                              color: FluentTheme.of(context)
                                                  .menuColor,
                                              padding: EdgeInsets.all(10.0),
                                              child: currentDeviceId.isEmpty
                                                  ? Container(
                                                      color: FluentTheme.of(
                                                              context)
                                                          .menuColor,
                                                    )
                                                  : ScanDeviceForm(
                                                      key: ValueKey(
                                                          currentDeviceId),
                                                      section: currentDeviceId,
                                                    ))),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ),
                    )
                  : Container();
            }
            return FieldChange(
              renderFieldInfo: e,
              showValue: getFieldValue(e.fieldKey),
              isChanged: isChanged(e.fieldKey),
              onChanged: (field, value) {
                onFieldChange(field, value);
              },
            );
          })
        ],
      ),
    ));
  }
}

class Shelf {
  final String section;
  String? shelfNum;
  String? shelfSensorType;
  String? shelfFuncType;
  String? rowColl;
  String? craftPriority;
  String? craftLimit;
  String? isNoScan;
  String? iOlimit;
  String? scanDeviceLimit;
  String? moreWorkpieceMark;
  String? locationfunction;
  String? shelfDeviceCode;
  String? upLineLightSync;
  String? workWidthLimit;
  String? scanDeviceIndex;

  Shelf(
      {required this.section,
      this.shelfNum,
      this.shelfSensorType,
      this.shelfFuncType,
      this.rowColl,
      this.craftPriority,
      this.craftLimit,
      this.isNoScan,
      this.iOlimit,
      this.scanDeviceLimit,
      this.moreWorkpieceMark,
      this.locationfunction,
      this.shelfDeviceCode,
      this.upLineLightSync,
      this.workWidthLimit,
      this.scanDeviceIndex});

  Shelf.fromJson(Map<String, dynamic> json, this.section) {
    shelfNum = json['ShelfNum'];
    shelfSensorType = json['ShelfSensorType'];
    shelfFuncType = json['ShelfFuncType'];
    rowColl = json['RowColl'];
    craftPriority = json['CraftPriority'];
    craftLimit = json['CraftLimit'];
    isNoScan = json['isNoScan'];
    iOlimit = json['IOlimit'];
    scanDeviceLimit = json['ScanDeviceLimit'];
    moreWorkpieceMark = json['MoreWorkpieceMark'];
    locationfunction = json['Locationfunction'];
    shelfDeviceCode = json['ShelfDeviceCode'];
    upLineLightSync = json['UpLineLightSync'];
    workWidthLimit = json['WorkWidthLimit'];
    scanDeviceIndex = json['ScanDeviceIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShelfNum'] = this.shelfNum;
    data['ShelfSensorType'] = this.shelfSensorType;
    data['ShelfFuncType'] = this.shelfFuncType;
    data['RowColl'] = this.rowColl;
    data['CraftPriority'] = this.craftPriority;
    data['CraftLimit'] = this.craftLimit;
    data['isNoScan'] = this.isNoScan;
    data['IOlimit'] = this.iOlimit;
    data['ScanDeviceLimit'] = this.scanDeviceLimit;
    data['MoreWorkpieceMark'] = this.moreWorkpieceMark;
    data['Locationfunction'] = this.locationfunction;
    data['ShelfDeviceCode'] = this.shelfDeviceCode;
    data['UpLineLightSync'] = this.upLineLightSync;
    data['WorkWidthLimit'] = this.workWidthLimit;
    data['ScanDeviceIndex'] = this.scanDeviceIndex;
    return data;
  }

  Map<String, dynamic> toSectionMap() {
    String section = this.section;
    Map<String, dynamic> data = Map<String, dynamic>();
    data['$section/ShelfNum'] = shelfNum;
    data['$section/ShelfSensorType'] = shelfSensorType;
    data['$section/ShelfFuncType'] = shelfFuncType;
    data['$section/RowColl'] = rowColl;
    data['$section/CraftPriority'] = craftPriority;
    data['$section/CraftLimit'] = craftLimit;
    data['$section/isNoScan'] = isNoScan;
    data['$section/IOlimit'] = iOlimit;
    data['$section/ScanDeviceLimit'] = scanDeviceLimit;
    data['$section/MoreWorkpieceMark'] = moreWorkpieceMark;
    data['$section/Locationfunction'] = locationfunction;
    data['$section/ShelfDeviceCode'] = shelfDeviceCode;
    data['$section/UpLineLightSync'] = upLineLightSync;
    data['$section/WorkWidthLimit'] = workWidthLimit;
    data['$section/ScanDeviceIndex'] = scanDeviceIndex;
    return data;
  }

  Shelf.fromSectionJson(Map<String, dynamic> json, this.section) {
    shelfNum = json['$section/ShelfNum'];
    shelfSensorType = json['$section/ShelfSensorType'];
    shelfFuncType = json['$section/ShelfFuncType'];
    rowColl = json['$section/RowColl'];
    craftPriority = json['$section/CraftPriority'];
    craftLimit = json['$section/CraftLimit'];
    isNoScan = json['$section/isNoScan'];
    iOlimit = json['$section/IOlimit'];
    scanDeviceLimit = json['$section/ScanDeviceLimit'];
    moreWorkpieceMark = json['$section/MoreWorkpieceMark'];
    locationfunction = json['$section/Locationfunction'];
    shelfDeviceCode = json['$section/ShelfDeviceCode'];
    upLineLightSync = json['$section/UpLineLightSync'];
    workWidthLimit = json['$section/WorkWidthLimit'];
    scanDeviceIndex = json['$section/ScanDeviceIndex'];
  }
}
