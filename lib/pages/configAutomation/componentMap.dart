/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-04-24 11:10:25
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-07 13:18:41
 * @FilePath: /mesui/lib/pages/configAutomation/componentMap.dart
 * @Description: 组件映射
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'annotationTextMap.dart';
import 'optionsMap.dart';
import 'splitJointContainer.dart';
import 'package:styled_widget/styled_widget.dart';

RenderComponents getComponentType(
    String field, String section, String configName) {
  return componentMap['$configName-$section-$field'] ??
      getScalableComponentType(field, section, configName);
}

RenderComponents getScalableComponentType(
    String field, String section, String configName) {
  var reg = RegExp(r'^[a-zA-Z]+\d+$');
  var normalSection;
  if (reg.hasMatch(section)) {
    var reg2 = RegExp(r'[a-zA-Z]+');
    // 将首部英文提取出来
    var match = reg2.firstMatch(section);
    normalSection = match?.group(0);
  } else {
    normalSection = section;
  }
  return componentMap['$configName-$normalSection-$field'] ??
      RenderComponents.input;
}

enum RenderComponents {
  // 输入
  input,
  // 选择
  select,
  // 拼接
  splitJoint
}

Map<String, RenderComponents> componentMap = {
  'plcAddress-PlcDefinition-OkLight': RenderComponents.select,
  'plcAddress-PlcDefinition-NgLight': RenderComponents.select,
  'plcAddress-PlcDefinition-WarnLight': RenderComponents.select,
  'userConfig-MachineInfo-MacDefaultConnect': RenderComponents.select,
  'userConfig-MachineInfo-ExtServerConnectMak': RenderComponents.select,
  'userConfig-MachineInfo-FtpPath': RenderComponents.splitJoint,
  'userConfig-MachineInfo-FtpRootDir': RenderComponents.splitJoint,
  'userConfig-MachineInfo-MachineType': RenderComponents.select,
  'userConfig-MachineInfo-MacSystemType': RenderComponents.select,
  'userConfig-MachineInfo-EactUnitePrg': RenderComponents.select,
  'userConfig-MachineInfo-CncPrgCallMode': RenderComponents.select,
  'userConfig-MachineInfo-ModifyInfoAddPositionMode': RenderComponents.select,
  'userConfig-MachineInfo-MainPrgGoOrginAddMode': RenderComponents.select,
  'userConfig-MachineInfo-SubPrgGoOrginAddMode': RenderComponents.select,
  'userConfig-MachineInfo-SubInsertDoorCtrlMode': RenderComponents.select,
  'userConfig-MachineInfo-ElecHeightAddMode': RenderComponents.select,
  'userConfig-MachineInfo-SteelSetOffAddMode': RenderComponents.select,
  'userConfig-MachineInfo-SteelSetOffAddPos': RenderComponents.select,
  'userConfig-MachineInfo-RepSpecifiedContentMode': RenderComponents.select,
  'userConfig-MachineInfo-RepSpecifiedContentNum': RenderComponents.select,
  'userConfig-MachineInfo-RotatCoordinateAddMode': RenderComponents.select,
  'userConfig-MachineInfo-RotatCoordinateAddNum': RenderComponents.select,
  'userConfig-MachineInfo-ReturnRotatCoordinateMode': RenderComponents.select,
  'userConfig-MachineInfo-ReturnRotatCoordinateNum': RenderComponents.select,
  'userConfig-MachineInfo-ToolReplaceMode': RenderComponents.select,
  'userConfig-MachineInfo-Tool_H_ReplaceMode': RenderComponents.select,
  'userConfig-MachineInfo-DelTopAddMode': RenderComponents.select,
  'userConfig-MachineInfo-CoordinatePeplaceMode': RenderComponents.select,
  'userConfig-MachineInfo-CoordinatePeplaceNum': RenderComponents.select,
  'userConfig-MachineInfo-AddPrgLineNumNode': RenderComponents.select,
  'userConfig-MachineInfo-DeleteSpecifiedContentMode': RenderComponents.select,
  'userConfig-MachineInfo-DeleteSpecifiedContentNum': RenderComponents.select,
  'userConfig-MachineInfo-AddProgramNameMode': RenderComponents.select,
  'userConfig-MachineInfo-IsRemoveSpacesMode': RenderComponents.select,
  'userConfig-MachineInfo-MainPrgUpMode': RenderComponents.select,
  'userConfig-MachineInfo-SubPrgUpMode': RenderComponents.select,
  'userConfig-MachineInfo-SubUpPrgNumbarMode': RenderComponents.select,
  'userConfig-MachineInfo-MacMainPrgPath': RenderComponents.splitJoint,
  'userConfig-MachineInfo-MacSubPrgPath': RenderComponents.splitJoint,
  'userConfig-MachineInfo-CopyMacCheckResultFileMark': RenderComponents.select,
  'userConfig-MachineInfo-OnMacCheckResultFilePath':
      RenderComponents.splitJoint,
  'userConfig-MachineInfo-AutoDoor': RenderComponents.select,
  'userConfig-MachineInfo-OrginAbsoluteType': RenderComponents.select,
  'userConfig-MachineInfo-MachineAheadTask': RenderComponents.select,
  'userConfig-MachineInfo-MacBlowMode': RenderComponents.select,
  'userConfig-MachineInfo-AutoOfflineType': RenderComponents.select,
  'userConfig-MachineInfo-MacFenceDoorExistMark': RenderComponents.select,
  'userConfig-MachineInfo-MacReadAxesMacroMark': RenderComponents.select,
  'userConfig-MachineInfo-IsWriteAxesMacroToSqlDB': RenderComponents.select,
  'userConfig-MachineInfo-MacReadRotateMacroMark': RenderComponents.select,
  'userConfig-MachineInfo-IsWriteRotateMacroToSqlDB': RenderComponents.select,
  'userConfig-MachineInfo-RotateOffsetAddMode': RenderComponents.select,
  'userConfig-MachineInfo-RotateOffsetAddPos': RenderComponents.select,
  'userConfig-MachineInfo-MacMergerProgramMark': RenderComponents.select,
  'userConfig-MachineInfo-ToolLifeOverflowOffineMark': RenderComponents.select,
  'userConfig-MachineInfo-CopyCmmResultMark': RenderComponents.select,
  'userConfig-MachineInfo-CmmResultFilePathPos': RenderComponents.select,
  'userConfig-MachineInfo-MacExistToolManagement': RenderComponents.select,
  'userConfig-MachineInfo-ToolOpenPermissionMark': RenderComponents.select,
  'userConfig-MachineInfo-MacExceptionHandle': RenderComponents.select,
  'userConfig-MachineInfo-MacFinishNotToCleanMac': RenderComponents.select,
  'userConfig-MachineInfo-AheadTaskMonitorFolder': RenderComponents.splitJoint,
  'userConfig-MachineInfo-ZeissStartFileFolder': RenderComponents.splitJoint,
  'userConfig-MachineInfo-ZeissConnectMode': RenderComponents.select,
  'userConfig-MachineInfo-CmmDriveMode': RenderComponents.select,
  'userConfig-MachineInfo-OilGrooveCtrlType': RenderComponents.select,
  'userConfig-MachineInfo-IsAutoMachineOnline': RenderComponents.select,
  'userConfig-MachineInfo-EAtmMacDataCollectRange': RenderComponents.select,
  'userConfig-MachineInfo-ChuckScanJustAnyone': RenderComponents.select,
  'userConfig-MachineInfo-WorkSteelAbalmIsPutDown': RenderComponents.select,
  'userConfig-MachineInfo-UseQieXyAndTieXcRecordMark': RenderComponents.select,
  'userConfig-MachineInfo-SteelPosBallMark': RenderComponents.select,
  'userConfig-PrgLocalInfo-LocalSrcPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgLocalInfo-LocalMainPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgLocalInfo-LocalSubPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgLocalInfo-OrginPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgLocalInfo-KillTopPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgLocalInfo-EdmTemplatePrgPath': RenderComponents.splitJoint,
  'userConfig-PrgLocalInfo-FileServerType': RenderComponents.select,
  'userConfig-PrgServerInfo-SrcCmmElecPonitFileName':
      RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-SrcCmmStPonitFileName': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-SrcCncElecPrgName': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-SrcCncStPrgName': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-SrcLcncStPrgName': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-SrcEdmElecPrgName': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-ExecCncElecPrgName': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-ExecCncStPrgName': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-ExecLcncStPrgName': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-ExecEdmElecPrgName': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-CmmElecPointPath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-CmmStPointPath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-CncElecSrcPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-McncStSrcPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-LcncStSrcPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-CmmElecSrcPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-CmmStSrcPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-EdmElecSrcPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-CncElecExecPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-CncStExecPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-LcncStExecPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-CmmElecExecPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-CmmStExecPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-EdmPrgPath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-CmmElecReportSavePath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-CmmStReportSavePath': RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-MacCheckResultFileName':
      RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-CopyMacCheckResultFilePath':
      RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-CmmZiessTcpCopySrcPath':
      RenderComponents.splitJoint,
  'userConfig-PrgServerInfo-CmmZiessTcpCopyDesPath':
      RenderComponents.splitJoint,
  'userConfig-EACTClientTcpInfo-FancMode': RenderComponents.select,
  'userConfig-DataBaseInfo-DBType': RenderComponents.select,
  'userConfig-DataBaseInfo-UseDbXml': RenderComponents.select,
  'userConfig-SysInfo-RunMode': RenderComponents.select,
  'userConfig-SysInfo-CycleRun': RenderComponents.select,
  'userConfig-SysInfo-ShelfIsOffLine': RenderComponents.select,
  'userConfig-SysInfo-PrgDownMode': RenderComponents.select,
  'userConfig-SysInfo-CheckElecCncToolMark': RenderComponents.select,
  'userConfig-SysInfo-CheckFenceDoorMark': RenderComponents.select,
  'userConfig-SysInfo-CmmSPsync': RenderComponents.select,
  'userConfig-SysInfo-CopyMode': RenderComponents.select,
  'userConfig-SysInfo-WorkpieceHeightSrc': RenderComponents.select,
  'userConfig-SysInfo-ReportSwitch': RenderComponents.select,
  'userConfig-SysInfo-EdmMoreSteelTask': RenderComponents.select,
  'userConfig-SysInfo-ShelfOfflineMode': RenderComponents.select,
  'userConfig-SysInfo-ThreeDimensionalElectrodeMark': RenderComponents.select,
  'userConfig-SysInfo-IsProcessQuadrantAngle': RenderComponents.select,
  'userConfig-SysInfo-SteelCCNCFinishUpClean': RenderComponents.select,
  'userConfig-SysInfo-CheckProcessStepSwitch': RenderComponents.select,
  'userConfig-SysInfo-GetServerPrgWorkOrderMark': RenderComponents.select,
  'userConfig-SysInfo-RobotCarryWorkpieceTaskType': RenderComponents.select,
  'userConfig-SysInfo-ToolLifeCollectMode': RenderComponents.select,
  'userConfig-SysInfo-AbnormalairIsOffLineMac': RenderComponents.select,
  'userConfig-FixtureInfo-AddFixtureType': RenderComponents.select,
  'userConfig-MachineScanTask-ScanType': RenderComponents.select,
  'userConfig-MachineScanTask-ScanClean': RenderComponents.select,
  'userConfig-RobotInfo-RobotType': RenderComponents.select,
  'userConfig-RobotInfo-RobotClampType': RenderComponents.select,
  'userConfig-DataSourceType-nType': RenderComponents.select,
  'userConfig-DataSourceType-ImportTable': RenderComponents.select,
  'userConfig-DataBaseWorkReport-WorkReport': RenderComponents.select,
  'userConfig-DataBaseWorkReport-EDMReportHandleMark': RenderComponents.select,
  'userConfig-TcpScanDriverInfo-ServiceType': RenderComponents.select,
  'userConfig-ScanDevice-ServiceType': RenderComponents.select,
  'userConfig-EmanWorkReport-EmanReportMode': RenderComponents.select,
  'userConfig-EmanWorkReport-AgvStart': RenderComponents.select,
  'userConfig-EmanWorkReport-UseEmancraftRoute': RenderComponents.select,
  'userConfig-TestCMMInfo-MacSystemType': RenderComponents.select,
  'userConfig-WorkOrderInfo-workOrderElecPath': RenderComponents.splitJoint,
  'userConfig-WorkOrderInfo-WorkExcelFileName': RenderComponents.splitJoint,
  'ui-Shelf-ShelfSensorType': RenderComponents.select,
  'ui-Shelf-ShelfFuncType': RenderComponents.select,
  'ui-Shelf-CraftPriority': RenderComponents.select,
  'ui-Shelf-isNoScan': RenderComponents.select,
  'ui-Shelf-IOlimit': RenderComponents.select,
  'ui-Shelf-MoreWorkpieceMark': RenderComponents.select,
  'ui-Shelf-Locationfunction': RenderComponents.select,
  'ui-GlobelInfo-CheckStrorageExist': RenderComponents.select,
  'ui-GlobelInfo-AgvOperBtnShowMark': RenderComponents.select,
  'ui-GlobelInfo-ShowTipInfoMark': RenderComponents.select,
  'ui-GlobelInfo-BtnStartUpMachineMark': RenderComponents.select,
  'ui-GlobelInfo-BtnSetUpMachineMark': RenderComponents.select,
  'ui-RobotManualUI-TransferUIShow': RenderComponents.select,
  'ui-HideProgressBar-ProgressBarMode': RenderComponents.select,
  // 'ui-HideQWidgetPage-MacUiWidgetePage': RenderComponents.select,
};

Widget renderComponent(
  String optionKey,
  String optionValue,
  Function onValueChange,
  String section,
  String configName,
  BuildContext context, {
  bool? disabled = false,
}) {
  Widget currentComponent = Container();
  switch (getComponentType(optionKey, section, configName)) {
    case RenderComponents.input:
      currentComponent =
          renderInputWidget(optionKey, optionValue, onValueChange);
      break;
    case RenderComponents.select:
      currentComponent = renderSelectWidget(
          optionKey, optionValue, onValueChange, section, configName);
      break;
    case RenderComponents.splitJoint:
      currentComponent = renderSplitJointWidget(
          optionKey, optionValue, onValueChange, context);
      break;
    default:
      currentComponent =
          renderInputWidget(optionKey, optionValue, onValueChange);
      break;
  }

  return Container(
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Tooltip(
          message: getAnnotationText(optionKey, section, configName),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(optionKey).fontWeight(FontWeight.bold).fontSize(16),
              SizedBox(
                height: 10.0,
              ),
              Text(getAnnotationText(optionKey, section, configName))
                  .fontSize(12)
                  .textColor(Color(0xff999999))
            ],
          ),
        )),
        SizedBox(
          width: 10.0,
        ),
        currentComponent
      ],
    ),
  );
}

// 输入组件
Widget renderInputWidget(
  String optionKey,
  String optionValue,
  Function onValueChange,
) {
  return Container(
      child: TextField(
    controller: TextEditingController(text: optionValue),
    decoration: InputDecoration(
        label: Text(optionKey),
        border: OutlineInputBorder(),
        hintText: '请输入$optionKey'),
    onChanged: (value) {
      // 输入校验两侧是否有空格
      if (value.startsWith(' ') || value.endsWith(' ')) {
        SmartDialog.showToast('输入内容不能以空格开头或结尾', debounce: true);
        value = value.trim();
      }
      onValueChange(value);
    },
  )).width(500);
}

// 选择组件
Widget renderSelectWidget(
  String optionKey,
  String optionValue,
  Function onValueChange,
  String section,
  String configName,
) {
  return Container(
      child: DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: optionKey,
    ),
    value: optionValue.isNotEmpty ? optionValue : null,
    hint: Text('请选择$optionKey'),
    items: getOptions(optionKey, section, configName),
    onChanged: (v) {
      onValueChange(v);
    },
  )).width(500);
}

// 拼接组件
Widget renderSplitJointWidget(
  String optionKey,
  String optionValue,
  Function onValueChange,
  BuildContext context,
) {
  return Container(
      child: Row(
    children: [
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(optionValue),
        ),
      ),
      SizedBox(
        width: 10.0,
      ),
      IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.all(0),
                    content: Container(
                      width: 800,
                      height: 500,
                      child: SplitJointContainer(
                          field: optionKey,
                          value: optionValue,
                          onValueChange: (val) {
                            onValueChange(val);
                          }),
                    ),
                  );
                });
          },
          icon: Icon(
            Icons.settings,
            size: 20,
          ))
    ],
  )).width(500);
}
