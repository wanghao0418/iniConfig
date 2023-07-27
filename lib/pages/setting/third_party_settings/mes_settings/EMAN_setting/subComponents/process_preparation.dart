/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-17 14:07:04
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 16:17:29
 * @FilePath: /iniConfig/lib/pages/setting/third_party_settings/mes_settings/EMAN_setting/widgets/process_preparation.dart
 * @Description: 工艺配制编辑组件
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class ProcessPreparation extends StatefulWidget {
  const ProcessPreparation({Key? key, required this.showValue})
      : super(key: key);
  final String showValue;

  @override
  ProcessPreparationState createState() => ProcessPreparationState();
}

class ProcessPreparationState extends State<ProcessPreparation> {
  final List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;

  get currentValue => rows
      .where((element) =>
          element.cells['process']!.value != '' &&
          element.cells['reportStatus']!.value != '')
      .map((e) =>
          '${e.cells['process']!.value}#${e.cells['reportStatus']!.value}')
      .join('*');

  initRows() {
    var list = widget.showValue.split('*');
    print(list);
    for (var element in list) {
      var process = element.split('#')[0];
      var status = element.split('#')[1];
      stateManager.appendRows([
        PlutoRow(cells: {
          'process': PlutoCell(value: process),
          'reportStatus': PlutoCell(value: status),
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
        'process': PlutoCell(value: ''),
        'reportStatus': PlutoCell(value: '1-4'),
      })
    ]);
  }

  delete() {
    if (stateManager.currentRow == null) return;
    stateManager.removeRows([stateManager.currentRow!]);
    setState(() {});
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
              title: '工艺',
              field: 'process',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '报工状态',
              field: 'reportStatus',
              type: PlutoColumnType.select(['1-4', '5']),
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
