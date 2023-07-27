import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/api/common.dart';
import 'package:iniConfig/common/utils/http.dart';
import 'package:iniConfig/common/utils/popup_message.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../controller.dart';

class EmanCorrespondSource extends StatefulWidget {
  const EmanCorrespondSource({Key? key, required this.showValue})
      : super(key: key);
  final String showValue;
  @override
  EmanCorrespondSourceState createState() => EmanCorrespondSourceState();
}

class EmanCorrespondSourceState extends State<EmanCorrespondSource> {
  final List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;
  List<MacCorrespond> macCorrespondList = [];

  get currentValue => rows
      .where((element) =>
          element.cells['macSection']!.value != '' &&
          element.cells['correspondMacMonitorId']!.value != '')
      .map((e) {
        var macSection = e.cells['macSection']!.value;
        var correspondMacMonitorId = e.cells['correspondMacMonitorId']!.value;
        return '$macSection&$correspondMacMonitorId';
      })
      .toList()
      .join('#');

  // 获取线内机床列表
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

  onTableCellChanged(PlutoGridOnChangedEvent event) {
    print(event);
  }

  initMacCorrespondList() {
    // Map nameMap = {};
    // if (widget.showValue.isNotEmpty) {
    //   var nameList = widget.showValue.split('#');
    //   print(nameList);
    //   for (var element in nameList) {
    //     var temp = element.split('&');
    //     print(temp);
    //     nameMap[temp[0]] = temp[1];

    //     for (var e in macCorrespondList) {
    //       if (e.macSection == temp[0]) {
    //         e.correspondMacName = temp[1];
    //       }
    //     }
    //   }
    // }

    Map idMap = {};
    if (widget.showValue.isNotEmpty) {
      var idList = widget.showValue.split('#');
      print(idList);
      for (var element in idList) {
        var temp = element.split('&');
        print(temp);
        idMap[temp[0]] = temp[1];

        for (var e in macCorrespondList) {
          if (e.macSection == temp[0]) {
            e.correspondMacMonitorId = temp[1];
          }
        }
      }
    }
    // print(nameMap);
    print(idMap);
    initTableRow();
  }

  initTableRow() {
    for (var element in macCorrespondList) {
      stateManager.appendRows([
        PlutoRow(
          cells: {
            'macSection': PlutoCell(value: element.macSection!),
            // 'correspondMacName':
            //     PlutoCell(value: element.correspondMacName ?? ''),
            'correspondMacMonitorId':
                PlutoCell(value: element.correspondMacMonitorId ?? ''),
          },
        )
      ]);
    }

    setState(() {});
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
              enableSorting: false,
            ),
            // PlutoColumn(
            //   title: '对应机床名称',
            //   field: 'correspondMacName',
            //   type: PlutoColumnType.text(),
            //   sort: PlutoColumnSort.none,
            //   enableContextMenu: false,
            //   enableSorting: false,
            // ),
            PlutoColumn(
              title: 'eman对应的资源ID',
              field: 'correspondMacMonitorId',
              type: PlutoColumnType.text(),
              sort: PlutoColumnSort.none,
              enableContextMenu: false,
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
