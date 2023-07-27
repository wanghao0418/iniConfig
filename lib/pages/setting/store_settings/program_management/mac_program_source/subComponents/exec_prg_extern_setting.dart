/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-24 09:57:11
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-24 10:14:47
 * @FilePath: /iniConfig/lib/pages/setting/store_settings/program_management/mac_program_source/subComponents/exec_prg_extern_setting.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%A
 */
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class ExecPrgExternSetting extends StatefulWidget {
  const ExecPrgExternSetting(
      {Key? key, required this.showValue, required this.macSectionList})
      : super(key: key);
  final String showValue;
  final List<String> macSectionList;
  @override
  ExecPrgExternSettingState createState() => ExecPrgExternSettingState();
}

class ExecPrgExternSettingState extends State<ExecPrgExternSetting> {
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
          element.cells['execPrgExtern']!.value != '')
      .map((e) =>
          '${e.cells['systemType']!.value}-${e.cells['execPrgExtern']!.value}')
      .join('#');

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

  Map getExecPrgExternList() {
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

  initRows() {
    stateManager.removeAllRows();
    stateManager.appendRows(systemList
        .map((e) => PlutoRow(
              cells: {
                'systemType': PlutoCell(value: e),
                'execPrgExtern': PlutoCell(
                    value: getExecPrgExternList().containsKey(e)
                        ? getExecPrgExternList()[e]
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
  void didUpdateWidget(covariant ExecPrgExternSetting oldWidget) {
    // TODO: implement didUpdateWidget
    initSystemList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    initSystemList();
    super.initState();
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
              field: 'execPrgExtern',
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
