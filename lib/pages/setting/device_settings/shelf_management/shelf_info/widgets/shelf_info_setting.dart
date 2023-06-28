/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-20 09:26:12
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-28 10:50:08
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/shelf_management/shelf_info/widgets/shelf_info_setting.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/utils/popup_message.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../../../common/api/common.dart';
import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/http.dart';
import 'scan_device_form.dart';

class ShelfInfoSetting extends StatefulWidget {
  const ShelfInfoSetting({Key? key, required this.section}) : super(key: key);
  final String section;

  @override
  _ShelfInfoSettingState createState() => _ShelfInfoSettingState();
}

class _ShelfInfoSettingState extends State<ShelfInfoSetting> {
  final List<RenderField> menuList = [
    RenderFieldGroup(groupName: "货架基础信息", isExpanded: true, children: [
      RenderFieldInfo(
        section: 'Shelf',
        field: 'ShelfNum',
        name: '货架号',
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          section: 'Shelf',
          field: 'RowColl',
          name: '行列配置',
          renderType: RenderType.input),
    ]),
    RenderFieldGroup(groupName: "货架功能信息", children: [
      RenderFieldInfo(
          section: 'Shelf',
          field: 'ShelfSensorType',
          name: '货架传感类型',
          renderType: RenderType.select,
          options: {"无传感器": "0", "平板": "1", "旋转": "2", "对射": "3"}),
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
    ]),
    RenderFieldGroup(groupName: "货架接驳信息", children: [
      RenderFieldInfo(
          section: 'Shelf',
          field: 'IOlimit',
          name: 'IO限制',
          renderType: RenderType.select,
          options: {"出+入": "0", "只入": "1", "只出": "2"}),
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
    ]),
    RenderFieldGroup(groupName: "货架扫描信息", children: [
      RenderFieldInfo(
          section: 'Shelf',
          field: 'ScanDeviceLimit',
          name: '扫描设备限制',
          renderType: RenderType.numberInput),
      // RenderFieldInfo(
      //   section: 'Shelf',
      //   field: 'ScanDeviceIndex',
      //   name: '分层条码枪设置，旋转货架不同层用不同的条码枪',
      //   renderType: RenderType.input,
      // ),
    ]),
    RenderFieldGroup(groupName: "货架安全信息", children: [
      RenderFieldInfo(
        section: 'Shelf',
        field: 'WorkWidthLimit',
        name: '货位宽度，长电极占用使用',
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        section: 'Shelf',
        field: 'StorageSpace',
        name: '货位间距【毫米】(真实零件两边需各减去10毫米 得到80毫米)',
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        section: 'Shelf',
        field: 'WorkpieceSpecLimit',
        name:
            '零件尺寸限制【毫米】（电极的长宽高限制分别为 120，120，120，钢件的长宽高限制分别为 140，140，125，为空，则不判断）',
        renderType: RenderType.input,
      ),
    ]),
  ];
  late Shelf shelf;
  List<String> changedList = [];
  List deviceList = [];
  var currentDeviceId = '';
  ValueNotifier<String> currentShelfSensorTypeNotifier =
      ValueNotifier<String>('');

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
    ResponseApiBody res = await CommonApi.getSectionDetail(widget.section);
    if (res.success == true) {
      shelf = Shelf.fromSectionJson(res.data, widget.section);
      currentShelfSensorTypeNotifier =
          ValueNotifier<String>(currentShelfSensorType ?? '');
      setState(() {});
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  String? get currentShelfSensorType =>
      getFieldValue('${widget.section}/ShelfSensorType');

  save() {
    if (changedList.isEmpty) {
      return;
    }
    var dataList = _makeParams();
    changedList = [];
    setState(() {});
    return dataList;
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

  // 获取扫描设备列表
  void getSectionList() async {
    ResponseApiBody res = await CommonApi.getSectionList({
      "params": [
        {
          "list_node": "ScanDevice",
          "parent_node": widget.section,
        }
      ],
    });
    if (res.success == true) {
      // 查询成功
      var data = res.data;
      deviceList = ((data as List).first as String).split('-');
      currentDeviceId = deviceList.isNotEmpty ? deviceList.first : [];
      setState(() {});
    } else {
      // 查询失败
      PopupMessage.showFailInfoBar("查询失败");
    }
  }

  // 新增扫描设备
  void add() async {
    var res = await CommonApi.addSection({
      "params": [
        {
          "list_node": "ScanDevice",
          "parent_node": widget.section,
        }
      ],
    });
    if (res.success == true) {
      // 新增成功
      // getSectionList();
      setState(() {
        deviceList.add((res.data as List).first as String);
      });
    } else {
      // 新增失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 删除扫描设备
  void delete() async {
    var res = await CommonApi.deleteSection({
      "params": [
        {
          "list_node": currentDeviceId,
          "parent_node": widget.section,
        }
      ],
    });
    if (res.success == true) {
      // 删除成功
      // getSectionList();
      setState(() {
        deviceList.remove(currentDeviceId);
        currentDeviceId = deviceList.isNotEmpty ? deviceList.first : "";
      });
    } else {
      // 删除失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
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
    currentShelfSensorTypeNotifier.addListener(() {
      if (currentShelfSensorTypeNotifier.value == '2') {
        // 获取扫描设备
        getSectionList();
      }
    });
    getSectionDetail();
  }

  _buildRenderField(RenderField info) {
    if (info is RenderFieldGroup) {
      return Container(
        margin: EdgeInsets.only(bottom: 5.r),
        child: FieldGroup(
          isExpanded: info.isExpanded ?? false,
          visible: info.visible ?? true,
          groupName: info.groupName,
          getValue: getFieldValue,
          children: info.children,
          isChanged: isChanged,
          onChanged: (field, value) {
            onFieldChange(field, value);
          },
        ),
      );
    } else {
      return FieldChange(
        renderFieldInfo: info as RenderFieldInfo,
        showValue: getFieldValue(info.fieldKey),
        isChanged: isChanged(info.fieldKey),
        onChanged: (field, value) {
          onFieldChange(field, value);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        CommandBarCard(
            child: CommandBar(primaryItems: [
          CommandBarButton(
              label: Text('保存'), onPressed: save, icon: Icon(FluentIcons.save)),
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
              ...menuList.map((e) => _buildRenderField(e)),
              if (currentShelfSensorType == '2')
                Container(
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
                                  onPressed: add,
                                  icon: Icon(FluentIcons.add)),
                              CommandBarSeparator(),
                              CommandBarButton(
                                  label: Text('删除'),
                                  onPressed: delete,
                                  icon: Icon(FluentIcons.delete)),
                            ])),
                            5.verticalSpacingRadius,
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 200,
                                    color: FluentTheme.of(context).cardColor,
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
                                          color:
                                              FluentTheme.of(context).menuColor,
                                          padding: EdgeInsets.all(10.0),
                                          child: currentDeviceId.isEmpty
                                              ? Container(
                                                  color: FluentTheme.of(context)
                                                      .menuColor,
                                                )
                                              : ScanDeviceForm(
                                                  key:
                                                      ValueKey(currentDeviceId),
                                                  section: currentDeviceId,
                                                ))),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                )
            ],
          ),
        ))
      ],
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
  String? storageSpace;
  String? workpieceSpecLimit;

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
      this.scanDeviceIndex,
      this.storageSpace,
      this.workpieceSpecLimit});

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
    storageSpace = json['StorageSpace'];
    workpieceSpecLimit = json['WorkpieceSpecLimit'];
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
    data['StorageSpace'] = this.storageSpace;
    data['WorkpieceSpecLimit'] = this.workpieceSpecLimit;
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
    data['$section/StorageSpace'] = storageSpace;
    data['$section/WorkpieceSpecLimit'] = workpieceSpecLimit;
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
    storageSpace = json['$section/StorageSpace'];
    workpieceSpecLimit = json['$section/WorkpieceSpecLimit'];
  }
}
