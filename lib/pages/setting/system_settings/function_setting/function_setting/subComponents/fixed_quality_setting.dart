/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-19 11:13:53
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 16:17:11
 * @FilePath: /iniConfig/lib/pages/setting/system_settings/function_setting/function_setting/subComponents/fixed_quality_setting.dart
 * @Description: 固定质量设置
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class FixedQualitySetting extends StatefulWidget {
  const FixedQualitySetting({Key? key, required this.showValue})
      : super(key: key);
  final String showValue;
  @override
  FixedQualitySettingState createState() => FixedQualitySettingState();
}

class FixedQualitySettingState extends State<FixedQualitySetting> {
  final List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;

  get currentValue => rows
      .where((element) =>
          element.cells['type']!.value != '' &&
          element.cells['quality']!.value != '')
      .map((e) => '${e.cells['type']!.value}*${e.cells['quality']!.value}')
      .join('-');

  initRows() {
    var list = widget.showValue.split('-');
    for (var element in list) {
      var type = element.split('*')[0];
      var coordinate = element.split('*')[1];

      stateManager.appendRows([
        PlutoRow(cells: {
          'type': PlutoCell(value: type),
          'quality': PlutoCell(value: coordinate),
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
        'quality': PlutoCell(value: ''),
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
              title: '类型',
              field: 'type',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '质量',
              field: 'quality',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false,
            ),
          ],
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            initRows();
          },
          onChanged: onTableCellChanged,
          configuration: const PlutoGridConfiguration(
            columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale),
          )),
    );
  }
}
