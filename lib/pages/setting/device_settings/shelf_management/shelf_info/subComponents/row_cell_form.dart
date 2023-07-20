import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../controller.dart';

class RowCellForm extends StatefulWidget {
  const RowCellForm({Key? key, required this.showValue}) : super(key: key);
  final String showValue;

  @override
  RowCellFormState createState() => RowCellFormState();
}

class RowCellFormState extends State<RowCellForm> {
  final List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;
  List<String> typeList = [];

  get currentValue => rows
      .where((element) =>
          element.cells['type']!.value != '' &&
          element.cells['rowNum']!.value != '' &&
          element.cells['cellNum']!.value != '')
      .map((e) =>
          '${e.cells['type']!.value}#${e.cells['rowNum']!.value}*${e.cells['cellNum']!.value}')
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
    // typeList.addAll(electrodeList);
    // typeList.addAll(steelList);
    // typeList = typeList.toSet().toList();
    typeList = mergeAndDistinct(electrodeList, steelList);
    print(typeList);
    setState(() {});
  }

  List<T> mergeAndDistinct<T>(List<T> list1, List<T> list2) {
    Set<T> set = Set<T>.from(list1)..addAll(list2);
    return List<T>.from(set);
  }

  initRows() {
    var list = widget.showValue.split('&');
    for (var element in list) {
      var type = element.split('#')[0];
      var rowCell = element.split('#')[1];
      var row = rowCell.split('*')[0];
      var cell = rowCell.split('*')[1];
      stateManager.appendRows([
        PlutoRow(cells: {
          'type': PlutoCell(value: type),
          'rowNum': PlutoCell(value: row),
          'cellNum': PlutoCell(value: cell),
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
        'type': PlutoCell(value: ''),
        'rowNum': PlutoCell(value: '1'),
        'cellNum': PlutoCell(value: '1'),
      })
    ]);
  }

  delete() {
    if (stateManager.currentRow == null) return;
    stateManager.removeRows([stateManager.currentRow!]);
    setState(() {});
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
              title: '夹具类型',
              field: 'type',
              type: PlutoColumnType.select(typeList),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '行',
              field: 'rowNum',
              type: PlutoColumnType.number(),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '列',
              field: 'cellNum',
              type: PlutoColumnType.number(),
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
