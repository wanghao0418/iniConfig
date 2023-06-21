import 'package:fluent_ui/fluent_ui.dart' hide Tab;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/components/field_change.dart';

import '../../../../../../common/components/field_group.dart';
import '../../../../../system/home/widgets/cached_page_view.dart';
import '../../../../../system/home/widgets/fluent_tab.dart';

class MacInfoSetting extends StatefulWidget {
  const MacInfoSetting(
      {Key? key, required this.section, required this.isLineOut})
      : super(key: key);
  final String section;
  final bool isLineOut;

  @override
  _MacInfoSettingState createState() => _MacInfoSettingState();
}

class _MacInfoSettingState extends State<MacInfoSetting> {
  late MacInfo macInfo;
  ValueNotifier<int> currentTabIndex = ValueNotifier<int>(0);
  late PageController pageController;
  List<RenderField> macInfoMenuList = [
    RenderFieldGroup(groupName: "连接参数", children: [
      RenderFieldInfo(
        field: 'MachineNum',
        section: 'MachineInfo',
        name: "机床号",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ServiceAddr',
        section: 'MachineInfo',
        name: "机床IP",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ServicePort',
        section: 'MachineInfo',
        name: "机床端口",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ServiceMonitorPort',
        section: 'MachineInfo',
        name: "机床的第二个端口（一般不用）",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MachineUser',
        section: 'MachineInfo',
        name: "机床用户",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MachinePassowrd',
        section: 'MachineInfo',
        name: "机床密码",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacSystemVersion',
        section: 'MachineInfo',
        name: "机床系统版本",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MachineAxes',
        section: 'MachineInfo',
        name: "机床轴数",
        renderType: RenderType.numberInput,
      ),
    ]),
    RenderFieldInfo(
      field: 'MachineName',
      section: 'MachineInfo',
      name: "机床名称，不同机床间不能重复",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
        field: 'MacDefaultConnect',
        section: 'MachineInfo',
        name: "默认连接",
        renderType: RenderType.select,
        options: {"无": "0", "自动触发上线": "1", "上线后校验钢件是否开料": "2"}),
    RenderFieldInfo(
        field: 'MachineType',
        section: 'MachineInfo',
        name: "机床类型",
        renderType: RenderType.select,
        options: {
          "CNC": "CNC",
          "CMM": "CMM",
          "EDM": "EDM",
          "CLEAN": "CLEAN",
          "DRY": "DRY"
        }),
    RenderFieldInfo(
        field: 'MacSystemType',
        section: 'MachineInfo',
        name: "机床系统类型",
        renderType: RenderType.select,
        options: {
          "发那科": "FANUC",
          "海德汉": "HDH",
          "海克斯康": "HEXAGON",
          "哈斯": "HASS",
          "精雕": "JD",
          "牧野EDM": "MAKINO",
          "沙迪克": "SODICK",
          "视觉检测": "VISUALRATE",
          "蔡司检测": "ZEISS",
          "测试": "TEST",
          "烘干": "DRY",
          "清洗": "CLEAN",
          "三菱": "SLCNC",
          "KND": "KND",
          "广数": "GSK",
          "大隈（wei）": "OKUMA"
        }),
    RenderFieldInfo(
        field: 'MacBrand',
        section: 'MachineInfo',
        name: "机床品牌",
        renderType: RenderType.select,
        options: {
          "发那科": "FANUC",
          "海德汉": "HDH",
          "海克斯康": "HEXAGON",
          "哈斯": "HASS",
          "精雕": "JD",
          "牧野EDM": "MAKINO",
          "沙迪克": "SODICK",
          "视觉检测": "VISUALRATE",
          "蔡司检测": "ZEISS",
          "测试": "TEST",
          "烘干": "DRY",
          "清洗": "CLEAN",
          "三菱": "SLCNC",
          "KND": "KND",
          "广数": "GSK",
          "大隈（wei）": "OKUMA"
        }),
  ];
  List<RenderField> eatmSettingMenuList = [
    RenderFieldGroup(groupName: "自动化相关", children: [
      RenderFieldInfo(
        field: 'ChuckNum',
        section: 'MachineInfo',
        name: "机床卡盘号信息",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacProcessLimit',
        section: 'MachineInfo',
        name: "机床限制工艺",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'CncPrgCallMode',
          section: 'MachineInfo',
          name: "加工机床程序调用模式",
          renderType: RenderType.radio,
          options: {"MAIN": "MAIN", "M198": "M198", "M98": "M98"}),
    ]),
    RenderFieldGroup(groupName: "程序管理", children: [
      RenderFieldInfo(
        field: 'SrcPrgServerNodeName',
        section: 'MachineInfo',
        name: "源程序服务节点名称",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'SrcPrgLocalNodeName',
        section: 'MachineInfo',
        name: "源程序本地节点名称",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ExecPrgServerNodeName',
        section: 'MachineInfo',
        name: "执行程序服务节点名称",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ExecPrgLocalNodeName',
        section: 'MachineInfo',
        name: "执行程序本地节点名称",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'OutPutNodeName',
        section: 'MachineInfo',
        name: "执行程序本地节点名称",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldGroup(groupName: "下载上传相关", children: [
      RenderFieldInfo(
          field: 'MainPrgUpMode',
          section: 'MachineInfo',
          name: "主程序上传方式",
          renderType: RenderType.select,
          options: {"无需上传": "0", "FTP上传": "1", "机床共享目录拷贝": "2", "API上传": "3"}),
      RenderFieldInfo(
          field: 'SubPrgUpMode',
          section: 'MachineInfo',
          name: "子程序上传方式",
          renderType: RenderType.select,
          options: {
            "无子程序调用": "0",
            "FTP上传": "1",
            "机床共享目录拷贝": "2",
            "API上传": "3"
          }),
      RenderFieldInfo(
          field: 'SubUpPrgNumbarMode',
          section: 'MachineInfo',
          name: "子程序个数上传模式",
          renderType: RenderType.select,
          options: {
            "默认按照顺序全部上传": "0",
            "加工完成一个上传一个": "1",
            "加工中上传": "2",
          }),
      RenderFieldInfo(
        field: 'MacMainPrgPath',
        section: 'MachineInfo',
        name: "机床主程式上传路径",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacSubPrgPath',
        section: 'MachineInfo',
        name: "机床子程式上传路径",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MainPrgName',
        section: 'MachineInfo',
        name: "机床主程序命名",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacFirstSubPrgName',
        section: 'MachineInfo',
        name: "机床子程序命名",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacOriginPrgName',
        section: 'MachineInfo',
        name: "机床原点程式命名",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'FileExtension',
        section: 'MachineInfo',
        name: "机床程序扩展名",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'CleanPrgName',
        section: 'MachineInfo',
        name: "机床吹气清洁程序命名",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'CleanChuckPrgName',
        section: 'MachineInfo',
        name: "机床清洁卡盘程序命名",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'SteelPosBallPrgName',
        section: 'MachineInfo',
        name: "钢件分中程序名",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldGroup(groupName: "上下料相关", children: [
      RenderFieldInfo(
          field: 'OrginAbsoluteType',
          section: 'MachineInfo',
          name: "坐标类型",
          renderType: RenderType.radio,
          options: {
            "机械坐标": "0",
            "绝对坐标": "1",
          }),
      RenderFieldInfo(
        field: 'OrginAbsoluteX',
        section: 'MachineInfo',
        name: "用于机器人上料时的机床的坐标X",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'OrginAbsoluteY',
        section: 'MachineInfo',
        name: "用于机器人上料时的机床的坐标Y",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'OrginAbsoluteZ',
        section: 'MachineInfo',
        name: "用于机器人上料时的机床的坐标Z",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'OrginAbsoluteU',
        section: 'MachineInfo',
        name: "用于机器人上料时的机床的坐标U",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'OrginAbsoluteW',
        section: 'MachineInfo',
        name: "用于机器人上料时的机床的坐标W",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacPosX',
        section: 'MachineInfo',
        name: "电极原点坐标X",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacPosY',
        section: 'MachineInfo',
        name: "电极原点坐标Y",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacPosZ',
        section: 'MachineInfo',
        name: "电极原点坐标Z",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacPosU',
        section: 'MachineInfo',
        name: "电极原点坐标U",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacPosA',
        section: 'MachineInfo',
        name: "电极原点坐标A",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacPosW',
        section: 'MachineInfo',
        name: "电极原点坐标W",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacOriginPrgNameInfo',
        section: 'MachineInfo',
        name: "机床原点程序名称信息",
        renderType: RenderType.input,
      ),
    ])
  ];

  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = macInfo.toSectionMap();
    temp[field] = val;
    macInfo = MacInfo.fromSectionJson(temp, widget.section);
  }

  String? getFieldValue(String field) {
    return macInfo.toSectionMap()[field];
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
    for (var element in macInfoMenuList) {
      if (element is RenderFieldInfo) {
        element.section = widget.section;
      } else if (element is RenderFieldGroup) {
        for (var element in element.children) {
          element.section = widget.section;
        }
      }
    }
    for (var element in eatmSettingMenuList) {
      if (element is RenderFieldInfo) {
        element.section = widget.section;
      } else if (element is RenderFieldGroup) {
        for (var element in element.children) {
          element.section = widget.section;
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    macInfo = MacInfo(section: widget.section);
    currentTabIndex.addListener(() {
      pageController.animateToPage(
        currentTabIndex.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      // pageController.jumpToPage(currentTabIndex.value);
    });
    initMenu();
  }

  _buildRenderField(RenderField info) {
    if (info is RenderFieldGroup) {
      return Container(
        margin: EdgeInsets.only(bottom: 5.r),
        child: FieldGroup(
          groupName: info.groupName,
          getValue: getFieldValue,
          children: info.children,
          isChanged: isChanged,
          onChanged: (field, value) {
            onFieldChange(field, value);
          },
        ),
      );
    } else {
      return FieldChange(
        renderFieldInfo: info as RenderFieldInfo,
        showValue: getFieldValue(info.fieldKey),
        isChanged: isChanged(info.fieldKey),
        onChanged: (field, value) {
          onFieldChange(field, value);
        },
      );
    }
  }

  _buildTabContent() {
    return CachedPageView(
      initialPageIndex: currentTabIndex.value,
      children: [
        KeyedSubtree(
          key: Key('1'),
          child: Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(children: [
                  ...macInfoMenuList.map((e) => _buildRenderField(e)).toList(),
                ]),
              )),
        ),
        KeyedSubtree(
          key: Key('2'),
          child: Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(children: [
                  ...eatmSettingMenuList
                      .map((e) => _buildRenderField(e))
                      .toList(),
                ]),
              )),
        )
      ],
      onPageChanged: (value) {},
      onPageControllerCreated: (pcontroller) {
        pageController = pcontroller;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        // _buildCustomTab(context),
        FluentTab(
          currentIndex: currentTabIndex.value,
          tabs: [
            Tab(
              id: '1',
              key: Key('1'),
              text: Text('机床信息'),
              body: Container(
                child: Text('机床信息'),
              ),
            ),
            if (!widget.isLineOut)
              Tab(
                id: '2',
                key: Key('2'),
                text: Text('自动化设置'),
                body: Container(
                  child: Text('自动化设置'),
                ),
              )
          ],
          onChanged: (value) {
            if (value == currentTabIndex) return;
            currentTabIndex.value = value;
            setState(() {});
          },
          closeButtonVisibility: CloseButtonVisibilityMode.never,
        ),
        Expanded(child: _buildTabContent()),
      ]),
    );
  }
}

class MacInfo {
  final String section;
  String? machineNum;
  String? serviceAddr;
  String? servicePort;
  String? serviceMonitorPort;
  String? machineUser;
  String? machinePassowrd;
  String? machineName;
  String? macSystemType;
  String? macSystemVersion;
  String? macBrand;
  String? machineAxes;
  String? machineType;
  String? chuckNum;
  String? macProcessLimit;
  String? cncPrgCallMode;
  String? macDefaultConnect;
  String? srcPrgServerNodeName;
  String? srcPrgLocalNodeName;
  String? execPrgServerNodeName;
  String? execPrgLocalNodeName;
  String? outPutNodeName;
  String? mainPrgUpMode;
  String? subPrgUpMode;
  String? subUpPrgNumbarMode;
  String? macMainPrgPath;
  String? macSubPrgPath;
  String? mainPrgName;
  String? macFirstSubPrgName;
  String? macOriginPrgName;
  String? fileExtension;
  String? cleanPrgName;
  String? cleanChuckPrgName;
  String? steelPosBallPrgName;
  String? orginAbsoluteType;
  String? orginAbsoluteX;
  String? orginAbsoluteY;
  String? orginAbsoluteZ;
  String? orginAbsoluteU;
  String? orginAbsoluteW;
  String? macPosX;
  String? macPosY;
  String? macPosZ;
  String? macPosU;
  String? macPosA;
  String? macPosW;
  String? macOriginPrgNameInfo;
  String? autoOfflineType;
  String? macFenceDoorExistMark;
  String? machineAheadTask;
  String? machineAheadLine;
  String? macExceptionHandle;
  String? macFinishNotToCleanMac;
  String? macStartWaitTime;
  String? chuckScanJustAnyone;
  String? isAutoMachineOnline;
  String? workSteelAbalmIsPutDown;
  String? abnormalairIsOffLineMac;
  String? autoDoor;
  String? openDoorComm;
  String? closeDoorComm;
  String? ftpAddr;
  String? ftpPort;
  String? ftpUser;
  String? ftpPwd;
  String? ftpCodeType;
  String? ftpTransferType;
  String? ftpPath;
  String? ftpRootDir;
  String? toolMagazineSize;
  String? macExistToolManagement;
  String? toolOpenPermissionMark;
  String? mainPrgFinishMark;
  String? subPrgFinishMark;
  String? useQieXyAndTieXcRecordMark;
  String? macMergerProgramMark;
  String? macCloseDoorPrgName;
  String? toolLifeOverflowOffineMark;
  String? workTimeLowerLimit;
  String? macCleanToolPrgName;
  String? macReadAxesMacroMark;
  String? isWriteAxesMacroToSqlDB;
  String? readMacroPosX;
  String? readMacroPosY;
  String? readMacroPosZ;
  String? macReadRotateMacroMark;
  String? isWriteRotateMacroToSqlDB;
  String? readRotateMacroPos;
  String? rotateOffsetAddMode;
  String? rotateOffsetAddPos;
  String? copyCmmResultMark;
  String? readMacroStartPos;
  String? macCmmCheckPosMacroPos;
  String? macCmmResultMacroPos;
  String? cmmResultFilePathPos;
  String? steelCheckPrgName;
  String? copyMacCheckResultFileMark;
  String? onMacCheckResultFilePath;
  String? cmmResultName;
  String? macUseOutToolMark;
  String? macOutToolUsedToolNum;
  String? changeToolName;
  String? extServerConnectMak;
  String? extServiceAddr;
  String? extServicePort;
  String? aheadTaskMonitorFolder;
  String? zeissStartFileFolder;
  String? zeissConnectMode;
  String? cmmDriveMode;
  String? macWaitFinishTime;
  String? edmMoreSteelTask;
  String? oilTankReserve;
  String? oilGrooveCtrlType;
  String? modifyInfoAddPositionMode;
  String? mainPrgTopInsertMark;
  String? mainPrgGoOrginAddMode;
  String? subPrgTopInsertMark;
  String? subPrgGoOrginAddMode;
  String? eactUnitePrg;
  String? machineMarkCode;
  String? subInsertDoorCtrlMode;
  String? elecHeightAddMode;
  String? steelSetOffAddMode;
  String? steelSetOffAddPos;
  String? offsetStartMark;
  String? offsetEndMark;
  String? macOrgionInterceptStartMark;
  String? macOrgionInterceptEndMark;
  String? macOrgoinInsertMark;
  String? repSpecifiedContentMode;
  String? repSpecifiedContentStartNum;
  String? repSpecifiedContentNum;
  String? repSpecifiedContentOldMark;
  String? repSpecifiedContentNewMark;
  String? rotatCoordinateAddMode;
  String? rotatCoordinateAddNum;
  String? rotatCoordinateMark;
  String? rotatCoordinateFlag;
  String? returnRotatCoordinateMode;
  String? returnRotatCoordinateNum;
  String? returnRotatCoordinateMark;
  String? returnRotatCoordinateFlag;
  String? toolReplaceMode;
  String? toolReplaceStyle;
  String? toolHReplaceMode;
  String? toolHReplaceStyle;
  String? delTopAddMode;
  String? delTopMark;
  String? delTopToolNums;
  String? killTopPrgName;
  String? checkCoordSystem;
  String? killToolDiameter;
  String? killToolWidth;
  String? killToolHight;
  String? zCorrectionValueMode;
  String? szZCorrectionValueMark;
  String? zCorrectionMargin;
  String? chuckCoordZValue;
  String? subPrgFinishReplaceMode;
  String? subPrgFinishReplaceMark;
  String? coordinatePeplaceMode;
  String? coordinatePeplaceNum;
  String? coordinatePeplaceMark;
  String? deleteSpecifiedContentMode;
  String? deleteSpecifiedContentNum;
  String? deleteSpecifiedContentMark;
  String? addProgramNameMode;
  String? addProgramNameMak;
  String? isRemoveSpacesMode;
  String? addClampStatusMode;
  String? clampCloseMark;
  String? clampRelaxMark;
  String? addPrgLineNumNode;
  String? macBlowMode;
  String? macBlowTime;
  String? macBlowAheadLine;
  String? beforePrgCalibrationKnifeAddMode;
  String? beforePrgCalibrationKnifeTarget;
  String? beforePrgCalibrationKnifeFlag;
  String? beforePrgCalibrationKnifeMark;
  String? beforePrgCalibrationKnifePos;
  String? afterPrgCalibrationKnifeAddMode;
  String? afterPrgCalibrationKnifeTarget;
  String? afterPrgCalibrationKnifeFlag;
  String? changeToolCmd;
  String? afterPrgCalibrationKnifeMark;
  String? afterPrgCalibrationKnifePos;
  String? splitBallChuckResultCoordinateX;
  String? splitBallChuckResultCoordinateY;
  String? splitBallChuckResultCoordinateZ;
  String? splitBallChuckResultCoordinateU;
  String? spAccuracyRange;
  String? splitBallChuckCoordinateX;
  String? splitBallChuckCoordinateY;
  String? splitBallChuckCoordinateZ;
  String? splitBallChuckCoordinateU;
  String? steelPosBallMark;
  String? flatnessChuckCoordinationX;
  String? flatnessChuckCoordinationY;
  String? flatnessChuckCoordinationZ;
  String? flatnessChuckCoordinationU;
  String? flatnessChuckAccuracyRange;
  String? referenceToMacHeadSpace;
  String? distanceFromTubingToMacX;
  String? distanceFromTubingToMacY;
  String? distanceFromTubingToMacZ;
  String? distanceFromTubingToMacU;
  String? pumpingFaultDistance;
  String? upperChuckHeight;
  String? lowerChuckHeight;
  String? g54CoordinateZ;
  String? chuckZeroCoordinateZ;
  String? chuckCenterCoordinateX;
  String? chuckCenterCoordinateY;
  String? chuckCenterCoordinateZ;
  String? chuckCenterCoordinateU;
  String? macOilLiftPumpMode;
  String? macOilLiftPumpMark;
  String? macEscapeChineName;
  String? macMonitorId;
  String? eAtmMacDataCollectRange;

  MacInfo(
      {required this.section,
      this.machineNum,
      this.serviceAddr,
      this.servicePort,
      this.serviceMonitorPort,
      this.machineUser,
      this.machinePassowrd,
      this.machineName,
      this.macSystemType,
      this.macSystemVersion,
      this.macBrand,
      this.machineAxes,
      this.machineType,
      this.chuckNum,
      this.macProcessLimit,
      this.cncPrgCallMode,
      this.macDefaultConnect,
      this.srcPrgServerNodeName,
      this.srcPrgLocalNodeName,
      this.execPrgServerNodeName,
      this.execPrgLocalNodeName,
      this.outPutNodeName,
      this.mainPrgUpMode,
      this.subPrgUpMode,
      this.subUpPrgNumbarMode,
      this.macMainPrgPath,
      this.macSubPrgPath,
      this.mainPrgName,
      this.macFirstSubPrgName,
      this.macOriginPrgName,
      this.fileExtension,
      this.cleanPrgName,
      this.cleanChuckPrgName,
      this.steelPosBallPrgName,
      this.orginAbsoluteType,
      this.orginAbsoluteX,
      this.orginAbsoluteY,
      this.orginAbsoluteZ,
      this.orginAbsoluteU,
      this.orginAbsoluteW,
      this.macPosX,
      this.macPosY,
      this.macPosZ,
      this.macPosU,
      this.macPosA,
      this.macPosW,
      this.macOriginPrgNameInfo,
      this.autoOfflineType,
      this.macFenceDoorExistMark,
      this.machineAheadTask,
      this.machineAheadLine,
      this.macExceptionHandle,
      this.macFinishNotToCleanMac,
      this.macStartWaitTime,
      this.chuckScanJustAnyone,
      this.isAutoMachineOnline,
      this.workSteelAbalmIsPutDown,
      this.abnormalairIsOffLineMac,
      this.autoDoor,
      this.openDoorComm,
      this.closeDoorComm,
      this.ftpAddr,
      this.ftpPort,
      this.ftpUser,
      this.ftpPwd,
      this.ftpCodeType,
      this.ftpTransferType,
      this.ftpPath,
      this.ftpRootDir,
      this.toolMagazineSize,
      this.macExistToolManagement,
      this.toolOpenPermissionMark,
      this.mainPrgFinishMark,
      this.subPrgFinishMark,
      this.useQieXyAndTieXcRecordMark,
      this.macMergerProgramMark,
      this.macCloseDoorPrgName,
      this.toolLifeOverflowOffineMark,
      this.workTimeLowerLimit,
      this.macCleanToolPrgName,
      this.macReadAxesMacroMark,
      this.isWriteAxesMacroToSqlDB,
      this.readMacroPosX,
      this.readMacroPosY,
      this.readMacroPosZ,
      this.macReadRotateMacroMark,
      this.isWriteRotateMacroToSqlDB,
      this.readRotateMacroPos,
      this.rotateOffsetAddMode,
      this.rotateOffsetAddPos,
      this.copyCmmResultMark,
      this.readMacroStartPos,
      this.macCmmCheckPosMacroPos,
      this.macCmmResultMacroPos,
      this.cmmResultFilePathPos,
      this.steelCheckPrgName,
      this.copyMacCheckResultFileMark,
      this.onMacCheckResultFilePath,
      this.cmmResultName,
      this.macUseOutToolMark,
      this.macOutToolUsedToolNum,
      this.changeToolName,
      this.extServerConnectMak,
      this.extServiceAddr,
      this.extServicePort,
      this.aheadTaskMonitorFolder,
      this.zeissStartFileFolder,
      this.zeissConnectMode,
      this.cmmDriveMode,
      this.macWaitFinishTime,
      this.edmMoreSteelTask,
      this.oilTankReserve,
      this.oilGrooveCtrlType,
      this.modifyInfoAddPositionMode,
      this.mainPrgTopInsertMark,
      this.mainPrgGoOrginAddMode,
      this.subPrgTopInsertMark,
      this.subPrgGoOrginAddMode,
      this.eactUnitePrg,
      this.machineMarkCode,
      this.subInsertDoorCtrlMode,
      this.elecHeightAddMode,
      this.steelSetOffAddMode,
      this.steelSetOffAddPos,
      this.offsetStartMark,
      this.offsetEndMark,
      this.macOrgionInterceptStartMark,
      this.macOrgionInterceptEndMark,
      this.macOrgoinInsertMark,
      this.repSpecifiedContentMode,
      this.repSpecifiedContentStartNum,
      this.repSpecifiedContentNum,
      this.repSpecifiedContentOldMark,
      this.repSpecifiedContentNewMark,
      this.rotatCoordinateAddMode,
      this.rotatCoordinateAddNum,
      this.rotatCoordinateMark,
      this.rotatCoordinateFlag,
      this.returnRotatCoordinateMode,
      this.returnRotatCoordinateNum,
      this.returnRotatCoordinateMark,
      this.returnRotatCoordinateFlag,
      this.toolReplaceMode,
      this.toolReplaceStyle,
      this.toolHReplaceMode,
      this.toolHReplaceStyle,
      this.delTopAddMode,
      this.delTopMark,
      this.delTopToolNums,
      this.killTopPrgName,
      this.checkCoordSystem,
      this.killToolDiameter,
      this.killToolWidth,
      this.killToolHight,
      this.zCorrectionValueMode,
      this.szZCorrectionValueMark,
      this.zCorrectionMargin,
      this.chuckCoordZValue,
      this.subPrgFinishReplaceMode,
      this.subPrgFinishReplaceMark,
      this.coordinatePeplaceMode,
      this.coordinatePeplaceNum,
      this.coordinatePeplaceMark,
      this.deleteSpecifiedContentMode,
      this.deleteSpecifiedContentNum,
      this.deleteSpecifiedContentMark,
      this.addProgramNameMode,
      this.addProgramNameMak,
      this.isRemoveSpacesMode,
      this.addClampStatusMode,
      this.clampCloseMark,
      this.clampRelaxMark,
      this.addPrgLineNumNode,
      this.macBlowMode,
      this.macBlowTime,
      this.macBlowAheadLine,
      this.beforePrgCalibrationKnifeAddMode,
      this.beforePrgCalibrationKnifeTarget,
      this.beforePrgCalibrationKnifeFlag,
      this.beforePrgCalibrationKnifeMark,
      this.beforePrgCalibrationKnifePos,
      this.afterPrgCalibrationKnifeAddMode,
      this.afterPrgCalibrationKnifeTarget,
      this.afterPrgCalibrationKnifeFlag,
      this.changeToolCmd,
      this.afterPrgCalibrationKnifeMark,
      this.afterPrgCalibrationKnifePos,
      this.splitBallChuckResultCoordinateX,
      this.splitBallChuckResultCoordinateY,
      this.splitBallChuckResultCoordinateZ,
      this.splitBallChuckResultCoordinateU,
      this.spAccuracyRange,
      this.splitBallChuckCoordinateX,
      this.splitBallChuckCoordinateY,
      this.splitBallChuckCoordinateZ,
      this.splitBallChuckCoordinateU,
      this.steelPosBallMark,
      this.flatnessChuckCoordinationX,
      this.flatnessChuckCoordinationY,
      this.flatnessChuckCoordinationZ,
      this.flatnessChuckCoordinationU,
      this.flatnessChuckAccuracyRange,
      this.referenceToMacHeadSpace,
      this.distanceFromTubingToMacX,
      this.distanceFromTubingToMacY,
      this.distanceFromTubingToMacZ,
      this.distanceFromTubingToMacU,
      this.pumpingFaultDistance,
      this.upperChuckHeight,
      this.lowerChuckHeight,
      this.g54CoordinateZ,
      this.chuckZeroCoordinateZ,
      this.chuckCenterCoordinateX,
      this.chuckCenterCoordinateY,
      this.chuckCenterCoordinateZ,
      this.chuckCenterCoordinateU,
      this.macOilLiftPumpMode,
      this.macOilLiftPumpMark,
      this.macEscapeChineName,
      this.macMonitorId,
      this.eAtmMacDataCollectRange});

  MacInfo.fromSectionJson(Map<String, dynamic> json, this.section) {
    machineNum = json['$section/MachineNum'];
    serviceAddr = json['$section/ServiceAddr'];
    servicePort = json['$section/ServicePort'];
    serviceMonitorPort = json['$section/ServiceMonitorPort'];
    machineUser = json['$section/MachineUser'];
    machinePassowrd = json['$section/MachinePassowrd'];
    machineName = json['$section/MachineName'];
    macSystemType = json['$section/MacSystemType'];
    macSystemVersion = json['$section/MacSystemVersion'];
    macBrand = json['$section/MacBrand'];
    machineAxes = json['$section/MachineAxes'];
    machineType = json['$section/MachineType'];
    chuckNum = json['$section/ChuckNum'];
    macProcessLimit = json['$section/MacProcessLimit'];
    cncPrgCallMode = json['$section/CncPrgCallMode'];
    macDefaultConnect = json['$section/MacDefaultConnect'];
    srcPrgServerNodeName = json['$section/SrcPrgServerNodeName'];
    srcPrgLocalNodeName = json['$section/SrcPrgLocalNodeName'];
    execPrgServerNodeName = json['$section/ExecPrgServerNodeName'];
    execPrgLocalNodeName = json['$section/ExecPrgLocalNodeName'];
    outPutNodeName = json['$section/OutPutNodeName'];
    mainPrgUpMode = json['$section/MainPrgUpMode'];
    subPrgUpMode = json['$section/SubPrgUpMode'];
    subUpPrgNumbarMode = json['$section/SubUpPrgNumbarMode'];
    macMainPrgPath = json['$section/MacMainPrgPath'];
    macSubPrgPath = json['$section/MacSubPrgPath'];
    mainPrgName = json['$section/MainPrgName'];
    macFirstSubPrgName = json['$section/MacFirstSubPrgName'];
    macOriginPrgName = json['$section/MacOriginPrgName'];
    fileExtension = json['$section/FileExtension'];
    cleanPrgName = json['$section/CleanPrgName'];
    cleanChuckPrgName = json['$section/CleanChuckPrgName'];
    steelPosBallPrgName = json['$section/SteelPosBallPrgName'];
    orginAbsoluteType = json['$section/OrginAbsoluteType'];
    orginAbsoluteX = json['$section/OrginAbsoluteX'];
    orginAbsoluteY = json['$section/OrginAbsoluteY'];
    orginAbsoluteZ = json['$section/OrginAbsoluteZ'];
    orginAbsoluteU = json['$section/OrginAbsoluteU'];
    orginAbsoluteW = json['$section/OrginAbsoluteW'];
    macPosX = json['$section/MacPosX'];
    macPosY = json['$section/MacPosY'];
    macPosZ = json['$section/MacPosZ'];
    macPosU = json['$section/MacPosU'];
    macPosA = json['$section/MacPosA'];
    macPosW = json['$section/MacPosW'];
    macOriginPrgNameInfo = json['$section/MacOriginPrgNameInfo'];
    autoOfflineType = json['$section/AutoOfflineType'];
    macFenceDoorExistMark = json['$section/MacFenceDoorExistMark'];
    machineAheadTask = json['$section/MachineAheadTask'];
    machineAheadLine = json['$section/MachineAheadLine'];
    macExceptionHandle = json['$section/MacExceptionHandle'];
    macFinishNotToCleanMac = json['$section/MacFinishNotToCleanMac'];
    macStartWaitTime = json['$section/MacStartWaitTime'];
    chuckScanJustAnyone = json['$section/ChuckScanJustAnyone'];
    isAutoMachineOnline = json['$section/IsAutoMachineOnline'];
    workSteelAbalmIsPutDown = json['$section/WorkSteelAbalmIsPutDown'];
    abnormalairIsOffLineMac = json['$section/AbnormalairIsOffLineMac'];
    autoDoor = json['$section/AutoDoor'];
    openDoorComm = json['$section/OpenDoorComm'];
    closeDoorComm = json['$section/CloseDoorComm'];
    ftpAddr = json['$section/FtpAddr'];
    ftpPort = json['$section/FtpPort'];
    ftpUser = json['$section/FtpUser'];
    ftpPwd = json['$section/FtpPwd'];
    ftpCodeType = json['$section/FtpCodeType'];
    ftpTransferType = json['$section/FtpTransferType'];
    ftpPath = json['$section/FtpPath'];
    ftpRootDir = json['$section/FtpRootDir'];
    toolMagazineSize = json['$section/ToolMagazineSize'];
    macExistToolManagement = json['$section/MacExistToolManagement'];
    toolOpenPermissionMark = json['$section/ToolOpenPermissionMark'];
    mainPrgFinishMark = json['$section/MainPrgFinishMark'];
    subPrgFinishMark = json['$section/SubPrgFinishMark'];
    useQieXyAndTieXcRecordMark = json['$section/UseQieXyAndTieXcRecordMark'];
    macMergerProgramMark = json['$section/MacMergerProgramMark'];
    macCloseDoorPrgName = json['$section/MacCloseDoorPrgName'];
    toolLifeOverflowOffineMark = json['$section/ToolLifeOverflowOffineMark'];
    workTimeLowerLimit = json['$section/WorkTimeLowerLimit'];
    macCleanToolPrgName = json['$section/MacCleanToolPrgName'];
    macReadAxesMacroMark = json['$section/MacReadAxesMacroMark'];
    isWriteAxesMacroToSqlDB = json['$section/IsWriteAxesMacroToSqlDB'];
    readMacroPosX = json['$section/ReadMacroPosX'];
    readMacroPosY = json['$section/ReadMacroPosY'];
    readMacroPosZ = json['$section/ReadMacroPosZ'];
    macReadRotateMacroMark = json['$section/MacReadRotateMacroMark'];
    isWriteRotateMacroToSqlDB = json['$section/IsWriteRotateMacroToSqlDB'];
    readRotateMacroPos = json['$section/ReadRotateMacroPos'];
    rotateOffsetAddMode = json['$section/RotateOffsetAddMode'];
    rotateOffsetAddPos = json['$section/RotateOffsetAddPos'];
    copyCmmResultMark = json['$section/CopyCmmResultMark'];
    readMacroStartPos = json['$section/ReadMacroStartPos'];
    macCmmCheckPosMacroPos = json['$section/MacCmmCheckPosMacroPos'];
    macCmmResultMacroPos = json['$section/MacCmmResultMacroPos'];
    cmmResultFilePathPos = json['$section/CmmResultFilePathPos'];
    steelCheckPrgName = json['$section/SteelCheckPrgName'];
    copyMacCheckResultFileMark = json['$section/CopyMacCheckResultFileMark'];
    onMacCheckResultFilePath = json['$section/OnMacCheckResultFilePath'];
    cmmResultName = json['$section/CmmResultName'];
    macUseOutToolMark = json['$section/MacUseOutToolMark'];
    macOutToolUsedToolNum = json['$section/MacOutToolUsedToolNum'];
    changeToolName = json['$section/ChangeToolName'];
    extServerConnectMak = json['$section/ExtServerConnectMak'];
    extServiceAddr = json['$section/ExtServiceAddr'];
    extServicePort = json['$section/ExtServicePort'];
    aheadTaskMonitorFolder = json['$section/AheadTaskMonitorFolder'];
    zeissStartFileFolder = json['$section/ZeissStartFileFolder'];
    zeissConnectMode = json['$section/ZeissConnectMode'];
    cmmDriveMode = json['$section/CmmDriveMode'];
    macWaitFinishTime = json['$section/MacWaitFinishTime'];
    edmMoreSteelTask = json['$section/EdmMoreSteelTask'];
    oilTankReserve = json['$section/OilTankReserve'];
    oilGrooveCtrlType = json['$section/OilGrooveCtrlType'];
    modifyInfoAddPositionMode = json['$section/ModifyInfoAddPositionMode'];
    mainPrgTopInsertMark = json['$section/MainPrgTopInsertMark'];
    mainPrgGoOrginAddMode = json['$section/MainPrgGoOrginAddMode'];
    subPrgTopInsertMark = json['$section/SubPrgTopInsertMark'];
    subPrgGoOrginAddMode = json['$section/SubPrgGoOrginAddMode'];
    eactUnitePrg = json['$section/EactUnitePrg'];
    machineMarkCode = json['$section/MachineMarkCode'];
    subInsertDoorCtrlMode = json['$section/SubInsertDoorCtrlMode'];
    elecHeightAddMode = json['$section/ElecHeightAddMode'];
    steelSetOffAddMode = json['$section/SteelSetOffAddMode'];
    steelSetOffAddPos = json['$section/SteelSetOffAddPos'];
    offsetStartMark = json['$section/OffsetStartMark'];
    offsetEndMark = json['$section/OffsetEndMark'];
    macOrgionInterceptStartMark = json['$section/MacOrgionInterceptStartMark'];
    macOrgionInterceptEndMark = json['$section/MacOrgionInterceptEndMark'];
    macOrgoinInsertMark = json['$section/MacOrgoinInsertMark'];
    repSpecifiedContentMode = json['$section/RepSpecifiedContentMode'];
    repSpecifiedContentStartNum = json['$section/RepSpecifiedContentStartNum'];
    repSpecifiedContentNum = json['$section/RepSpecifiedContentNum'];
    repSpecifiedContentOldMark = json['$section/RepSpecifiedContentOldMark'];
    repSpecifiedContentNewMark = json['$section/RepSpecifiedContentNewMark'];
    rotatCoordinateAddMode = json['$section/RotatCoordinateAddMode'];
    rotatCoordinateAddNum = json['$section/RotatCoordinateAddNum'];
    rotatCoordinateMark = json['$section/RotatCoordinateMark'];
    rotatCoordinateFlag = json['$section/RotatCoordinateFlag'];
    returnRotatCoordinateMode = json['$section/ReturnRotatCoordinateMode'];
    returnRotatCoordinateNum = json['$section/ReturnRotatCoordinateNum'];
    returnRotatCoordinateMark = json['$section/ReturnRotatCoordinateMark'];
    returnRotatCoordinateFlag = json['$section/ReturnRotatCoordinateFlag'];
    toolReplaceMode = json['$section/ToolReplaceMode'];
    toolReplaceStyle = json['$section/ToolReplaceStyle'];
    toolHReplaceMode = json['$section/Tool_H_ReplaceMode'];
    toolHReplaceStyle = json['$section/Tool_H_ReplaceStyle'];
    delTopAddMode = json['$section/DelTopAddMode'];
    delTopMark = json['$section/DelTopMark'];
    delTopToolNums = json['$section/DelTopToolNums'];
    killTopPrgName = json['$section/KillTopPrgName'];
    checkCoordSystem = json['$section/CheckCoordSystem'];
    killToolDiameter = json['$section/KillToolDiameter'];
    killToolWidth = json['$section/KillToolWidth'];
    killToolHight = json['$section/KillToolHight'];
    zCorrectionValueMode = json['$section/ZCorrectionValueMode'];
    szZCorrectionValueMark = json['$section/szZCorrectionValueMark'];
    zCorrectionMargin = json['$section/ZCorrectionMargin'];
    chuckCoordZValue = json['$section/ChuckCoordZValue'];
    subPrgFinishReplaceMode = json['$section/SubPrgFinishReplaceMode'];
    subPrgFinishReplaceMark = json['$section/SubPrgFinishReplaceMark'];
    coordinatePeplaceMode = json['$section/CoordinatePeplaceMode'];
    coordinatePeplaceNum = json['$section/CoordinatePeplaceNum'];
    coordinatePeplaceMark = json['$section/CoordinatePeplaceMark'];
    deleteSpecifiedContentMode = json['$section/DeleteSpecifiedContentMode'];
    deleteSpecifiedContentNum = json['$section/DeleteSpecifiedContentNum'];
    deleteSpecifiedContentMark = json['$section/DeleteSpecifiedContentMark'];
    addProgramNameMode = json['$section/AddProgramNameMode'];
    addProgramNameMak = json['$section/AddProgramNameMak'];
    isRemoveSpacesMode = json['$section/IsRemoveSpacesMode'];
    addClampStatusMode = json['$section/AddClampStatusMode'];
    clampCloseMark = json['$section/ClampCloseMark'];
    clampRelaxMark = json['$section/ClampRelaxMark'];
    addPrgLineNumNode = json['$section/AddPrgLineNumNode'];
    macBlowMode = json['$section/MacBlowMode'];
    macBlowTime = json['$section/MacBlowTime'];
    macBlowAheadLine = json['$section/MacBlowAheadLine'];
    beforePrgCalibrationKnifeAddMode =
        json['$section/BeforePrgCalibrationKnifeAddMode'];
    beforePrgCalibrationKnifeTarget =
        json['$section/BeforePrgCalibrationKnifeTarget'];
    beforePrgCalibrationKnifeFlag =
        json['$section/BeforePrgCalibrationKnifeFlag'];
    beforePrgCalibrationKnifeMark =
        json['$section/BeforePrgCalibrationKnifeMark'];
    beforePrgCalibrationKnifePos =
        json['$section/BeforePrgCalibrationKnifePos'];
    afterPrgCalibrationKnifeAddMode =
        json['$section/AfterPrgCalibrationKnifeAddMode'];
    afterPrgCalibrationKnifeTarget =
        json['$section/AfterPrgCalibrationKnifeTarget'];
    afterPrgCalibrationKnifeFlag =
        json['$section/AfterPrgCalibrationKnifeFlag'];
    changeToolCmd = json['$section/ChangeToolCmd'];
    afterPrgCalibrationKnifeMark =
        json['$section/AfterPrgCalibrationKnifeMark'];
    afterPrgCalibrationKnifePos = json['$section/AfterPrgCalibrationKnifePos'];
    splitBallChuckResultCoordinateX =
        json['$section/SplitBallChuckResultCoordinateX'];
    splitBallChuckResultCoordinateY =
        json['$section/SplitBallChuckResultCoordinateY'];
    splitBallChuckResultCoordinateZ =
        json['$section/SplitBallChuckResultCoordinateZ'];
    splitBallChuckResultCoordinateU =
        json['$section/SplitBallChuckResultCoordinateU'];
    spAccuracyRange = json['$section/SpAccuracyRange'];
    splitBallChuckCoordinateX = json['$section/SplitBallChuckCoordinateX'];
    splitBallChuckCoordinateY = json['$section/SplitBallChuckCoordinateY'];
    splitBallChuckCoordinateZ = json['$section/SplitBallChuckCoordinateZ'];
    splitBallChuckCoordinateU = json['$section/SplitBallChuckCoordinateU'];
    steelPosBallMark = json['$section/SteelPosBallMark'];
    flatnessChuckCoordinationX = json['$section/FlatnessChuckCoordinationX'];
    flatnessChuckCoordinationY = json['$section/FlatnessChuckCoordinationY'];
    flatnessChuckCoordinationZ = json['$section/FlatnessChuckCoordinationZ'];
    flatnessChuckCoordinationU = json['$section/FlatnessChuckCoordinationU'];
    flatnessChuckAccuracyRange = json['$section/FlatnessChuckAccuracyRange'];
    referenceToMacHeadSpace = json['$section/ReferenceToMacHeadSpace'];
    distanceFromTubingToMacX = json['$section/DistanceFromTubingToMacX'];
    distanceFromTubingToMacY = json['$section/DistanceFromTubingToMacY'];
    distanceFromTubingToMacZ = json['$section/DistanceFromTubingToMacZ'];
    distanceFromTubingToMacU = json['$section/DistanceFromTubingToMacU'];
    pumpingFaultDistance = json['$section/PumpingFaultDistance'];
    upperChuckHeight = json['$section/UpperChuckHeight'];
    lowerChuckHeight = json['$section/LowerChuckHeight'];
    g54CoordinateZ = json['$section/G54CoordinateZ'];
    chuckZeroCoordinateZ = json['$section/ChuckZeroCoordinateZ'];
    chuckCenterCoordinateX = json['$section/ChuckCenterCoordinateX'];
    chuckCenterCoordinateY = json['$section/ChuckCenterCoordinateY'];
    chuckCenterCoordinateZ = json['$section/ChuckCenterCoordinateZ'];
    chuckCenterCoordinateU = json['$section/ChuckCenterCoordinateU'];
    macOilLiftPumpMode = json['$section/MacOilLiftPumpMode'];
    macOilLiftPumpMark = json['$section/MacOilLiftPumpMark'];
    macEscapeChineName = json['$section/MacEscapeChineName'];
    macMonitorId = json['$section/MacMonitorId'];
    eAtmMacDataCollectRange = json['$section/EAtmMacDataCollectRange'];
  }

  Map<String, dynamic> toSectionMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$section/MachineNum'] = this.machineNum;
    data['$section/ServiceAddr'] = this.serviceAddr;
    data['$section/ServicePort'] = this.servicePort;
    data['$section/ServiceMonitorPort'] = this.serviceMonitorPort;
    data['$section/MachineUser'] = this.machineUser;
    data['$section/MachinePassowrd'] = this.machinePassowrd;
    data['$section/MachineName'] = this.machineName;
    data['$section/MacSystemType'] = this.macSystemType;
    data['$section/MacSystemVersion'] = this.macSystemVersion;
    data['$section/MacBrand'] = this.macBrand;
    data['$section/MachineAxes'] = this.machineAxes;
    data['$section/MachineType'] = this.machineType;
    data['$section/ChuckNum'] = this.chuckNum;
    data['$section/MacProcessLimit'] = this.macProcessLimit;
    data['$section/CncPrgCallMode'] = this.cncPrgCallMode;
    data['$section/MacDefaultConnect'] = this.macDefaultConnect;
    data['$section/SrcPrgServerNodeName'] = this.srcPrgServerNodeName;
    data['$section/SrcPrgLocalNodeName'] = this.srcPrgLocalNodeName;
    data['$section/ExecPrgServerNodeName'] = this.execPrgServerNodeName;
    data['$section/ExecPrgLocalNodeName'] = this.execPrgLocalNodeName;
    data['$section/OutPutNodeName'] = this.outPutNodeName;
    data['$section/MainPrgUpMode'] = this.mainPrgUpMode;
    data['$section/SubPrgUpMode'] = this.subPrgUpMode;
    data['$section/SubUpPrgNumbarMode'] = this.subUpPrgNumbarMode;
    data['$section/MacMainPrgPath'] = this.macMainPrgPath;
    data['$section/MacSubPrgPath'] = this.macSubPrgPath;
    data['$section/MainPrgName'] = this.mainPrgName;
    data['$section/MacFirstSubPrgName'] = this.macFirstSubPrgName;
    data['$section/MacOriginPrgName'] = this.macOriginPrgName;
    data['$section/FileExtension'] = this.fileExtension;
    data['$section/CleanPrgName'] = this.cleanPrgName;
    data['$section/CleanChuckPrgName'] = this.cleanChuckPrgName;
    data['$section/SteelPosBallPrgName'] = this.steelPosBallPrgName;
    data['$section/OrginAbsoluteType'] = this.orginAbsoluteType;
    data['$section/OrginAbsoluteX'] = this.orginAbsoluteX;
    data['$section/OrginAbsoluteY'] = this.orginAbsoluteY;
    data['$section/OrginAbsoluteZ'] = this.orginAbsoluteZ;
    data['$section/OrginAbsoluteU'] = this.orginAbsoluteU;
    data['$section/OrginAbsoluteW'] = this.orginAbsoluteW;
    data['$section/MacPosX'] = this.macPosX;
    data['$section/MacPosY'] = this.macPosY;
    data['$section/MacPosZ'] = this.macPosZ;
    data['$section/MacPosU'] = this.macPosU;
    data['$section/MacPosA'] = this.macPosA;
    data['$section/MacPosW'] = this.macPosW;
    data['$section/MacOriginPrgNameInfo'] = this.macOriginPrgNameInfo;
    data['$section/AutoOfflineType'] = this.autoOfflineType;
    data['$section/MacFenceDoorExistMark'] = this.macFenceDoorExistMark;
    data['$section/MachineAheadTask'] = this.machineAheadTask;
    data['$section/MachineAheadLine'] = this.machineAheadLine;
    data['$section/MacExceptionHandle'] = this.macExceptionHandle;
    data['$section/MacFinishNotToCleanMac'] = this.macFinishNotToCleanMac;
    data['$section/MacStartWaitTime'] = this.macStartWaitTime;
    data['$section/ChuckScanJustAnyone'] = this.chuckScanJustAnyone;
    data['$section/IsAutoMachineOnline'] = this.isAutoMachineOnline;
    data['$section/WorkSteelAbalmIsPutDown'] = this.workSteelAbalmIsPutDown;
    data['$section/AbnormalairIsOffLineMac'] = this.abnormalairIsOffLineMac;
    data['$section/AutoDoor'] = this.autoDoor;
    data['$section/OpenDoorComm'] = this.openDoorComm;
    data['$section/CloseDoorComm'] = this.closeDoorComm;
    data['$section/FtpAddr'] = this.ftpAddr;
    data['$section/FtpPort'] = this.ftpPort;
    data['$section/FtpUser'] = this.ftpUser;
    data['$section/FtpPwd'] = this.ftpPwd;
    data['$section/FtpCodeType'] = this.ftpCodeType;
    data['$section/FtpTransferType'] = this.ftpTransferType;
    data['$section/FtpPath'] = this.ftpPath;
    data['$section/FtpRootDir'] = this.ftpRootDir;
    data['$section/ToolMagazineSize'] = this.toolMagazineSize;
    data['$section/MacExistToolManagement'] = this.macExistToolManagement;
    data['$section/ToolOpenPermissionMark'] = this.toolOpenPermissionMark;
    data['$section/MainPrgFinishMark'] = this.mainPrgFinishMark;
    data['$section/SubPrgFinishMark'] = this.subPrgFinishMark;
    data['$section/UseQieXyAndTieXcRecordMark'] =
        this.useQieXyAndTieXcRecordMark;
    data['$section/MacMergerProgramMark'] = this.macMergerProgramMark;
    data['$section/MacCloseDoorPrgName'] = this.macCloseDoorPrgName;
    data['$section/ToolLifeOverflowOffineMark'] =
        this.toolLifeOverflowOffineMark;
    data['$section/WorkTimeLowerLimit'] = this.workTimeLowerLimit;
    data['$section/MacCleanToolPrgName'] = this.macCleanToolPrgName;
    data['$section/MacReadAxesMacroMark'] = this.macReadAxesMacroMark;
    data['$section/IsWriteAxesMacroToSqlDB'] = this.isWriteAxesMacroToSqlDB;
    data['$section/ReadMacroPosX'] = this.readMacroPosX;
    data['$section/ReadMacroPosY'] = this.readMacroPosY;
    data['$section/ReadMacroPosZ'] = this.readMacroPosZ;
    data['$section/MacReadRotateMacroMark'] = this.macReadRotateMacroMark;
    data['$section/IsWriteRotateMacroToSqlDB'] = this.isWriteRotateMacroToSqlDB;
    data['$section/ReadRotateMacroPos'] = this.readRotateMacroPos;
    data['$section/RotateOffsetAddMode'] = this.rotateOffsetAddMode;
    data['$section/RotateOffsetAddPos'] = this.rotateOffsetAddPos;
    data['$section/CopyCmmResultMark'] = this.copyCmmResultMark;
    data['$section/ReadMacroStartPos'] = this.readMacroStartPos;
    data['$section/MacCmmCheckPosMacroPos'] = this.macCmmCheckPosMacroPos;
    data['$section/MacCmmResultMacroPos'] = this.macCmmResultMacroPos;
    data['$section/CmmResultFilePathPos'] = this.cmmResultFilePathPos;
    data['$section/SteelCheckPrgName'] = this.steelCheckPrgName;
    data['$section/CopyMacCheckResultFileMark'] =
        this.copyMacCheckResultFileMark;
    data['$section/OnMacCheckResultFilePath'] = this.onMacCheckResultFilePath;
    data['$section/CmmResultName'] = this.cmmResultName;
    data['$section/MacUseOutToolMark'] = this.macUseOutToolMark;
    data['$section/MacOutToolUsedToolNum'] = this.macOutToolUsedToolNum;
    data['$section/ChangeToolName'] = this.changeToolName;
    data['$section/ExtServerConnectMak'] = this.extServerConnectMak;
    data['$section/ExtServiceAddr'] = this.extServiceAddr;
    data['$section/ExtServicePort'] = this.extServicePort;
    data['$section/AheadTaskMonitorFolder'] = this.aheadTaskMonitorFolder;
    data['$section/ZeissStartFileFolder'] = this.zeissStartFileFolder;
    data['$section/ZeissConnectMode'] = this.zeissConnectMode;
    data['$section/CmmDriveMode'] = this.cmmDriveMode;
    data['$section/MacWaitFinishTime'] = this.macWaitFinishTime;
    data['$section/EdmMoreSteelTask'] = this.edmMoreSteelTask;
    data['$section/OilTankReserve'] = this.oilTankReserve;
    data['$section/OilGrooveCtrlType'] = this.oilGrooveCtrlType;
    data['$section/ModifyInfoAddPositionMode'] = this.modifyInfoAddPositionMode;
    data['$section/MainPrgTopInsertMark'] = this.mainPrgTopInsertMark;
    data['$section/MainPrgGoOrginAddMode'] = this.mainPrgGoOrginAddMode;
    data['$section/SubPrgTopInsertMark'] = this.subPrgTopInsertMark;
    data['$section/SubPrgGoOrginAddMode'] = this.subPrgGoOrginAddMode;
    data['$section/EactUnitePrg'] = this.eactUnitePrg;
    data['$section/MachineMarkCode'] = this.machineMarkCode;
    data['$section/SubInsertDoorCtrlMode'] = this.subInsertDoorCtrlMode;
    data['$section/ElecHeightAddMode'] = this.elecHeightAddMode;
    data['$section/SteelSetOffAddMode'] = this.steelSetOffAddMode;
    data['$section/SteelSetOffAddPos'] = this.steelSetOffAddPos;
    data['$section/OffsetStartMark'] = this.offsetStartMark;
    data['$section/OffsetEndMark'] = this.offsetEndMark;
    data['$section/MacOrgionInterceptStartMark'] =
        this.macOrgionInterceptStartMark;
    data['$section/MacOrgionInterceptEndMark'] = this.macOrgionInterceptEndMark;
    data['$section/MacOrgoinInsertMark'] = this.macOrgoinInsertMark;
    data['$section/RepSpecifiedContentMode'] = this.repSpecifiedContentMode;
    data['$section/RepSpecifiedContentStartNum'] =
        this.repSpecifiedContentStartNum;
    data['$section/RepSpecifiedContentNum'] = this.repSpecifiedContentNum;
    data['$section/RepSpecifiedContentOldMark'] =
        this.repSpecifiedContentOldMark;
    data['$section/RepSpecifiedContentNewMark'] =
        this.repSpecifiedContentNewMark;
    data['$section/RotatCoordinateAddMode'] = this.rotatCoordinateAddMode;
    data['$section/RotatCoordinateAddNum'] = this.rotatCoordinateAddNum;
    data['$section/RotatCoordinateMark'] = this.rotatCoordinateMark;
    data['$section/RotatCoordinateFlag'] = this.rotatCoordinateFlag;
    data['$section/ReturnRotatCoordinateMode'] = this.returnRotatCoordinateMode;
    data['$section/ReturnRotatCoordinateNum'] = this.returnRotatCoordinateNum;
    data['$section/ReturnRotatCoordinateMark'] = this.returnRotatCoordinateMark;
    data['$section/ReturnRotatCoordinateFlag'] = this.returnRotatCoordinateFlag;
    data['$section/ToolReplaceMode'] = this.toolReplaceMode;
    data['$section/ToolReplaceStyle'] = this.toolReplaceStyle;
    data['$section/Tool_H_ReplaceMode'] = this.toolHReplaceMode;
    data['$section/Tool_H_ReplaceStyle'] = this.toolHReplaceStyle;
    data['$section/DelTopAddMode'] = this.delTopAddMode;
    data['$section/DelTopMark'] = this.delTopMark;
    data['$section/DelTopToolNums'] = this.delTopToolNums;
    data['$section/KillTopPrgName'] = this.killTopPrgName;
    data['$section/CheckCoordSystem'] = this.checkCoordSystem;
    data['$section/KillToolDiameter'] = this.killToolDiameter;
    data['$section/KillToolWidth'] = this.killToolWidth;
    data['$section/KillToolHight'] = this.killToolHight;
    data['$section/ZCorrectionValueMode'] = this.zCorrectionValueMode;
    data['$section/szZCorrectionValueMark'] = this.szZCorrectionValueMark;
    data['$section/ZCorrectionMargin'] = this.zCorrectionMargin;
    data['$section/ChuckCoordZValue'] = this.chuckCoordZValue;
    data['$section/SubPrgFinishReplaceMode'] = this.subPrgFinishReplaceMode;
    data['$section/SubPrgFinishReplaceMark'] = this.subPrgFinishReplaceMark;
    data['$section/CoordinatePeplaceMode'] = this.coordinatePeplaceMode;
    data['$section/CoordinatePeplaceNum'] = this.coordinatePeplaceNum;
    data['$section/CoordinatePeplaceMark'] = this.coordinatePeplaceMark;
    data['$section/DeleteSpecifiedContentMode'] =
        this.deleteSpecifiedContentMode;
    data['$section/DeleteSpecifiedContentNum'] = this.deleteSpecifiedContentNum;
    data['$section/DeleteSpecifiedContentMark'] =
        this.deleteSpecifiedContentMark;
    data['$section/AddProgramNameMode'] = this.addProgramNameMode;
    data['$section/AddProgramNameMak'] = this.addProgramNameMak;
    data['$section/IsRemoveSpacesMode'] = this.isRemoveSpacesMode;
    data['$section/AddClampStatusMode'] = this.addClampStatusMode;
    data['$section/ClampCloseMark'] = this.clampCloseMark;
    data['$section/ClampRelaxMark'] = this.clampRelaxMark;
    data['$section/AddPrgLineNumNode'] = this.addPrgLineNumNode;
    data['$section/MacBlowMode'] = this.macBlowMode;
    data['$section/MacBlowTime'] = this.macBlowTime;
    data['$section/MacBlowAheadLine'] = this.macBlowAheadLine;
    data['$section/BeforePrgCalibrationKnifeAddMode'] =
        this.beforePrgCalibrationKnifeAddMode;
    data['$section/BeforePrgCalibrationKnifeTarget'] =
        this.beforePrgCalibrationKnifeTarget;
    data['$section/BeforePrgCalibrationKnifeFlag'] =
        this.beforePrgCalibrationKnifeFlag;
    data['$section/BeforePrgCalibrationKnifeMark'] =
        this.beforePrgCalibrationKnifeMark;
    data['$section/BeforePrgCalibrationKnifePos'] =
        this.beforePrgCalibrationKnifePos;
    data['$section/AfterPrgCalibrationKnifeAddMode'] =
        this.afterPrgCalibrationKnifeAddMode;
    data['$section/AfterPrgCalibrationKnifeTarget'] =
        this.afterPrgCalibrationKnifeTarget;
    data['$section/AfterPrgCalibrationKnifeFlag'] =
        this.afterPrgCalibrationKnifeFlag;
    data['$section/ChangeToolCmd'] = this.changeToolCmd;
    data['$section/AfterPrgCalibrationKnifeMark'] =
        this.afterPrgCalibrationKnifeMark;
    data['$section/AfterPrgCalibrationKnifePos'] =
        this.afterPrgCalibrationKnifePos;
    data['$section/SplitBallChuckResultCoordinateX'] =
        this.splitBallChuckResultCoordinateX;
    data['$section/SplitBallChuckResultCoordinateY'] =
        this.splitBallChuckResultCoordinateY;
    data['$section/SplitBallChuckResultCoordinateZ'] =
        this.splitBallChuckResultCoordinateZ;
    data['$section/SplitBallChuckResultCoordinateU'] =
        this.splitBallChuckResultCoordinateU;
    data['$section/SpAccuracyRange'] = this.spAccuracyRange;
    data['$section/SplitBallChuckCoordinateX'] = this.splitBallChuckCoordinateX;
    data['$section/SplitBallChuckCoordinateY'] = this.splitBallChuckCoordinateY;
    data['$section/SplitBallChuckCoordinateZ'] = this.splitBallChuckCoordinateZ;
    data['$section/SplitBallChuckCoordinateU'] = this.splitBallChuckCoordinateU;
    data['$section/SteelPosBallMark'] = this.steelPosBallMark;
    data['$section/FlatnessChuckCoordinationX'] =
        this.flatnessChuckCoordinationX;
    data['$section/FlatnessChuckCoordinationY'] =
        this.flatnessChuckCoordinationY;
    data['$section/FlatnessChuckCoordinationZ'] =
        this.flatnessChuckCoordinationZ;
    data['$section/FlatnessChuckCoordinationU'] =
        this.flatnessChuckCoordinationU;
    data['$section/FlatnessChuckAccuracyRange'] =
        this.flatnessChuckAccuracyRange;
    data['$section/ReferenceToMacHeadSpace'] = this.referenceToMacHeadSpace;
    data['$section/DistanceFromTubingToMacX'] = this.distanceFromTubingToMacX;
    data['$section/DistanceFromTubingToMacY'] = this.distanceFromTubingToMacY;
    data['$section/DistanceFromTubingToMacZ'] = this.distanceFromTubingToMacZ;
    data['$section/DistanceFromTubingToMacU'] = this.distanceFromTubingToMacU;
    data['$section/PumpingFaultDistance'] = this.pumpingFaultDistance;
    data['$section/UpperChuckHeight'] = this.upperChuckHeight;
    data['$section/LowerChuckHeight'] = this.lowerChuckHeight;
    data['$section/G54CoordinateZ'] = this.g54CoordinateZ;
    data['$section/ChuckZeroCoordinateZ'] = this.chuckZeroCoordinateZ;
    data['$section/ChuckCenterCoordinateX'] = this.chuckCenterCoordinateX;
    data['$section/ChuckCenterCoordinateY'] = this.chuckCenterCoordinateY;
    data['$section/ChuckCenterCoordinateZ'] = this.chuckCenterCoordinateZ;
    data['$section/ChuckCenterCoordinateU'] = this.chuckCenterCoordinateU;
    data['$section/MacOilLiftPumpMode'] = this.macOilLiftPumpMode;
    data['$section/MacOilLiftPumpMark'] = this.macOilLiftPumpMark;
    data['$section/MacEscapeChineName'] = this.macEscapeChineName;
    data['$section/MacMonitorId'] = this.macMonitorId;
    data['$section/EAtmMacDataCollectRange'] = this.eAtmMacDataCollectRange;
    return data;
  }
}
