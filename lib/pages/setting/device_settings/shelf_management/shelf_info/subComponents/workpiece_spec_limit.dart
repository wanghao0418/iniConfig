import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class WorkpieceSpecLimit extends StatefulWidget {
  const WorkpieceSpecLimit({Key? key, required this.showValue})
      : super(key: key);
  final String showValue;

  @override
  WorkpieceSpecLimitState createState() => WorkpieceSpecLimitState();
}

class WorkpieceSpecLimitState extends State<WorkpieceSpecLimit> {
  final List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;

  get currentValue => rows
      .where((element) =>
          element.cells['cargoSpace']!.value != '' &&
          element.cells['length']!.value != '' &&
          element.cells['width']!.value != '' &&
          element.cells['height']!.value != '')
      .map((e) =>
          '${e.cells['cargoSpace']!.value}#${e.cells['length']!.value}*${e.cells['width']!.value}*${e.cells['height']!.value}')
      .join('-');

  initRows() {
    var list = widget.showValue.split('-');
    for (var element in list) {
      var cargoSpace = element.split('#')[0];
      var size = element.split('#')[1];
      var length = size.split('*')[0];
      var width = size.split('*')[1];
      var height = size.split('*')[2];
      stateManager.appendRows([
        PlutoRow(cells: {
          'cargoSpace': PlutoCell(value: cargoSpace),
          'length': PlutoCell(value: length),
          'width': PlutoCell(value: width),
          'height': PlutoCell(value: height)
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
        'cargoSpace': PlutoCell(value: ''),
        'length': PlutoCell(value: '0'),
        'width': PlutoCell(value: '0'),
        'height': PlutoCell(value: '0'),
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
              title: '货位',
              field: 'cargoSpace',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '长',
              field: 'length',
              type: PlutoColumnType.number(),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '宽',
              field: 'width',
              type: PlutoColumnType.number(),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '高',
              field: 'height',
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
