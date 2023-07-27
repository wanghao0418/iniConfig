import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class SrcPrgExternSetting extends StatefulWidget {
  const SrcPrgExternSetting(
      {Key? key, required this.showValue, required this.macSectionList})
      : super(key: key);
  final String showValue;
  final List<String> macSectionList;
  @override
  SrcPrgExternSettingState createState() => SrcPrgExternSettingState();
}

class SrcPrgExternSettingState extends State<SrcPrgExternSetting> {
  final List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;
  final List allSystemList = [
    'FANUC',
    'HDH',
    'HASS',
    'JD',
    'SLCNC',
    'KND',
    'GSK',
    'OKUMA',
    'TEST',
    'HEXAGON',
    'VISUALRATE',
    'ZEISS',
    'MAKINO',
    'SODICK',
    'CLEAN',
    'DRY'
  ];
  final List systemList = [];

  get currentValue => rows
      .where((element) =>
          element.cells['systemType']!.value != '' &&
          element.cells['srcPrgExtern']!.value != '')
      .map((e) =>
          '${e.cells['systemType']!.value}-${e.cells['srcPrgExtern']!.value}')
      .join('#');

  Map getSrcPrgExternList() {
    var list = widget.showValue.split('#');
    // print(list);
    var list2 = list
        .map((e) => e.split('-'))
        .toList()
        .where((element) => element.length == 2);
    // print(list2);
    var map = Map.fromIterable(list2, key: (e) => e[0], value: (e) => e[1]);
    // print(map);
    return map;
  }

  initSystemList() {
    RegExp reg = RegExp(r'[a-zA-Z]+');
    print(widget.macSectionList);
    var macSystemList =
        widget.macSectionList.map((e) => reg.firstMatch(e)!.group(0)).toList();
    print(macSystemList);
    var list = allSystemList
        .where((element) => macSystemList.contains(element))
        .toList();
    print(list);

    setState(() {
      systemList.clear();
      systemList.addAll(list);
    });
  }

  initRows() {
    stateManager.removeAllRows();
    stateManager.appendRows(systemList
        .map((e) => PlutoRow(
              cells: {
                'systemType': PlutoCell(value: e),
                'srcPrgExtern': PlutoCell(
                    value: getSrcPrgExternList().containsKey(e)
                        ? getSrcPrgExternList()[e]
                        : ''),
              },
            ))
        .toList());
    setState(() {});
  }

  onTableCellChanged(PlutoGridOnChangedEvent event) {
    print(event);
  }

  @override
  void didUpdateWidget(covariant SrcPrgExternSetting oldWidget) {
    initSystemList();
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSystemList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlutoGrid(
          rows: rows,
          columns: [
            PlutoColumn(
              title: '系统类型',
              field: 'systemType',
              readOnly: true,
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: '机床程序在文件服务器上的拓展名',
              field: 'srcPrgExtern',
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
