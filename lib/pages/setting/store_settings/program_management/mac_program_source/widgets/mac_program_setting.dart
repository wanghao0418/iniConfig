/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 10:09:31
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-24 10:08:57
 * @FilePath: /eatm_ini_config/lib/pages/setting/store_settings/program_management/mac_program_source/widgets/mac_program_setting.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/components/field_subTitle.dart';
import 'package:iniConfig/common/style/global_theme.dart';
import 'package:iniConfig/pages/setting/store_settings/program_management/mac_program_source/subComponents/exec_prg_extern_setting.dart';
import 'package:iniConfig/pages/setting/store_settings/program_management/mac_program_source/subComponents/src_prg_extern_setting.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../../../common/api/common.dart';
import '../../../../../../common/components/field_change.dart';
import '../../../../../../common/components/field_group.dart';
import '../../../../../../common/utils/http.dart';
import '../../../../../../common/utils/popup_message.dart';

class MacProgramSetting extends StatefulWidget {
  const MacProgramSetting(
      {Key? key, required this.section, required this.macSectionList})
      : super(key: key);
  final String section;
  final List<String> macSectionList;

  @override
  _MacProgramSettingState createState() => _MacProgramSettingState();
}

class _MacProgramSettingState extends State<MacProgramSetting> {
  late PrgServerInfo prgServerInfo;
  //
  List<RenderField> menuList = [
    RenderFieldInfo(
        field: 'FileServerType',
        section: 'PrgServerInfo',
        name: "程序文件位置设置",
        renderType: RenderType.radio,
        options: {"ftp": "1", "共享目录或本地": "2"}),
    RenderFieldInfo(
      field: 'ServiceIP',
      section: 'PrgServerInfo',
      name: "ftp或共享文件夹的IP",
      renderType: RenderType.input,
    ),
    // RenderCustomByTag(tag: 'SrcPrgExternTable'),
    // RenderCustomByTag(tag: 'ExecPrgExternTable'),
    RenderFieldInfo(
      field: 'SrcPrgExtern',
      section: 'PrgServerInfo',
      name: "各系统类型对应的服务器上的源程式后缀",
      renderType: RenderType.custom,
    ),
    RenderFieldInfo(
      field: 'ExecPrgExtern',
      section: 'PrgServerInfo',
      name: "各系统类型对应的服务器上的执行程式后缀",
      renderType: RenderType.custom,
    ),
    RenderFieldGroup(groupName: "FTP登陆设置", children: [
      RenderFieldInfo(
        field: 'Port',
        section: 'PrgServerInfo',
        name: "FTP端口",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'User',
        section: 'PrgServerInfo',
        name: "FTP用户",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'Pwd',
        section: 'PrgServerInfo',
        name: "FTP密码",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'Code',
        section: 'PrgServerInfo',
        name: "FTP采用编码（目前没有用到）",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldSubTitle(title: "检测"),
    RenderFieldGroup(groupName: "源程序路径", children: [
      RenderFieldInfo(
        field: 'CmmElecPointPath',
        section: 'PrgServerInfo',
        name: "电极检测取点文件路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'CmmStPointPath',
        section: 'PrgServerInfo',
        name: "钢件检测取点文件路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'SrcCmmElecPonitFileName',
        section: 'PrgServerInfo',
        name: "电极源取点文件的命名规则，PartFileName或者ELECSN",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'SrcCmmStPonitFileName',
        section: 'PrgServerInfo',
        name: "钢件源取点文件的命名规则，PartFileName或者ELECSN",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'CmmElecPointFileExtern',
        section: 'PrgServerInfo',
        name: "电极检测取点文件后缀",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'CmmStPointFileExtern',
        section: 'PrgServerInfo',
        name: "钢件检测取点文件后缀",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'CmmElecSrcPrgPath',
        section: 'PrgServerInfo',
        name: "电极检测原始程序路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'CmmStSrcPrgPath',
        section: 'PrgServerInfo',
        name: "钢件检测原始程序路径",
        renderType: RenderType.path,
      ),
    ]),
    RenderFieldGroup(groupName: "执行程序", children: [
      RenderFieldInfo(
        field: 'CmmElecExecPrgPath',
        section: 'PrgServerInfo',
        name: "电极检测执行程式路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'CmmStExecPrgPath',
        section: 'PrgServerInfo',
        name: "钢件检测执行程式路径",
        renderType: RenderType.path,
      ),
    ]),
    RenderFieldGroup(groupName: "蔡司专属", children: [
      RenderFieldInfo(
        field: 'CmmZiessTcpCopySrcPath',
        section: 'PrgServerInfo',
        name: "拷贝的源程序路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'CmmZiessTcpCopyDesPath',
        section: 'PrgServerInfo',
        name: "拷贝的目标路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'CmmElecReportSavePath',
        section: 'PrgServerInfo',
        name: "电极结果文件拷贝至eact服务器判断是否合格(目前蔡司专用)",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'CmmStReportSavePath',
        section: 'PrgServerInfo',
        name: "钢件结果文件拷贝至eact服务器判断是否合格(目前蔡司专用)",
        renderType: RenderType.path,
      ),
    ]),
    RenderFieldSubTitle(title: "加工"),
    RenderFieldGroup(groupName: "源程序名称", children: [
      RenderFieldInfo(
        field: 'SrcCncElecPrgName',
        section: 'PrgServerInfo',
        name: "电极源加工程序名命名规则",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'SrcCncStPrgName',
        section: 'PrgServerInfo',
        name: "钢件源铣工程序名命名规则",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'SrcLcncStPrgName',
        section: 'PrgServerInfo',
        name: "钢件源车工程序名命名规则",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldGroup(groupName: "执行程序名称", children: [
      RenderFieldInfo(
        field: 'ExecCncElecPrgName',
        section: 'PrgServerInfo',
        name: "电极加工执行程序名命名规则",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ExecCncStPrgName',
        section: 'PrgServerInfo',
        name: "钢件铣工执行程序名命名规则",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ExecLcncStPrgName',
        section: 'PrgServerInfo',
        name: "钢件车工执行程序名命名规则",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldGroup(groupName: "源程序路径", children: [
      RenderFieldInfo(
        field: 'CncElecSrcPrgPath',
        section: 'PrgServerInfo',
        name: "电极加工原始程序路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'McncStSrcPrgPath',
        section: 'PrgServerInfo',
        name: "钢件加工原始程序路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'LcncStSrcPrgPath',
        section: 'PrgServerInfo',
        name: "钢件车工原始程序路径",
        renderType: RenderType.path,
      ),
      // RenderFieldInfo(
      //   field: 'SrcEdmElecPrgName',
      //   section: 'PrgServerInfo',
      //   name: "电极源放电程序名命名规则",
      //   renderType: RenderType.input,
      // ),
    ]),
    RenderFieldGroup(groupName: "执行程序路径", children: [
      RenderFieldInfo(
        field: 'CncElecExecPrgPath',
        section: 'PrgServerInfo',
        name: "电极加工执行程式文件路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'CncStExecPrgPath',
        section: 'PrgServerInfo',
        name: "钢件加工执行程式文件路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'LcncStExecPrgPath',
        section: 'PrgServerInfo',
        name: "钢件车工执行程式文件路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'MacCheckResultFileName',
        section: 'PrgServerInfo',
        name: "在机检测结果程序拷贝到目标路径的命名",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'CopyMacCheckResultFilePath',
        section: 'PrgServerInfo',
        name: "拷贝在机检测结果文件所到的路径",
        renderType: RenderType.path,
      ),
    ]),
    RenderFieldSubTitle(title: "放电"),
    RenderFieldInfo(
      field: 'EdmElecPrgName',
      section: 'PrgServerInfo',
      name: "电极源放电程序名命名规则",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'ExecEdmElecPrgName',
      section: 'PrgServerInfo',
      name: "电极放电执行程序名命名规则",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'EdmElecSrcPrgPath',
      section: 'PrgServerInfo',
      name: "电极放电原始程序路径",
      renderType: RenderType.path,
    ),
    RenderFieldInfo(
      field: 'EdmPrgPath',
      section: 'PrgServerInfo',
      name: "电极放电执行程式文件路径",
      renderType: RenderType.path,
    ),
  ];
  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = prgServerInfo.toSectionMap();
    temp[field] = val;
    prgServerInfo = PrgServerInfo.fromSectionJson(temp, widget.section);
  }

  String? getFieldValue(String field) {
    return prgServerInfo.toSectionMap()[field];
  }

  void onFieldChange(String field, String value) {
    if (value == getFieldValue(field)) {
      return;
    }
    if (!changedList.contains(field)) {
      changedList.add(field);
    }
    setFieldValue(field, value);
    setState(() {});
  }

  initMenu() {
    for (var element in menuList) {
      if (element is RenderFieldInfo) {
        element.section = widget.section;
        if (element.field == 'SrcPrgExtern') {
          element.builder = (context) => _buildSrcPrgExtern(context, element);
        } else if (element.field == 'ExecPrgExtern') {
          element.builder = (context) => _buildExecPrgExtern(context, element);
        }
      } else if (element is RenderFieldGroup) {
        for (var element in element.children) {
          if (element is RenderFieldInfo) {
            element.section = widget.section;
          }
        }
      }
    }
    setState(() {});
  }

  getSectionDetail() async {
    ResponseApiBody res = await CommonApi.getSectionDetail({
      "params": [widget.section]
    });
    if (res.success == true) {
      prgServerInfo = PrgServerInfo.fromSectionJson(
          (res.data as List).first, widget.section);
      setState(() {});
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
    // initRows();
    // initRows2();
  }

  save() async {
    if (changedList.isEmpty) {
      return;
    }
    var dataList = _makeParams();
    ResponseApiBody res = await CommonApi.fieldUpdate({"params": dataList});
    if (res.success == true) {
      PopupMessage.showSuccessInfoBar('保存成功');
      changedList = [];
      setState(() {});
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  test() {
    PopupMessage.showWarningInfoBar('暂未开放');
  }

  _makeParams() {
    List<Map<String, dynamic>> params = [];
    for (var element in changedList) {
      params.add({"key": element, "value": getFieldValue(element)});
    }
    return params;
  }

  // 源程式后缀编辑
  Widget _buildSrcPrgExtern(BuildContext context, RenderFieldInfo info) {
    var _key = GlobalKey();
    return FilledButton(
        child: const Text('编辑'),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  constraints: BoxConstraints(maxWidth: 800, maxHeight: 500),
                  title: Text('${info.name}').fontSize(20.sp),
                  content: SrcPrgExternSetting(
                    key: _key,
                    showValue: getFieldValue(info.fieldKey) ?? '',
                    macSectionList: widget.macSectionList,
                  ),
                  actions: [
                    Button(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消')),
                    FilledButton(
                        onPressed: () {
                          var value =
                              (_key.currentState as SrcPrgExternSettingState)
                                  .currentValue;
                          onFieldChange(info.fieldKey, value);
                          Navigator.of(context).pop();
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  // 执行程式后缀编辑
  Widget _buildExecPrgExtern(BuildContext context, RenderFieldInfo info) {
    var _key = GlobalKey();
    return FilledButton(
        child: const Text('编辑'),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  constraints: BoxConstraints(maxWidth: 800, maxHeight: 500),
                  title: Text('${info.name}').fontSize(20.sp),
                  content: ExecPrgExternSetting(
                    key: _key,
                    showValue: getFieldValue(info.fieldKey) ?? '',
                    macSectionList: widget.macSectionList,
                  ),
                  actions: [
                    Button(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消')),
                    FilledButton(
                        onPressed: () {
                          var value =
                              (_key.currentState as ExecPrgExternSettingState)
                                  .currentValue;
                          onFieldChange(info.fieldKey, value);
                          Navigator.of(context).pop();
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  // String? get currentSrcPrgExtern =>
  //     getFieldValue('${widget.section}/SrcPrgExtern');

  // Map getSrcPrgExternList() {
  //   if (currentSrcPrgExtern != null) {
  //     var list = currentSrcPrgExtern!.split('#');
  //     // print(list);
  //     var list2 = list
  //         .map((e) => e.split('-'))
  //         .toList()
  //         .where((element) => element.length == 2);
  //     // print(list2);
  //     var map = Map.fromIterable(list2, key: (e) => e[0], value: (e) => e[1]);
  //     // print(map);
  //     return map;
  //   } else {
  //     return {};
  //   }
  // }

  // String? get currentExecPrgExtern =>
  //     getFieldValue('${widget.section}/ExecPrgExtern');

  // Map getExecPrgExternList() {
  //   if (currentExecPrgExtern != null) {
  //     var list = currentExecPrgExtern!.split('#');
  //     // print(list);
  //     var list2 = list
  //         .map((e) => e.split('-'))
  //         .toList()
  //         .where((element) => element.length == 2);
  //     // print(list2);
  //     var map = Map.fromIterable(list2, key: (e) => e[0], value: (e) => e[1]);
  //     // print(map);
  //     return map;
  //   } else {
  //     return {};
  //   }
  // }

  // final List allSystemList = [
  //   'FANUC',
  //   'HDH',
  //   'HASS',
  //   'JD',
  //   'SLCNC',
  //   'KND',
  //   'GSK',
  //   'OKUMA',
  //   'TEST',
  //   'HEXAGON',
  //   'VISUALRATE',
  //   'ZEISS',
  //   'MAKINO',
  //   'SODICK',
  //   'CLEAN',
  //   'DRY'
  // ];

  // final List systemList = [];

  // late final PlutoGridStateManager stateManager;
  // late final PlutoGridStateManager stateManager2;
  // List<PlutoRow> rows = [];
  // List<PlutoRow> rows2 = [];

  // initSystemList() {
  //   RegExp reg = RegExp(r'[a-zA-Z]+');
  //   print(widget.macSectionList);
  //   var macSystemList =
  //       widget.macSectionList.map((e) => reg.firstMatch(e)!.group(0)).toList();
  //   print(macSystemList);
  //   var list = allSystemList
  //       .where((element) => macSystemList.contains(element))
  //       .toList();
  //   print(list);

  //   setState(() {
  //     systemList.clear();
  //     systemList.addAll(list);
  //   });
  // }

  // initRows() {
  //   stateManager.removeAllRows();
  //   stateManager.appendRows(systemList
  //       .map((e) => PlutoRow(
  //             cells: {
  //               'systemType': PlutoCell(value: e),
  //               'srcPrgExtern': PlutoCell(
  //                   value: getSrcPrgExternList().containsKey(e)
  //                       ? getSrcPrgExternList()[e]
  //                       : ''),
  //             },
  //           ))
  //       .toList());
  //   setState(() {});
  // }

  // onTableCellChanged(PlutoGridOnChangedEvent event) {
  //   var srcPrgExtern = '';
  //   stateManager.rows.forEach((element) {
  //     var index = stateManager.rows.indexOf(element);
  //     var system = element.cells.values.elementAt(0).value;
  //     var val = element.cells.values.elementAt(1).value;
  //     if (val == null || val == '') {
  //       return;
  //     }
  //     srcPrgExtern += index == 0 ? '$system-$val' : '#$system-$val';
  //   });
  //   print(srcPrgExtern);
  //   if (srcPrgExtern == currentSrcPrgExtern) {
  //     return;
  //   }
  //   setFieldValue('${widget.section}/SrcPrgExtern', srcPrgExtern);
  //   if (!changedList.contains('${widget.section}/SrcPrgExtern')) {
  //     changedList.add('${widget.section}/SrcPrgExtern');
  //   }
  //   // onFieldChange('${widget.section}/SrcPrgExtern', srcPrgExtern);
  // }

  // // 各系统类型源程式后缀表格
  // Widget _buildSrcPrgExternTable() {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 5.r),
  //     height: 300,
  //     child: Card(
  //         child: PlutoGrid(
  //       createHeader: (stateManager) {
  //         return Container(
  //           width: double.infinity,
  //           padding: EdgeInsets.only(bottom: 5),
  //           child: Text(
  //             '源程式后缀',
  //             style: FluentTheme.of(context).typography.bodyStrong,
  //             textAlign: TextAlign.center,
  //           ).fontSize(16),
  //         );
  //       },
  //       columns: [
  //         PlutoColumn(
  //             title: '系统类型',
  //             field: 'systemType',
  //             type: PlutoColumnType.text(),
  //             enableContextMenu: false,
  //             enableSorting: false,
  //             readOnly: true),
  //         PlutoColumn(
  //           title: '机床程序在文件服务器上的拓展名',
  //           field: 'srcPrgExtern',
  //           type: PlutoColumnType.text(),
  //           enableContextMenu: false,
  //           enableSorting: false,
  //         ),
  //       ],
  //       rows: rows,
  //       onLoaded: (PlutoGridOnLoadedEvent event) {
  //         stateManager = event.stateManager;
  //         initRows();
  //       },
  //       onChanged: onTableCellChanged,
  //       configuration: PlutoGridConfiguration(
  //         style: PlutoGridStyleConfig(
  //           gridBorderColor: Colors.grey[30],
  //           gridBackgroundColor: FluentTheme.of(context).cardColor,
  //           iconColor: GlobalTheme.instance.buttonIconColor,
  //           rowColor: FluentTheme.of(context).cardColor,
  //           cellTextStyle: FluentTheme.of(context).typography.body!,
  //           columnTextStyle: FluentTheme.of(context).typography.bodyLarge!,
  //           activatedColor: FluentTheme.of(context).accentColor,
  //         ),
  //         localeText: const PlutoGridLocaleText.china(),
  //         columnSize: const PlutoGridColumnSizeConfig(
  //             autoSizeMode: PlutoAutoSizeMode.equal),
  //       ),
  //     )),
  //   );
  // }

  // initRows2() {
  //   stateManager2.removeAllRows();
  //   stateManager2.appendRows(systemList
  //       .map((e) => PlutoRow(
  //             cells: {
  //               'systemType': PlutoCell(value: e),
  //               'execPrgExtern': PlutoCell(
  //                   value: getExecPrgExternList().containsKey(e)
  //                       ? getExecPrgExternList()[e]
  //                       : ''),
  //             },
  //           ))
  //       .toList());
  //   setState(() {});
  // }

  // onTableCellChanged2(PlutoGridOnChangedEvent event) {
  //   var exePrgExtern = '';
  //   stateManager2.rows.forEach((element) {
  //     var index = stateManager2.rows.indexOf(element);
  //     var system = element.cells.values.elementAt(0).value;
  //     var val = element.cells.values.elementAt(1).value;
  //     if (val == null || val == '') {
  //       return;
  //     }
  //     exePrgExtern += index == 0 ? '$system-$val' : '#$system-$val';
  //   });
  //   print(exePrgExtern);
  //   if (exePrgExtern == currentExecPrgExtern) {
  //     return;
  //   }
  //   setFieldValue('${widget.section}/ExecPrgExtern', exePrgExtern);
  //   if (!changedList.contains('${widget.section}/ExecPrgExtern')) {
  //     changedList.add('${widget.section}/ExecPrgExtern');
  //   }
  // }

  // // 各系统类型执行程式后缀
  // Widget _buildExePrgExtern() {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 5.r),
  //     height: 250,
  //     child: Card(
  //         child: PlutoGrid(
  //       createHeader: (stateManager) {
  //         return Container(
  //           width: double.infinity,
  //           padding: EdgeInsets.only(bottom: 5),
  //           child: Text(
  //             '执行程式后缀',
  //             style: FluentTheme.of(context).typography.bodyStrong,
  //             textAlign: TextAlign.center,
  //           ).fontSize(16),
  //         );
  //       },
  //       columns: [
  //         PlutoColumn(
  //             title: '系统类型',
  //             field: 'systemType',
  //             type: PlutoColumnType.text(),
  //             enableContextMenu: false,
  //             enableSorting: false,
  //             readOnly: true),
  //         PlutoColumn(
  //           title: '机床程序在文件服务器上的拓展名',
  //           field: 'execPrgExtern',
  //           type: PlutoColumnType.text(),
  //           enableContextMenu: false,
  //           enableSorting: false,
  //         ),
  //       ],
  //       rows: rows2,
  //       onLoaded: (PlutoGridOnLoadedEvent event) {
  //         stateManager2 = event.stateManager;
  //         initRows2();
  //       },
  //       onChanged: onTableCellChanged2,
  //       configuration: PlutoGridConfiguration(
  //         style: PlutoGridStyleConfig(
  //           gridBorderColor: Colors.grey[30],
  //           gridBackgroundColor: FluentTheme.of(context).cardColor,
  //           iconColor: GlobalTheme.instance.buttonIconColor,
  //           rowColor: FluentTheme.of(context).cardColor,
  //           cellTextStyle: FluentTheme.of(context).typography.body!,
  //           columnTextStyle: FluentTheme.of(context).typography.bodyLarge!,
  //           activatedColor: FluentTheme.of(context).accentColor,
  //         ),
  //         localeText: const PlutoGridLocaleText.china(),
  //         columnSize: const PlutoGridColumnSizeConfig(
  //             autoSizeMode: PlutoAutoSizeMode.equal),
  //       ),
  //     )),
  //   );
  // }

  // @override
  // void didUpdateWidget(covariant MacProgramSetting oldWidget) {
  //   print('参数变化');
  //   initSystemList();
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prgServerInfo = PrgServerInfo(section: widget.section);
    initMenu();
    getSectionDetail();
    // initSystemList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          CommandBarCard(
              child: CommandBar(primaryItems: [
            CommandBarButton(
                label: Text('保存'),
                onPressed: save,
                icon: Icon(
                  FluentIcons.save,
                  color: GlobalTheme.instance.buttonIconColor,
                )),
            CommandBarSeparator(
              color: GlobalTheme.instance.buttonIconColor,
            ),
            CommandBarButton(
                label: Text('测试'),
                onPressed: test,
                icon: Icon(
                  FluentIcons.test_plan,
                  color: GlobalTheme.instance.buttonIconColor,
                )),
          ])),
          5.verticalSpacingRadius,
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              ...menuList.map((e) {
                if (e is RenderFieldGroup) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 5.r),
                    child: FieldGroup(
                      groupName: e.groupName,
                      getValue: getFieldValue,
                      children: e.children,
                      isChanged: isChanged,
                      onChanged: (field, value) {
                        onFieldChange(field, value);
                      },
                    ),
                  );
                } else if (e is RenderFieldSubTitle) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 5.r),
                    child: FieldSubTitle(
                      title: e.title,
                    ),
                  );
                }
                // else if (e is RenderCustomByTag) {
                //   if (e.tag == 'SrcPrgExternTable') {
                //     return _buildSrcPrgExternTable();
                //   } else if (e.tag == 'ExecPrgExternTable') {
                //     return _buildExePrgExtern();
                //   } else {
                //     return Container();
                //   }
                // }
                else {
                  return FieldChange(
                    renderFieldInfo: e as RenderFieldInfo,
                    showValue: getFieldValue(e.fieldKey),
                    isChanged: isChanged(e.fieldKey),
                    builder: e.builder,
                    onChanged: (field, value) {
                      onFieldChange(field, value);
                    },
                  );
                }
              }).toList()
            ],
          )))
        ],
      ),
    );
  }
}

class PrgServerInfo {
  final String section;
  String? fileServerType;
  String? serviceIP;
  String? port;
  String? user;
  String? pwd;
  String? code;
  String? srcCmmElecPonitFileName;
  String? srcCmmStPonitFileName;
  String? srcCncElecPrgName;
  String? srcCncStPrgName;
  String? srcLcncStPrgName;
  String? srcEdmElecPrgName;
  String? execCncElecPrgName;
  String? execCncStPrgName;
  String? execLcncStPrgName;
  String? execEdmElecPrgName;
  String? cmmElecPointFileExtern;
  String? cmmStPointFileExtern;
  String? srcPrgExtern;
  String? execPrgExtern;
  String? cmmElecPointPath;
  String? cmmStPointPath;
  String? cncElecSrcPrgPath;
  String? mcncStSrcPrgPath;
  String? lcncStSrcPrgPath;
  String? cmmElecSrcPrgPath;
  String? cmmStSrcPrgPath;
  String? edmElecSrcPrgPath;
  String? cncElecExecPrgPath;
  String? cncStExecPrgPath;
  String? lcncStExecPrgPath;
  String? cmmElecExecPrgPath;
  String? cmmStExecPrgPath;
  String? edmPrgPath;
  String? cmmElecReportSavePath;
  String? cmmStReportSavePath;
  String? macCheckResultFileName;
  String? copyMacCheckResultFilePath;
  String? cmmZiessTcpCopySrcPath;
  String? cmmZiessTcpCopyDesPath;
  String? edmElecPrgName;

  PrgServerInfo(
      {required this.section,
      this.fileServerType,
      this.serviceIP,
      this.port,
      this.user,
      this.pwd,
      this.code,
      this.srcCmmElecPonitFileName,
      this.srcCmmStPonitFileName,
      this.srcCncElecPrgName,
      this.srcCncStPrgName,
      this.srcLcncStPrgName,
      this.srcEdmElecPrgName,
      this.execCncElecPrgName,
      this.execCncStPrgName,
      this.execLcncStPrgName,
      this.execEdmElecPrgName,
      this.cmmElecPointFileExtern,
      this.cmmStPointFileExtern,
      this.srcPrgExtern,
      this.execPrgExtern,
      this.cmmElecPointPath,
      this.cmmStPointPath,
      this.cncElecSrcPrgPath,
      this.mcncStSrcPrgPath,
      this.lcncStSrcPrgPath,
      this.cmmElecSrcPrgPath,
      this.cmmStSrcPrgPath,
      this.edmElecSrcPrgPath,
      this.cncElecExecPrgPath,
      this.cncStExecPrgPath,
      this.lcncStExecPrgPath,
      this.cmmElecExecPrgPath,
      this.cmmStExecPrgPath,
      this.edmPrgPath,
      this.cmmElecReportSavePath,
      this.cmmStReportSavePath,
      this.macCheckResultFileName,
      this.copyMacCheckResultFilePath,
      this.cmmZiessTcpCopySrcPath,
      this.cmmZiessTcpCopyDesPath,
      this.edmElecPrgName});

  PrgServerInfo.fromJson(Map<String, dynamic> json, this.section) {
    fileServerType = json['FileServerType'];
    serviceIP = json['ServiceIP'];
    port = json['Port'];
    user = json['User'];
    pwd = json['Pwd'];
    code = json['Code'];
    srcCmmElecPonitFileName = json['SrcCmmElecPonitFileName'];
    srcCmmStPonitFileName = json['SrcCmmStPonitFileName'];
    srcCncElecPrgName = json['SrcCncElecPrgName'];
    srcCncStPrgName = json['SrcCncStPrgName'];
    srcLcncStPrgName = json['SrcLcncStPrgName'];
    srcEdmElecPrgName = json['SrcEdmElecPrgName'];
    execCncElecPrgName = json['ExecCncElecPrgName'];
    execCncStPrgName = json['ExecCncStPrgName'];
    execLcncStPrgName = json['ExecLcncStPrgName'];
    execEdmElecPrgName = json['ExecEdmElecPrgName'];
    cmmElecPointFileExtern = json['CmmElecPointFileExtern'];
    cmmStPointFileExtern = json['CmmStPointFileExtern'];
    srcPrgExtern = json['SrcPrgExtern'];
    execPrgExtern = json['ExecPrgExtern'];
    cmmElecPointPath = json['CmmElecPointPath'];
    cmmStPointPath = json['CmmStPointPath'];
    cncElecSrcPrgPath = json['CncElecSrcPrgPath'];
    mcncStSrcPrgPath = json['McncStSrcPrgPath'];
    lcncStSrcPrgPath = json['LcncStSrcPrgPath'];
    cmmElecSrcPrgPath = json['CmmElecSrcPrgPath'];
    cmmStSrcPrgPath = json['CmmStSrcPrgPath'];
    edmElecSrcPrgPath = json['EdmElecSrcPrgPath'];
    cncElecExecPrgPath = json['CncElecExecPrgPath'];
    cncStExecPrgPath = json['CncStExecPrgPath'];
    lcncStExecPrgPath = json['LcncStExecPrgPath'];
    cmmElecExecPrgPath = json['CmmElecExecPrgPath'];
    cmmStExecPrgPath = json['CmmStExecPrgPath'];
    edmPrgPath = json['EdmPrgPath'];
    cmmElecReportSavePath = json['CmmElecReportSavePath'];
    cmmStReportSavePath = json['CmmStReportSavePath'];
    macCheckResultFileName = json['MacCheckResultFileName'];
    copyMacCheckResultFilePath = json['CopyMacCheckResultFilePath'];
    cmmZiessTcpCopySrcPath = json['CmmZiessTcpCopySrcPath'];
    cmmZiessTcpCopyDesPath = json['CmmZiessTcpCopyDesPath'];
    edmElecPrgName = json['EdmElecPrgName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FileServerType'] = this.fileServerType;
    data['ServiceIP'] = this.serviceIP;
    data['Port'] = this.port;
    data['User'] = this.user;
    data['Pwd'] = this.pwd;
    data['Code'] = this.code;
    data['SrcCmmElecPonitFileName'] = this.srcCmmElecPonitFileName;
    data['SrcCmmStPonitFileName'] = this.srcCmmStPonitFileName;
    data['SrcCncElecPrgName'] = this.srcCncElecPrgName;
    data['SrcCncStPrgName'] = this.srcCncStPrgName;
    data['SrcLcncStPrgName'] = this.srcLcncStPrgName;
    data['SrcEdmElecPrgName'] = this.srcEdmElecPrgName;
    data['ExecCncElecPrgName'] = this.execCncElecPrgName;
    data['ExecCncStPrgName'] = this.execCncStPrgName;
    data['ExecLcncStPrgName'] = this.execLcncStPrgName;
    data['ExecEdmElecPrgName'] = this.execEdmElecPrgName;
    data['CmmElecPointFileExtern'] = this.cmmElecPointFileExtern;
    data['CmmStPointFileExtern'] = this.cmmStPointFileExtern;
    data['SrcPrgExtern'] = this.srcPrgExtern;
    data['ExecPrgExtern'] = this.execPrgExtern;
    data['CmmElecPointPath'] = this.cmmElecPointPath;
    data['CmmStPointPath'] = this.cmmStPointPath;
    data['CncElecSrcPrgPath'] = this.cncElecSrcPrgPath;
    data['McncStSrcPrgPath'] = this.mcncStSrcPrgPath;
    data['LcncStSrcPrgPath'] = this.lcncStSrcPrgPath;
    data['CmmElecSrcPrgPath'] = this.cmmElecSrcPrgPath;
    data['CmmStSrcPrgPath'] = this.cmmStSrcPrgPath;
    data['EdmElecSrcPrgPath'] = this.edmElecSrcPrgPath;
    data['CncElecExecPrgPath'] = this.cncElecExecPrgPath;
    data['CncStExecPrgPath'] = this.cncStExecPrgPath;
    data['LcncStExecPrgPath'] = this.lcncStExecPrgPath;
    data['CmmElecExecPrgPath'] = this.cmmElecExecPrgPath;
    data['CmmStExecPrgPath'] = this.cmmStExecPrgPath;
    data['EdmPrgPath'] = this.edmPrgPath;
    data['CmmElecReportSavePath'] = this.cmmElecReportSavePath;
    data['CmmStReportSavePath'] = this.cmmStReportSavePath;
    data['MacCheckResultFileName'] = this.macCheckResultFileName;
    data['CopyMacCheckResultFilePath'] = this.copyMacCheckResultFilePath;
    data['CmmZiessTcpCopySrcPath'] = this.cmmZiessTcpCopySrcPath;
    data['CmmZiessTcpCopyDesPath'] = this.cmmZiessTcpCopyDesPath;
    data['EdmElecPrgName'] = this.edmElecPrgName;
    return data;
  }

  PrgServerInfo.fromSectionJson(Map<String, dynamic> json, this.section) {
    fileServerType = json['$section/FileServerType'];
    serviceIP = json['$section/ServiceIP'];
    port = json['$section/Port'];
    user = json['$section/User'];
    pwd = json['$section/Pwd'];
    code = json['$section/Code'];
    srcCmmElecPonitFileName = json['$section/SrcCmmElecPonitFileName'];
    srcCmmStPonitFileName = json['$section/SrcCmmStPonitFileName'];
    srcCncElecPrgName = json['$section/SrcCncElecPrgName'];
    srcCncStPrgName = json['$section/SrcCncStPrgName'];
    srcLcncStPrgName = json['$section/SrcLcncStPrgName'];
    srcEdmElecPrgName = json['$section/SrcEdmElecPrgName'];
    execCncElecPrgName = json['$section/ExecCncElecPrgName'];
    execCncStPrgName = json['$section/ExecCncStPrgName'];
    execLcncStPrgName = json['$section/ExecLcncStPrgName'];
    execEdmElecPrgName = json['$section/ExecEdmElecPrgName'];
    cmmElecPointFileExtern = json['$section/CmmElecPointFileExtern'];
    cmmStPointFileExtern = json['$section/CmmStPointFileExtern'];
    srcPrgExtern = json['$section/SrcPrgExtern'];
    execPrgExtern = json['$section/ExecPrgExtern'];
    cmmElecPointPath = json['$section/CmmElecPointPath'];
    cmmStPointPath = json['$section/CmmStPointPath'];
    cncElecSrcPrgPath = json['$section/CncElecSrcPrgPath'];
    mcncStSrcPrgPath = json['$section/McncStSrcPrgPath'];
    lcncStSrcPrgPath = json['$section/LcncStSrcPrgPath'];
    cmmElecSrcPrgPath = json['$section/CmmElecSrcPrgPath'];
    cmmStSrcPrgPath = json['$section/CmmStSrcPrgPath'];
    edmElecSrcPrgPath = json['$section/EdmElecSrcPrgPath'];
    cncElecExecPrgPath = json['$section/CncElecExecPrgPath'];
    cncStExecPrgPath = json['$section/CncStExecPrgPath'];
    lcncStExecPrgPath = json['$section/LcncStExecPrgPath'];
    cmmElecExecPrgPath = json['$section/CmmElecExecPrgPath'];
    cmmStExecPrgPath = json['$section/CmmStExecPrgPath'];
    edmPrgPath = json['$section/EdmPrgPath'];
    cmmElecReportSavePath = json['$section/CmmElecReportSavePath'];
    cmmStReportSavePath = json['$section/CmmStReportSavePath'];
    macCheckResultFileName = json['$section/MacCheckResultFileName'];
    copyMacCheckResultFilePath = json['$section/CopyMacCheckResultFilePath'];
    cmmZiessTcpCopySrcPath = json['$section/CmmZiessTcpCopySrcPath'];
    cmmZiessTcpCopyDesPath = json['$section/CmmZiessTcpCopyDesPath'];
    edmElecPrgName = json['$section/EdmElecPrgName'];
  }

  Map<String, dynamic> toSectionMap() {
    String section = this.section;
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$section/FileServerType'] = this.fileServerType;
    data['$section/ServiceIP'] = this.serviceIP;
    data['$section/Port'] = this.port;
    data['$section/User'] = this.user;
    data['$section/Pwd'] = this.pwd;
    data['$section/Code'] = this.code;
    data['$section/SrcCmmElecPonitFileName'] = this.srcCmmElecPonitFileName;
    data['$section/SrcCmmStPonitFileName'] = this.srcCmmStPonitFileName;
    data['$section/SrcCncElecPrgName'] = this.srcCncElecPrgName;
    data['$section/SrcCncStPrgName'] = this.srcCncStPrgName;
    data['$section/SrcLcncStPrgName'] = this.srcLcncStPrgName;
    data['$section/SrcEdmElecPrgName'] = this.srcEdmElecPrgName;
    data['$section/ExecCncElecPrgName'] = this.execCncElecPrgName;
    data['$section/ExecCncStPrgName'] = this.execCncStPrgName;
    data['$section/ExecLcncStPrgName'] = this.execLcncStPrgName;
    data['$section/ExecEdmElecPrgName'] = this.execEdmElecPrgName;
    data['$section/CmmElecPointFileExtern'] = this.cmmElecPointFileExtern;
    data['$section/CmmStPointFileExtern'] = this.cmmStPointFileExtern;
    data['$section/SrcPrgExtern'] = this.srcPrgExtern;
    data['$section/ExecPrgExtern'] = this.execPrgExtern;
    data['$section/CmmElecPointPath'] = this.cmmElecPointPath;
    data['$section/CmmStPointPath'] = this.cmmStPointPath;
    data['$section/CncElecSrcPrgPath'] = this.cncElecSrcPrgPath;
    data['$section/McncStSrcPrgPath'] = this.mcncStSrcPrgPath;
    data['$section/LcncStSrcPrgPath'] = this.lcncStSrcPrgPath;
    data['$section/CmmElecSrcPrgPath'] = this.cmmElecSrcPrgPath;
    data['$section/CmmStSrcPrgPath'] = this.cmmStSrcPrgPath;
    data['$section/EdmElecSrcPrgPath'] = this.edmElecSrcPrgPath;
    data['$section/CncElecExecPrgPath'] = this.cncElecExecPrgPath;
    data['$section/CncStExecPrgPath'] = this.cncStExecPrgPath;
    data['$section/LcncStExecPrgPath'] = this.lcncStExecPrgPath;
    data['$section/CmmElecExecPrgPath'] = this.cmmElecExecPrgPath;
    data['$section/CmmStExecPrgPath'] = this.cmmStExecPrgPath;
    data['$section/EdmPrgPath'] = this.edmPrgPath;
    data['$section/CmmElecReportSavePath'] = this.cmmElecReportSavePath;
    data['$section/CmmStReportSavePath'] = this.cmmStReportSavePath;
    data['$section/MacCheckResultFileName'] = this.macCheckResultFileName;
    data['$section/CopyMacCheckResultFilePath'] =
        this.copyMacCheckResultFilePath;
    data['$section/CmmZiessTcpCopySrcPath'] = this.cmmZiessTcpCopySrcPath;
    data['$section/CmmZiessTcpCopyDesPath'] = this.cmmZiessTcpCopyDesPath;
    data['$section/EdmElecPrgName'] = this.edmElecPrgName;
    return data;
  }
}
