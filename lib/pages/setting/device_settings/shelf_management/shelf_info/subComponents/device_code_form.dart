/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-18 11:30:28
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 16:16:35
 * @FilePath: /iniConfig/lib/pages/setting/device_settings/shelf_management/shelf_info/widgets/device_code_form.dart
 * @Description: 设备编号-芯片号-夹具限制 设置
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iniConfig/pages/setting/device_settings/shelf_management/shelf_info/controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class DeviceCodeForm extends StatefulWidget {
  const DeviceCodeForm({Key? key, required this.showValue}) : super(key: key);
  final String showValue;
  @override
  DeviceCodeFormState createState() => DeviceCodeFormState();
}

class DeviceCodeFormState extends State<DeviceCodeForm> {
  final List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;
  List<String> typeList = [];

  get currentValue => rows
      .where((element) =>
          element.cells['shelfDeviceCode']!.value != '' &&
          element.cells['chipCode']!.value != '' &&
          element.cells['fixtureLimit']!.value != '')
      .map((e) =>
          '${e.cells['shelfDeviceCode']!.value}#${e.cells['chipCode']!.value}^${e.cells['fixtureLimit']!.value}')
      .join('&');

  // 获取所有夹具类型
  initTypes() {
    var shelfInfoController = Get.find<ShelfInfoController>();
    var shelfInfo = shelfInfoController.shelfInfo;
    // 电极夹具
    var electrodeList = shelfInfo.fixtureTypeInfoELEC?.split('-') ?? [];
    // 钢件夹具
    var steelList = shelfInfo.fixtureTypeInfoSTEEL?.split('-') ?? [];
    // 合并去重
    typeList = mergeAndDistinct(electrodeList, steelList);
    print(typeList);
    setState(() {});
  }

  List<T> mergeAndDistinct<T>(List<T> list1, List<T> list2) {
    Set<T> set = Set<T>.from(list1)..addAll(list2);
    return List<T>.from(set);
  }

  add() {
    stateManager.appendRows([
      PlutoRow(cells: {
        'shelfDeviceCode': PlutoCell(value: ''),
        'chipCode': PlutoCell(value: ''),
        'fixtureLimit': PlutoCell(value: ''),
      })
    ]);
  }

  delete() {
    if (stateManager.currentRow == null) return;
    stateManager.removeRows([stateManager.currentRow!]);
    setState(() {});
  }

  initRows() {
    var list = widget.showValue.split('&');
    for (var element in list) {
      var shelfDeviceCode = element.split('#')[0];
      var last = element.split('#')[1];
      var chipCode = last.split('^')[0];
      var fixtureLimit = last.split('^')[1];
      stateManager.appendRows([
        PlutoRow(cells: {
          'shelfDeviceCode': PlutoCell(value: shelfDeviceCode),
          'chipCode': PlutoCell(value: chipCode),
          'fixtureLimit': PlutoCell(value: fixtureLimit),
        })
      ]);
    }
  }

  onTableCellChanged(PlutoGridOnChangedEvent event) {
    print(event);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlutoGrid(
          createHeader: (stateManager) {
            return Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  fluent.FilledButton(
                      child: Wrap(
                          spacing: 5,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [Icon(fluent.FluentIcons.add), Text('添加')]),
                      onPressed: add),
                  10.horizontalSpaceRadius,
                  fluent.FilledButton(
                      child: Wrap(
                          spacing: 5,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(fluent.FluentIcons.delete),
                            Text('删除')
                          ]),
                      onPressed: delete)
                ],
              ),
            );
          },
          rows: rows,
          columns: [
            PlutoColumn(
              title: '货位设备编号',
              field: 'shelfDeviceCode',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '芯片号',
              field: 'chipCode',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '夹具限制',
              field: 'fixtureLimit',
              type: PlutoColumnType.select(typeList),
              enableContextMenu: false,
              enableSorting: false,
            ),
          ],
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            initRows();
            // initTypes();
          },
          onChanged: onTableCellChanged,
          configuration: const PlutoGridConfiguration(
            columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale),
          )),
    );
  }
}
