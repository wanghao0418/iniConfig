import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class ReworkMarkSetting extends StatefulWidget {
  const ReworkMarkSetting({Key? key, required this.showValue})
      : super(key: key);
  final String showValue;
  @override
  ReworkMarkSettingState createState() => ReworkMarkSettingState();
}

class ReworkMarkSettingState extends State<ReworkMarkSetting> {
  final List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;

  get currentValue => rows
      .where((element) =>
          element.cells['process']!.value != '' &&
          element.cells['select']!.value != '')
      .map((e) =>
          '${e.cells['process']!.value}#${e.cells['select']!.value == '选择' ? '1' : '0'}')
      .join('-');

  initRows() {
    var list = widget.showValue.split('-');
    for (var element in list) {
      var process = element.split('#')[0];
      var select = element.split('#')[1] == '1' ? '选择' : '不选择';

      stateManager.appendRows([
        PlutoRow(cells: {
          'process': PlutoCell(value: process),
          'select': PlutoCell(value: select),
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
        'select': PlutoCell(value: ''),
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
              title: '工艺',
              field: 'process',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '是否选择程序',
              field: 'select',
              type: PlutoColumnType.select(['选择', '不选择']),
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
