/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-19 09:38:43
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 16:16:22
 * @FilePath: /iniConfig/lib/pages/setting/device_settings/machine/machine_info/widgets/mac_process_limit.dart
 * @Description: 机床限制工艺设置
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class MacProcessLimit extends StatefulWidget {
  const MacProcessLimit({Key? key, required this.showValue}) : super(key: key);
  final String showValue;
  @override
  MacProcessLimitState createState() => MacProcessLimitState();
}

class MacProcessLimitState extends State<MacProcessLimit> {
  final List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;
  List typeList = ['CNC', 'CMM', 'EDM', 'NCMM'];

  get currentValue => rows
      .where((element) =>
          element.cells['type']!.value != '' &&
          element.cells['process']!.value != '' &&
          element.cells['comment']!.value != '')
      .map((e) =>
          '${e.cells['type']!.value}#${e.cells['process']!.value}(${e.cells['comment']!.value})')
      .join('*');

  initRows() {
    var list = widget.showValue.split('*');
    for (var element in list) {
      var type = element.split('#')[0];
      var process = element.split('#')[1];
      var comment = extractStringInParentheses(process);
      final regexp = RegExp(r'\((.*?)\)');
      process = process.replaceAll(regexp, '');
      stateManager.appendRows([
        PlutoRow(cells: {
          'type': PlutoCell(value: type),
          'process': PlutoCell(value: process),
          'comment': PlutoCell(value: comment),
        })
      ]);
    }
    setState(() {});
  }

  String? extractStringInParentheses(String input) {
    final regexp = RegExp(r'\((.*?)\)');
    final match = regexp.firstMatch(input);
    if (match != null) {
      return match.group(1);
    }
    return null;
  }

  onTableCellChanged(PlutoGridOnChangedEvent event) {
    print(event);
    var currentRow = stateManager.rows.elementAt(event.rowIdx);
    var changedKey = currentRow.cells.entries.elementAt(event.columnIdx).key;
    print(changedKey);
    if (changedKey == 'process') {
      if (event.value == '3') {
        event.row.cells['comment']!.value = '加工';
      } else if (event.value == '4') {
        event.row.cells['comment']!.value = '检测';
      } else if (event.value == '5') {
        event.row.cells['comment']!.value = '放电';
      } else {
        event.row.cells['comment']!.value = event.value;
      }
    }
  }

  add() {
    stateManager.appendRows([
      PlutoRow(cells: {
        'type': PlutoCell(value: ''),
        'process': PlutoCell(value: ''),
        'comment': PlutoCell(value: ''),
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
              title: '机床类型',
              field: 'type',
              type: PlutoColumnType.select(typeList),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '工艺',
              field: 'process',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '注释',
              field: 'comment',
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
