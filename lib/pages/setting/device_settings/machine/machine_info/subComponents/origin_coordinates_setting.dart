/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-19 10:13:59
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 16:16:26
 * @FilePath: /iniConfig/lib/pages/setting/device_settings/machine/machine_info/widgets/origin_coordinates_setting.dart
 * @Description: 原点坐标设置
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class OriginCoordinatesSetting extends StatefulWidget {
  const OriginCoordinatesSetting({Key? key, required this.showValue})
      : super(key: key);
  final String showValue;
  @override
  OriginCoordinatesSettingState createState() =>
      OriginCoordinatesSettingState();
}

class OriginCoordinatesSettingState extends State<OriginCoordinatesSetting> {
  final List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;

  get currentValue => rows
      .where((element) =>
          element.cells['type']!.value != '' &&
          element.cells['coordinate']!.value != '')
      .map((e) => '${e.cells['type']!.value}#${e.cells['coordinate']!.value}')
      .join('&');

  initRows() {
    var list = widget.showValue.split('&');
    for (var element in list) {
      var type = element.split('#')[0];
      var coordinate = element.split('#')[1];

      stateManager.appendRows([
        PlutoRow(cells: {
          'type': PlutoCell(value: type),
          'coordinate': PlutoCell(value: coordinate),
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
        'coordinate': PlutoCell(value: ''),
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
              title: '坐标',
              field: 'coordinate',
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
