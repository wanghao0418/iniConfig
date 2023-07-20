/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-19 14:48:34
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 16:14:25
 * @FilePath: /iniConfig/lib/pages/setting/system_settings/behavior_setting/behavior_setting/subComponents/position_ball_setting.dart
 * @Description: 分中球位置设置
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/api/common.dart';
import 'package:iniConfig/common/style/global_theme.dart';
import 'package:iniConfig/common/utils/http.dart';
import 'package:iniConfig/common/utils/popup_message.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class PositionBallSetting extends StatefulWidget {
  const PositionBallSetting({Key? key, required this.showValue})
      : super(key: key);
  final String showValue;
  @override
  PositionBallSettingState createState() => PositionBallSettingState();
}

class PositionBallSettingState extends State<PositionBallSetting> {
  final List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;
  List machineNameList = [];
  GlobalKey formKey = GlobalKey<FormState>();
  PositionRange positionRange = PositionRange(0, 0);

  get currentValue =>
      '${positionRange.start}~${positionRange.end}#${rows.where((element) => element.cells['code']!.value != '' && element.cells['machineName']!.value != '').map((e) => '${e.cells['code']!.value}*${e.cells['machineName']!.value}').join('&')}';

  get maxNum => positionRange.end - positionRange.start + 1;

  initNum() {
    var range = widget.showValue.split('#')[0];
    var start = int.parse(range.split('~')[0]);
    var end = int.parse(range.split('~')[1]);
    positionRange = PositionRange(start, end);
    setState(() {});
  }

  initRows() {
    var list = widget.showValue.split('#')[1].split('&');
    for (var element in list) {
      var code = element.split('*')[0];
      var machineName = element.split('*')[1];

      stateManager.appendRows([
        PlutoRow(cells: {
          'code': PlutoCell(value: code),
          'machineName': PlutoCell(value: machineName),
        })
      ]);
    }
    setState(() {});
  }

  onTableCellChanged(PlutoGridOnChangedEvent event) {
    print(event);
  }

  add() {
    if (rows.length >= maxNum) return;
    stateManager.appendRows([
      PlutoRow(cells: {
        'code': PlutoCell(value: ''),
        'machineName': PlutoCell(value: ''),
      })
    ]);
  }

  delete() {
    if (stateManager.currentRow == null) return;
    stateManager.removeRows([stateManager.currentRow!]);
    setState(() {});
  }

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
        machineNameList = data.values.isEmpty ? [] : data.values.toList();
        machineNameList.insert(0, 'All');
        stateManager.columns[1].type = PlutoColumnType.select(machineNameList);
      }
    } else {
      // 查询失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNum();
    getSectionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Form(
              key: formKey,
              child: Container(
                padding: EdgeInsets.all(5),
                color: GlobalTheme.instance.isDarkMode
                    ? Colors.grey[800]
                    : Colors.grey[200],
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wrap(
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            '开始货位:',
                            style: TextStyle(
                                color: GlobalTheme.instance.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          SizedBox(
                            width: 80.0,
                            child: fluent.NumberFormBox<int>(
                              value: positionRange.start,
                              mode: fluent.SpinButtonPlacementMode.none,
                              clearButton: false,
                              onChanged: (value) {
                                positionRange.start = value ?? 0;
                                (formKey.currentState! as FormState).validate();
                              },
                              validator: (value) {
                                if (positionRange.start > positionRange.end)
                                  return '开始货位不能大于结束货位';
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                      5.horizontalSpaceRadius,
                      Text(
                        '~',
                        style: TextStyle(
                            color: GlobalTheme.instance.isDarkMode
                                ? Colors.white
                                : Colors.black),
                      ),
                      5.horizontalSpaceRadius,
                      Wrap(
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            '结束货位:',
                            style: TextStyle(
                                color: GlobalTheme.instance.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          SizedBox(
                            width: 80.0,
                            child: fluent.NumberFormBox<int>(
                              value: positionRange.end,
                              clearButton: false,
                              mode: fluent.SpinButtonPlacementMode.none,
                              onChanged: (value) {
                                positionRange.end = value ?? 0;
                                (formKey.currentState! as FormState).validate();
                              },
                            ),
                          )
                        ],
                      ),
                    ]),
              )),
          Expanded(
              child: PlutoGrid(
                  createHeader: (stateManager) {
                    return Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              fluent.FilledButton(
                                  child: Wrap(
                                      spacing: 5,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Icon(fluent.FluentIcons.add),
                                        Text('添加')
                                      ]),
                                  onPressed: add),
                              10.horizontalSpaceRadius,
                              fluent.FilledButton(
                                  child: Wrap(
                                      spacing: 5,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Icon(fluent.FluentIcons.delete),
                                        Text('删除')
                                      ]),
                                  onPressed: delete)
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  rows: rows,
                  columns: [
                    PlutoColumn(
                      title: '条码',
                      field: 'code',
                      type: PlutoColumnType.text(),
                      enableContextMenu: false,
                      enableSorting: false,
                    ),
                    PlutoColumn(
                      title: '机床名',
                      field: 'machineName',
                      type: PlutoColumnType.select(machineNameList),
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
                  )))
        ],
      ),
    );
  }
}

class PositionRange {
  int start;
  int end;
  PositionRange(this.start, this.end);
}
