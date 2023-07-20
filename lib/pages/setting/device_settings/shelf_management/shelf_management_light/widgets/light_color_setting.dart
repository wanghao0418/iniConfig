/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-18 15:52:21
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 16:16:51
 * @FilePath: /iniConfig/lib/pages/setting/device_settings/shelf_management/shelf_management_light/widgets/light_color_setting.dart
 * @Description: 各状态下的颜色设置
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class LightColorSetting extends StatefulWidget {
  const LightColorSetting({Key? key, required this.showValue})
      : super(key: key);
  final String showValue;
  @override
  LightColorSettingState createState() => LightColorSettingState();
}

class LightColorSettingState extends State<LightColorSetting> {
  final List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;

  get currentValue => rows
      .where((element) =>
          element.cells['status']!.value != '' &&
          element.cells['color']!.value != '')
      .map((e) => '${e.cells['status']!.value}#${e.cells['color']!.value}')
      .join('-');

  initRows() {
    var list = widget.showValue.split('-');
    for (var element in list) {
      var status = element.split('#')[0];
      var color = element.split('#')[1];
      stateManager.appendRows([
        PlutoRow(cells: {
          'status': PlutoCell(value: status),
          'color': PlutoCell(value: color),
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
        'status': PlutoCell(value: ''),
        'color': PlutoCell(value: ''),
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
              title: '状态',
              field: 'status',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '颜色',
              field: 'color',
              type: PlutoColumnType.text(),
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
