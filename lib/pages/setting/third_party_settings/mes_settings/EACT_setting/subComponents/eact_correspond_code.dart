import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/utils/http.dart';
import 'package:iniConfig/common/utils/popup_message.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../../../../../../common/api/common.dart';
import '../controller.dart';

class EactCorrespondCode extends StatefulWidget {
  const EactCorrespondCode({Key? key, required this.showValue})
      : super(key: key);
  final String showValue;
  @override
  EactCorrespondCodeState createState() => EactCorrespondCodeState();
}

class EactCorrespondCodeState extends State<EactCorrespondCode> {
  final List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;
  List<MacCorrespond> macCorrespondList = [];

  get currentValue => rows
      .where((element) =>
          element.cells['macSection']!.value != '' &&
          element.cells['correspondMacMarkCode']!.value != '')
      .map((e) {
        var macSection = e.cells['macSection']!.value;
        var correspondMacMarkCode = e.cells['correspondMacMarkCode']!.value;
        return '$macSection&$correspondMacMarkCode';
      })
      .toList()
      .join('#');

  initTableRow() {
    for (var element in macCorrespondList) {
      stateManager.appendRows([
        PlutoRow(
          cells: {
            'macSection': PlutoCell(value: element.macSection!),
            'correspondMacMarkCode':
                PlutoCell(value: element.correspondMacMarkCode ?? ''),
            // 'correspondMacMonitorId':
            //     PlutoCell(value: element.correspondMacMonitorId ?? ''),
          },
        )
      ]);
    }
    setState(() {});
  }

  onTableCellChanged(PlutoGridOnChangedEvent event) {
    print(event);
  }

  void getSectionList() async {
    ResponseApiBody res = await CommonApi.getSectionList({
      "params": [
        {
          "list_node": "MachineInfo",
          "parent_node": "NULL",
        }
      ],
    });
    if (res.success == true) {
      // 查询成功
      var data = res.data;
      var result = (data as List).first as String;
      var sectionList = result.isEmpty ? [] : result.split('-');
      var machineNameQueryList = sectionList.map((e) => '$e/MachineName');
      ResponseApiBody res2 = await CommonApi.fieldQuery({
        "params": machineNameQueryList.toList(),
      });
      if (res2.success == true) {
        var data = res2.data as Map<String, dynamic>;
        macCorrespondList = data.values.isEmpty
            ? []
            : data.values.map((e) => MacCorrespond(macSection: e)).toList();
        // 获取已有值并赋值
        initMacCorrespondList();
      }
    } else {
      // 查询失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  initMacCorrespondList() {
    Map markCodeMap = {};
    if (widget.showValue.isNotEmpty) {
      var markCodeList = widget.showValue.split('#');
      print(markCodeList);
      for (var element in markCodeList) {
        var temp = element.split('&');
        print(temp);
        markCodeMap[temp[0]] = temp[1];

        for (var e in macCorrespondList) {
          if (e.macSection == temp[0]) {
            e.correspondMacMarkCode = temp[1];
          }
        }
      }
    }
    initTableRow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlutoGrid(
          rows: rows,
          columns: [
            PlutoColumn(
              title: '自动化机床名称',
              field: 'macSection',
              type: PlutoColumnType.text(),
              readOnly: true,
              enableContextMenu: false,
              // enableDropToResize: false,
              enableSorting: false,
            ),
            PlutoColumn(
              title: 'Eact中对应设备的唯一编号',
              field: 'correspondMacMarkCode',
              type: PlutoColumnType.text(),
              enableContextMenu: false,
              // enableDropToResize: false,
              enableSorting: false,
            ),
          ],
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            getSectionList();
          },
          onChanged: onTableCellChanged,
          configuration: const PlutoGridConfiguration(
            columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale),
          )),
    );
  }
}
