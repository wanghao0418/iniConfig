/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-18 16:40:28
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 16:16:16
 * @FilePath: /iniConfig/lib/pages/setting/device_settings/machine/machine_info/widgets/chuck_number_info.dart
 * @Description: 卡盘号信息设置组件
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/api/common.dart';
import 'package:iniConfig/common/utils/http.dart';
import 'package:iniConfig/common/utils/popup_message.dart';
import 'package:iniConfig/pages/setting/device_settings/shelf_management/shelf_info/controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class ChuckNumberInfo extends StatefulWidget {
  const ChuckNumberInfo({Key? key, required this.showValue}) : super(key: key);
  final String showValue;
  @override
  ChuckNumberInfoState createState() => ChuckNumberInfoState();
}

class ChuckNumberInfoState extends State<ChuckNumberInfo> {
  final List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;
  List<String> typeList = [];

  get currentValue => rows
      .where((element) =>
          element.cells['number']!.value != '' &&
          element.cells['type']!.value != '' &&
          element.cells['position']!.value != '')
      .map((e) =>
          '${e.cells['number']!.value}#${e.cells['type']!.value}*${e.cells['position']!.value}')
      .join('-');

  initRows() {
    var list = widget.showValue.split('-');
    for (var element in list) {
      var number = element.split('#')[0];
      var last = element.split('#')[1];
      var type = last.split('*')[0];
      var position = last.split('*')[1];
      stateManager.appendRows([
        PlutoRow(cells: {
          'number': PlutoCell(value: number),
          'type': PlutoCell(value: type),
          'position': PlutoCell(value: position),
        })
      ]);
    }
    setState(() {});
  }

  onTableCellChanged(PlutoGridOnChangedEvent event) {
    print(event);
  }

  add() {
    stateManager.appendRows([
      PlutoRow(cells: {
        'number': PlutoCell(value: ''),
        'type': PlutoCell(value: ''),
        'position': PlutoCell(value: ''),
      })
    ]);
  }

  delete() {
    if (stateManager.currentRow == null) return;
    stateManager.removeRows([stateManager.currentRow!]);
    setState(() {});
  }

  // 获取所有夹具类型
  initTypes() async {
    // var shelfInfoController = Get.find<ShelfInfoController>();
    ResponseApiBody res = await CommonApi.fieldQuery({
      "params": ['FixtureTypeInfo/STEEL', 'FixtureTypeInfo/ELEC'],
    });
    if (res.success == true) {
      // 查询成功
      var shelfInfo = ShelfInfo.fromJson(res.data);
      // 电极夹具
      var electrodeList = shelfInfo.fixtureTypeInfoELEC?.split('-') ?? [];
      // 钢件夹具
      var steelList = shelfInfo.fixtureTypeInfoSTEEL?.split('-') ?? [];
      // 合并去重
      typeList = mergeAndDistinct(electrodeList, steelList);
      stateManager.columns[1].type = PlutoColumnType.select(typeList);
    } else {
      // 保存失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
    initRows();
  }

  List<T> mergeAndDistinct<T>(List<T> list1, List<T> list2) {
    Set<T> set = Set<T>.from(list1)..addAll(list2);
    return List<T>.from(set);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              title: '卡盘号',
              field: 'number',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '卡盘类型',
              field: 'type',
              type: PlutoColumnType.select(typeList),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '坐标系名称',
              field: 'position',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false,
            ),
          ],
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            // initRows();
            initTypes();
          },
          onChanged: onTableCellChanged,
          configuration: const PlutoGridConfiguration(
            columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale),
          )),
    );
  }
}
