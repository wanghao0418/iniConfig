/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-04-24 14:11:12
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-05-16 18:15:14
 * @FilePath: /mesui/lib/pages/configAutomation/scalableField.dart
 * @Description: 可扩展字段
 */

import 'package:flutter/material.dart';
import '../../components/customCard.dart';
import 'fieldChineseMap.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:styled_widget/styled_widget.dart';

import 'annotationTextMap.dart';
import 'componentMap.dart';

class ScalableField extends StatefulWidget {
  String field;
  Map<String, Map<String, String>> section;
  String configName;
  Function onConfirmCallBack;
  BuildContext context;
  ScalableField(
      {Key? key,
      required this.field,
      required this.section,
      required this.configName,
      required this.onConfirmCallBack,
      required this.context})
      : super(key: key);

  @override
  _ScalableFieldState createState() => _ScalableFieldState();
}

class _ScalableFieldState extends State<ScalableField> {
  List<String> _sectionList = [];
  Map<String, Map<String, String>> _optionMap = {};
  int _currentSectionIndex = 0;
  String get currentSectionField => _sectionList[_currentSectionIndex] ?? '';

  // 机床字段
  static const MachineInfoOptions = [
    'ServiceAddr',
    'ServicePort',
    'ServiceMonitorPort',
    'MacDefaultConnect',
    'ExtServerConnectMak',
    'ExtServiceAddr',
    'ExtServicePort',
    'FtpAddr',
    'FtpPort',
    'FtpUser',
    'FtpPwd',
    'FtpCodeType',
    'FtpTransferType',
    'FtpPath',
    'FtpRootDir',
    'MachineNum',
    'ChuckNum',
    'MacBrand',
    'MachineType',
    'MacProcessLimit',
    'MachineName',
    'MacEscapeChineName',
    'MacSystemType',
    'MacSystemVersion',
    'MainPrgFinishMark',
    'SubPrgFinishMark',
    'SrcPrgServerNodeName',
    'SrcPrgLocalNodeName',
    'ExecPrgServerNodeName',
    'ExecPrgLocalNodeName',
    'OutPutNodeName',
    'EactUnitePrg',
    'MachineMarkCode',
    'CncPrgCallMode',
    'ModifyInfoAddPositionMode',
    'MainPrgTopInsertMark',
    'MainPrgGoOrginAddMode',
    'SubPrgTopInsertMark',
    'SubPrgGoOrginAddMode',
    'SubInsertDoorCtrlMode',
    'ElecHeightAddMode',
    'SteelSetOffAddMode',
    'SteelSetOffAddPos',
    'OffsetStartMark',
    'OffsetEndMark',
    'MacOrgionInterceptStartMark',
    'MacOrgionInterceptEndMark',
    'MacOrgoinInsertMark',
    'RepSpecifiedContentMode',
    'RepSpecifiedContentStartNum',
    'RepSpecifiedContentNum',
    'RepSpecifiedContentOldMark',
    'RepSpecifiedContentNewMark',
    'RotatCoordinateAddMode',
    'RotatCoordinateAddNum',
    'RotatCoordinateMark',
    'RotatCoordinateFlag',
    'ReturnRotatCoordinateMode',
    'ReturnRotatCoordinateNum',
    'ReturnRotatCoordinateMark',
    'ReturnRotatCoordinateFlag',
    'ToolReplaceMode',
    'ToolReplaceStyle',
    'Tool_H_ReplaceMode',
    'Tool_H_ReplaceStyle',
    'DelTopAddMode',
    'DelTopMark',
    'DelTopToolNums',
    'KillTopPrgName',
    'CheckCoordSystem',
    'KillToolDiameter',
    'KillToolWidth',
    'KillToolHight',
    'ZCorrectionValueMode',
    'szZCorrectionValueMark',
    'ZCorrectionMargin',
    'ChuckCoordZValue',
    'MacOilLiftPumpMode',
    'MacOilLiftPumpMark',
    'SubPrgFinishReplaceMode',
    'SubPrgFinishReplaceMark',
    'CoordinatePeplaceMode',
    'CoordinatePeplaceNum',
    'CoordinatePeplaceMark',
    'AddPrgLineNumNode',
    'DeleteSpecifiedContentMode',
    'DeleteSpecifiedContentNum',
    'DeleteSpecifiedContentMark',
    'AddProgramNameMode',
    'AddProgramNameMak',
    'IsRemoveSpacesMode',
    'AddClampStatusMode',
    'ClampCloseMark',
    'ClampRelaxMark',
    'MainPrgUpMode',
    'SubPrgUpMode',
    'SubUpPrgNumbarMode',
    'MacMainPrgPath',
    'MacSubPrgPath',
    'MainPrgName',
    'MacFirstSubPrgName',
    'MacOriginPrgName',
    'FileExtension',
    'CleanPrgName',
    'CleanChuckPrgName',
    'SteelPosBallPrgName',
    'SteelCheckPrgName',
    'CopyMacCheckResultFileMark',
    'OnMacCheckResultFilePath',
    'CmmResultName',
    'AutoDoor',
    'OpenDoorComm',
    'CloseDoorComm',
    'OrginAbsoluteType',
    'OrginAbsoluteX',
  ];

  String _getCurrentOptionKey(index) =>
      _optionMap[currentSectionField]?.keys?.toList()[index] ?? '';
  String _getCurrentOptionValue(index) =>
      _optionMap[currentSectionField]?.values?.toList()[index] ?? '';

  // 初始化节点字段列表
  void _initSectionList() {
    RegExp regExp = RegExp('^${widget.field}(\\d+)\$');
    _sectionList =
        widget.section.keys.toList().where((e) => regExp.hasMatch(e)).toList();
    _sectionList.forEach((field) {
      _optionMap[field] = widget.section[field] ?? {};
    });
    // print((widget.section['MachineInfo01'] as Map).keys.toList());
  }

  // 获取编号
  String _getNumber() {
    return _sectionList.length + 1 < 10
        ? '0${_sectionList.length + 1}'
        : '${_sectionList.length + 1}';
  }

  // 新增初始配置
  Map<String, String> _addInitOption() {
    Map<String, String> optionMap = {};
    // switch (widget.field) {
    //   case 'MachineInfo':
    //     List options = (widget.section[_sectionList[0]] as Map).keys.toList();
    //     options.forEach((option) {
    //       optionMap[option] = '';
    //     });
    // }
    List options = (widget.section[_sectionList[0]] as Map).keys.toList();
    options.forEach((option) {
      optionMap[option] = '';
    });
    return optionMap;
  }

  // 侧边栏
  Widget _renderSideBar() {
    return CustomCard(
        cardBackgroundColor: Color(0xffE9F2FF),
        containChild: Container(
          width: 150,
          height: double.infinity,
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                  child: _sectionList.length > 0
                      ? ListView.builder(
                          itemBuilder: ((context, index) {
                            return _renderSection(_sectionList[index], index) ??
                                Container();
                          }),
                          itemCount: _sectionList.length)
                      : Container()),
              Container(
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        // 添加节点
                        setState(() {
                          _sectionList.add(widget.field + _getNumber());
                          _optionMap[_sectionList.last] = _addInitOption();
                        });
                      },
                      child: Icon(Icons.add),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        // 删除节点
                        if (_sectionList.length > 1) {
                          setState(() {
                            var currentSection =
                                _sectionList[_sectionList.length - 1]; // 当前节点字段
                            _sectionList.removeAt(_sectionList.length - 1);
                            _optionMap.remove(currentSection);
                            _currentSectionIndex = 0;
                          });
                        }
                      },
                      child: Icon(Icons.delete),
                    ))
                  ],
                ),
              )
            ],
          ),
        ));
  }

  // 渲染节点
  Widget _renderSection(section, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentSectionIndex = index;
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
                alignment: Alignment.center,
                child: Text(getFieldChinese(section))
                    .textColor(_currentSectionIndex == index
                        ? Color(0xff1677FF)
                        : Color(0xff5E5E5E))
                    .fontSize(14)
                    .textAlignment(TextAlign.center))
            .decorated(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: _currentSectionIndex == index
                    ? Color(0xffE9F2FF)
                    : Colors.white,
                boxShadow: _currentSectionIndex == index
                    ? []
                    : [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 0),
                            blurRadius: 10,
                            spreadRadius: 0)
                      ]),
      ).height(40).padding(all: 5),
    );
  }

  Widget _renderMainContent() {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
      ),
      child: Row(
        children: [
          _renderSideBar(),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            children: [
              Expanded(
                child: _optionMap[currentSectionField] != null
                    ? ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            height: 1,
                            color: Colors.grey[400],
                          );
                        },
                        itemBuilder: ((context, index) {
                          var option = _getCurrentOptionKey(index);
                          var value = _getCurrentOptionValue(index);
                          return renderComponent(option, value, (newValue) {
                            // print(option);
                            print(newValue);
                            // print(_optionMap[currentSectionField]![option]);
                            _optionMap[currentSectionField]![option] = newValue;
                            // setState(() {

                            // });
                          }, currentSectionField, widget.configName, context);
                        }),
                        itemCount: _optionMap[currentSectionField]!
                            .values
                            .toList()
                            .length)
                    : Container(),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 保存
                        widget.onConfirmCallBack(_optionMap);
                        // SmartDialog.dismiss();
                        // 关闭弹窗
                        Navigator.of(context).pop();
                      },
                      child: Text('保存'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // 取消
                        // SmartDialog.dismiss();
                        // 关闭弹窗
                        Navigator.of(context).pop();
                      },
                      child: Text('取消'),
                    )
                  ],
                ),
              )
            ],
          )),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSectionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _renderMainContent(),
    );
  }
}
