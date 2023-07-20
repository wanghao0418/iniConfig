import 'package:fluent_ui/fluent_ui.dart' hide Tab;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/components/field_change.dart';
import 'package:iniConfig/common/index.dart';
import 'package:iniConfig/common/style/global_theme.dart';
import 'package:iniConfig/pages/setting/device_settings/machine/machine_info/subComponents/chuck_number_info.dart';
import 'package:iniConfig/pages/setting/device_settings/machine/machine_info/subComponents/mac_process_limit.dart';
import 'package:iniConfig/pages/setting/device_settings/machine/machine_info/subComponents/origin_coordinates_setting.dart';
import 'package:iniConfig/pages/setting/device_settings/machine/machine_info/subComponents/origin_program_info.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../../../common/api/common.dart';
import '../../../../../../common/components/field_group.dart';
import '../../../../../../common/utils/http.dart';
import '../../../../../../common/utils/popup_message.dart';
import '../../../../../system/home/widgets/cached_page_view.dart';
import '../../../../../system/home/widgets/fluent_tab.dart';
import 'enum.dart';

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
  // 机床信息
  List<RenderField> macInfoMenuList = [
    RenderFieldInfo(
      field: 'MachineNum',
      section: 'MachineInfo',
      name: "机床号",
      renderType: RenderType.input,
      readOnly: true,
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
      field: 'MachineName',
      section: 'MachineInfo',
      name: "机床名称，不同机床间不能重复",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
        field: 'MacSystemType',
        section: 'MachineInfo',
        name: "机床系统类型",
        readOnly: true,
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
      field: 'MacSystemVersion',
      section: 'MachineInfo',
      name: "机床系统版本",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
        field: 'MacBrand',
        section: 'MachineInfo',
        name: "机床品牌",
        readOnly: true,
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
      field: 'MachineAxes',
      section: 'MachineInfo',
      name: "机床轴数",
      renderType: RenderType.numberInput,
    ),
  ];
  // 自动化相关
  List<RenderField> eatmSettingMenuList = [
    RenderFieldGroup(groupName: "上下料相关", isExpanded: true, children: [
      RenderFieldInfo(
          field: 'MachineType',
          section: 'MachineInfo',
          name: "机床类型",
          renderType: RenderType.select,
          readOnly: true,
          options: {
            "CNC": "CNC",
            "CMM": "CMM",
            "EDM": "EDM",
            "CLEAN": "CLEAN",
            "DRY": "DRY"
          }),
      RenderFieldInfo(
        field: 'ChuckNum',
        section: 'MachineInfo',
        name: "机床卡盘号信息",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
        field: 'MacProcessLimit',
        section: 'MachineInfo',
        name: "机床限制工艺",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
          field: 'CncPrgCallMode',
          section: 'MachineInfo',
          name: "加工机床程序调用模式",
          renderType: RenderType.radio,
          options: {"MAIN": "MAIN", "M198": "M198", "M98": "M98"}),
      RenderFieldInfo(
          field: 'MacDefaultConnect',
          section: 'MachineInfo',
          name: "软件开始时触发",
          renderType: RenderType.select,
          options: {"无": "0", "自动触发上线": "1", "上线后校验钢件是否开料": "2"}),
      RenderFieldInfo(
        field: 'ExecPrgServerNodeName',
        section: 'MachineInfo',
        name: "执行程序服务节点名称",
        renderType: RenderType.choose,
        chooseType: ChooseType.macProgramSource,
      ),
      RenderFieldInfo(
        field: 'ExecPrgLocalNodeName',
        section: 'MachineInfo',
        name: "执行程序本地节点名称",
        renderType: RenderType.choose,
        chooseType: ChooseType.localStorePath,
      ),
      RenderFieldInfo(
          field: 'MainPrgUpMode',
          section: 'MachineInfo',
          name: "主程序上传方式",
          renderType: RenderType.select,
          options: {"无需上传": "0", "FTP上传": "1", "机床共享目录拷贝": "2", "API上传": "3"}),
      RenderFieldInfo(
        field: 'MainPrgName',
        section: 'MachineInfo',
        name: "机床主程序命名",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacMainPrgPath',
        section: 'MachineInfo',
        name: "机床主程式上传路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'FileExtension',
        section: 'MachineInfo',
        name: "机床程序扩展名",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'AutoOfflineType',
        section: 'MachineInfo',
        name: "单个工件加工完后机床下线控制",
        renderType: RenderType.radio,
        options: {
          "不下线": "0",
          "下料后下线": "1",
        },
      ),
      RenderFieldInfo(
        field: 'MacFenceDoorExistMark',
        section: 'MachineInfo',
        name: "机床围栏门存在标志",
        renderType: RenderType.radio,
        options: {
          "其他项目": "0",
          "联塑项目": "1",
        },
      ),
      RenderFieldInfo(
        field: 'MachineAheadTask',
        section: 'MachineInfo',
        name: "提前上料标志",
        renderType: RenderType.radio,
        options: {
          "不提前上料": "0",
          "提前上料": "1",
        },
      ),
      RenderFieldInfo(
        field: 'MachineAheadLine',
        section: 'MachineInfo',
        name: "提前上料的行数或者蔡司提前上料的点数",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: 'MacExceptionHandle',
        section: 'MachineInfo',
        name: "机床异常操作",
        renderType: RenderType.radio,
        options: {
          "异常后暂停": "0",
          "异常后下线,并清空卡盘": "1",
        },
      ),
      RenderFieldInfo(
        field: 'MacFinishNotToCleanMac',
        section: 'MachineInfo',
        name: "机床完成是否上清洗机",
        renderType: RenderType.radio,
        options: {
          "上清洗机": "0",
          "不上清洗机": "1",
        },
      ),
      RenderFieldInfo(
        field: 'MacStartWaitTime',
        section: 'MachineInfo',
        name: "机床启动后等待时长",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: 'ChuckScanJustAnyone',
        section: 'MachineInfo',
        name: "标记初始上料前，机床内的卡盘是否需全部扫描。还是任意扫描某一个卡盘即可。",
        renderType: RenderType.radio,
        options: {
          "默认全部扫描": "0",
          "只扫描一个": "1",
        },
      ),
      RenderFieldInfo(
        field: 'IsAutoMachineOnline',
        section: 'MachineInfo',
        name: "机床上线按钮和软件界面的上线按钮是否关联上线",
        renderType: RenderType.radio,
        options: {
          "不关联": "0",
          "关联": "1",
        },
      ),
    ]),
  ];
  // 加工相关
  List<RenderField> processingMenuList = [
    RenderFieldInfo(
        field: 'SubPrgUpMode',
        section: 'MachineInfo',
        name: "子程序上传方式",
        renderType: RenderType.select,
        options: {"无子程序调用": "0", "FTP上传": "1", "机床共享目录拷贝": "2", "API上传": "3"}),
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
      field: 'MacSubPrgPath',
      section: 'MachineInfo',
      name: "机床子程式上传路径",
      renderType: RenderType.path,
    ),
    RenderFieldInfo(
      field: 'MacFirstSubPrgName',
      section: 'MachineInfo',
      name: "机床子程序命名",
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
        field: 'AutoDoor',
        section: 'MachineInfo',
        name: "自动门",
        renderType: RenderType.radio,
        options: {
          "机床自带自动门": "1",
          "EATM PLC控制": "2",
        }),
    RenderFieldInfo(
      field: 'OpenDoorComm',
      section: 'MachineInfo',
      name: "机床开门M指令",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'CloseDoorComm',
      section: 'MachineInfo',
      name: "机床关门M指令",
      renderType: RenderType.input,
    ),
    RenderFieldGroup(groupName: "FTP信息", children: [
      RenderFieldInfo(
        field: 'FtpAddr',
        section: 'MachineInfo',
        name: "机床FTP服务器IP",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'FtpPort',
        section: 'MachineInfo',
        name: "机床FTP服务器端口",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'FtpUser',
        section: 'MachineInfo',
        name: "机床FTP服务器用户名",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'FtpPwd',
        section: 'MachineInfo',
        name: "机床FTP服务器密码",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'FtpCodeType',
        section: 'MachineInfo',
        name: "机床FTP编码类型",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'FtpTransferType',
        section: 'MachineInfo',
        name: "读取FTP信息所使用的本地编码",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'FtpPath',
        section: 'MachineInfo',
        name: "机床本身FTP服务器程式的默认访问路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'FtpRootDir',
        section: 'MachineInfo',
        name: "机床FTP根目录",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldGroup(groupName: "刀具设置", children: [
      RenderFieldInfo(
        field: 'ToolMagazineSize',
        section: 'MachineInfo',
        name: "刀库上限",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: 'MacExistToolManagement',
        section: 'MachineInfo',
        name: "机床是否存在刀具管理",
        renderType: RenderType.toggleSwitch,
      ),
      RenderFieldInfo(
        field: 'ToolOpenPermissionMark',
        section: 'MachineInfo',
        name: "机床刀具权限 开通标志",
        renderType: RenderType.toggleSwitch,
      ),
      RenderFieldInfo(
        field: 'MacUseOutToolMark',
        section: 'MachineInfo',
        name: "机床使用机外刀库标志",
        renderType: RenderType.toggleSwitch,
      ),
      RenderFieldInfo(
        field: 'MacOutToolUsedToolNum',
        section: 'MachineInfo',
        name: "机外刀具在机内使用的刀具号",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: 'ChangeToolName',
        section: 'MachineInfo',
        name: "换刀程序名称",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'ToolLifeOverflowOffineMark',
          section: 'MachineInfo',
          name: "刀具寿命到期机床离线标志",
          renderType: RenderType.radio,
          options: {"不离线": "0", "离线": "1"}),
      RenderFieldInfo(
        field: 'WorkTimeLowerLimit',
        section: 'MachineInfo',
        name: "工作时间最低限制",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: 'MacCleanToolPrgName',
        section: 'MachineInfo',
        name: "机床清洁刀具程序名称",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldGroup(groupName: "宏变量读取设置", children: [
      RenderFieldInfo(
          field: 'MacReadAxesMacroMark',
          section: 'MachineInfo',
          name: "读取机床轴的宏变量标志",
          renderType: RenderType.radio,
          options: {"不读取": "0", "读取": "1"}),
      RenderFieldInfo(
        field: 'IsWriteAxesMacroToSqlDB',
        section: 'MachineInfo',
        name: "是否将轴宏变量写入数据库",
        renderType: RenderType.toggleSwitch,
      ),
      RenderFieldInfo(
        field: 'ReadMacroPosX',
        section: 'MachineInfo',
        name: "X方向偏移量位置",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: 'ReadMacroPosY',
        section: 'MachineInfo',
        name: "Y方向偏移量位置",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: 'ReadMacroPosZ',
        section: 'MachineInfo',
        name: "Z方向偏移量位置",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
          field: 'MacReadRotateMacroMark',
          section: 'MachineInfo',
          name: "读取机床旋转的宏变量标志",
          renderType: RenderType.radio,
          options: {"不读取": "0", "读取": "1"}),
      RenderFieldInfo(
        field: 'IsWriteRotateMacroToSqlDB',
        section: 'MachineInfo',
        name: "是否将旋转宏变量写入数据库",
        renderType: RenderType.toggleSwitch,
      ),
      RenderFieldInfo(
        field: 'ReadRotateMacroPos',
        section: 'MachineInfo',
        name: "R方向(旋转)偏移量位置",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: 'RotateOffsetAddMode',
        section: 'MachineInfo',
        name: "是否添加旋转角度偏移量",
        renderType: RenderType.select,
        options: {"不添加": "0", "必须添加(无数据则报错)": "1", "自动添加(有数据则添加，无数据则不添加)": "2"},
      ),
      RenderFieldInfo(
        field: 'RotateOffsetAddPos',
        section: 'MachineInfo',
        name: "添加位置",
        renderType: RenderType.select,
        options: {"插入至标识文本上方": "1", "插入至标识文本下方": "2"},
      ),
    ]),
    RenderFieldGroup(groupName: "在机检测相关配置", children: [
      RenderFieldInfo(
          field: 'CopyCmmResultMark',
          section: 'MachineInfo',
          name: "检测结果是否需要拷贝到服务器",
          renderType: RenderType.radio,
          options: {"不拷贝": "0", "拷贝至服务器": "1"}),
      RenderFieldInfo(
        field: 'ReadMacroStartPos',
        section: 'MachineInfo',
        name: "读取 检测点开始 宏变量位置",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
          field: 'MacCmmCheckPosMacroPos',
          section: 'MachineInfo',
          name: "读取宏变量检测点位置",
          renderType: RenderType.customMultipleChoice,
          splitKey: '&'),
      RenderFieldInfo(
        field: 'MacCmmResultMacroPos',
        section: 'MachineInfo',
        name: "读取 检测结果 宏变量位置",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
          field: 'CmmResultFilePathPos',
          section: 'MachineInfo',
          name: "检测结果文件路径位置",
          renderType: RenderType.select,
          options: {"机床主程序路径（一汽，EAct生成）": "0", "机床本地Src路径（铸造，EAtm生成）": "1"}),
      RenderFieldInfo(
        field: 'SteelCheckPrgName',
        section: 'MachineInfo',
        name: "钢件在机检测程序名",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'CopyMacCheckResultFileMark',
        section: 'MachineInfo',
        name: "在机检测结果文件是否拷贝",
        renderType: RenderType.toggleSwitch,
      ),
      RenderFieldInfo(
        field: 'OnMacCheckResultFilePath',
        section: 'MachineInfo',
        name: "在机检测结果文件路径",
        renderType: RenderType.path,
      ),
      RenderFieldInfo(
        field: 'CmmResultName',
        section: 'MachineInfo',
        name: "在机检测结果文件名称",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldGroup(groupName: "程序修改", children: [
      RenderFieldSubTitle(title: "机床G代码，M代码"),
      RenderFieldInfo(
        field: 'MainPrgFinishMark',
        section: 'MachineInfo',
        name: "主程序结束标志",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'SubPrgFinishMark',
        section: 'MachineInfo',
        name: "子程序结束标志",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'UseQieXyAndTieXcRecordMark',
          section: 'MachineInfo',
          name: "启用切削液和铁屑槽记录的标志",
          renderType: RenderType.radio,
          options: {"不启用": "0", "启用": "1"}),
      RenderFieldInfo(
          field: 'MacMergerProgramMark',
          section: 'MachineInfo',
          name: "机床合并程序",
          renderType: RenderType.radio,
          options: {"不合并": "0", "合并": "1"}),
      RenderFieldInfo(
        field: 'MacCloseDoorPrgName',
        section: 'MachineInfo',
        name: "机床关门程序名称",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'BeforePrgCalibrationKnifeAddMode',
          section: 'MachineInfo',
          name: "序前对刀开关",
          renderType: RenderType.radio,
          options: {"不需要": "0", "需要": "1"}),
      RenderFieldInfo(
        field: 'BeforePrgCalibrationKnifeTarget',
        section: 'MachineInfo',
        name: "序前对刀目标，0/NULL:所有，具体值：具体刀具",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'BeforePrgCalibrationKnifeFlag',
        section: 'MachineInfo',
        name: "序前对刀标志位",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'BeforePrgCalibrationKnifeMark',
        section: 'MachineInfo',
        name: "序前对刀 所需要添加的程序",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'BeforePrgCalibrationKnifePos',
          section: 'MachineInfo',
          name: "序前对刀程序添加位置",
          renderType: RenderType.radio,
          options: {"不添加": "0", "上方": "1", "下方": "2"}),
      RenderFieldInfo(
          field: 'AfterPrgCalibrationKnifeAddMode',
          section: 'MachineInfo',
          name: "序后对刀开关",
          renderType: RenderType.radio,
          options: {"不需要": "0", "需要": "1"}),
      RenderFieldInfo(
        field: 'AfterPrgCalibrationKnifeTarget',
        section: 'MachineInfo',
        name: "序后对刀目标，0/NULL:所有，具体值：具体刀具",
        renderType: RenderType.customMultipleChoice,
        splitKey: ',',
      ),
      RenderFieldInfo(
        field: 'AfterPrgCalibrationKnifeFlag',
        section: 'MachineInfo',
        name: "序后对刀标志位",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'AfterPrgCalibrationKnifeMark',
        section: 'MachineInfo',
        name: "序前对刀 所需要添加的程序",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'AfterPrgCalibrationKnifePos',
          section: 'MachineInfo',
          name: "序后对刀程序添加位置",
          renderType: RenderType.radio,
          options: {"不添加": "0", "上方": "1", "下方": "2"}),
      RenderFieldInfo(
          field: 'ToolReplaceMode',
          section: 'MachineInfo',
          name: "刀具替换标识",
          renderType: RenderType.radio,
          options: {"不替换": "0", "替换": "1"}),
      RenderFieldInfo(
        field: 'ToolReplaceStyle',
        section: 'MachineInfo',
        name: "替换样式",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'Tool_H_ReplaceMode',
          section: 'MachineInfo',
          name: "刀补替换模式",
          renderType: RenderType.radio,
          options: {"不替换": "0", "替换": "1"}),
      RenderFieldInfo(
        field: 'Tool_H_ReplaceStyle',
        section: 'MachineInfo',
        name: "刀补替换样式",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'DelTopAddMode',
          section: 'MachineInfo',
          name: "是否需要添加杀顶",
          renderType: RenderType.radio,
          options: {"不添加": "0", "添加": "1"}),
      RenderFieldInfo(
        field: 'DelTopMark',
        section: 'MachineInfo',
        name: "添加杀顶开始文本标志",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'DelTopToolNums',
        section: 'MachineInfo',
        name: "杀顶用到的刀号",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'KillTopPrgName',
        section: 'MachineInfo',
        name: "杀顶头部程序名",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'CheckCoordSystem',
        section: 'MachineInfo',
        name: "卡盘补正坐标系",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'KillToolDiameter',
        section: 'MachineInfo',
        name: "杀顶刀的直径(mm)",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: 'KillToolWidth',
        section: 'MachineInfo',
        name: "杀顶每一刀Y方向或者X方向走的宽度(mm)",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: 'KillToolHight',
        section: 'MachineInfo',
        name: "杀顶Z方向每一刀下的深度[最好带上正负号](mm)",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: 'SubPrgFinishReplaceMode',
        section: 'MachineInfo',
        name: "子程序结尾替换为回到主程序的标志",
        renderType: RenderType.toggleSwitch,
      ),
      RenderFieldInfo(
        field: 'SubPrgFinishReplaceMark',
        section: 'MachineInfo',
        name: "子程序结尾替换为回到主程序的标识文本",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'ModifyInfoAddPositionMode',
          section: 'MachineInfo',
          name: "修改程序内容插入位置",
          renderType: RenderType.radio,
          options: {"主程序": "0", "子程序": "1"}),
      RenderFieldInfo(
        field: 'MainPrgTopInsertMark',
        section: 'MachineInfo',
        name: "主程式顶部插入标识",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'MainPrgGoOrginAddMode',
          section: 'MachineInfo',
          name: "主程序回原点内容添加方式",
          renderType: RenderType.radio,
          options: {"不修改": "0", "插入至MainPrgFinishMark上方": "1"}),
      RenderFieldInfo(
        field: 'SubPrgTopInsertMark',
        section: 'MachineInfo',
        name: "子程式顶部插入标识",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'SubPrgGoOrginAddMode',
          section: 'MachineInfo',
          name: "子程序回原点内容添加方式",
          renderType: RenderType.radio,
          options: {"不修改": "0", "插入至SubPrgCallFinishMark上方": "1"}),
      RenderFieldInfo(
          field: 'SubInsertDoorCtrlMode',
          section: 'MachineInfo',
          name: "子插入门控制模式",
          renderType: RenderType.radio,
          options: {"不添加": "0", "添加": "1"}),
      RenderFieldInfo(
          field: 'ElecHeightAddMode',
          section: 'MachineInfo',
          name: "是否添加电极测高",
          renderType: RenderType.select,
          options: {"不添加": "0", "插入至标识文本上方": "1", "插入至标识文本下方": "2"}),
      RenderFieldInfo(
          field: 'SteelSetOffAddMode',
          section: 'MachineInfo',
          name: "是否添加钢件偏移量",
          renderType: RenderType.select,
          options: {
            "不添加": "0",
            "必须添加(无数据则报错)": "1",
            "自动添加(有数据则添加，无数据则不添加)": "2"
          }),
      RenderFieldInfo(
          field: 'SteelSetOffAddPos',
          section: 'MachineInfo',
          name: "添加位置",
          renderType: RenderType.select,
          options: {
            "插入至标识文本上方": "1",
            "插入至标识文本下方": "2",
          }),
      RenderFieldInfo(
        field: 'OffsetStartMark',
        section: 'MachineInfo',
        name: "偏移量开始添加标识文本",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'OffsetEndMark',
        section: 'MachineInfo',
        name: "偏移量结束添加标识文本",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'RepSpecifiedContentMode',
          section: 'MachineInfo',
          name: "替换程序中指定的内容模式",
          renderType: RenderType.radio,
          options: {
            "不替换": "0",
            "替换": "1",
          }),
      RenderFieldInfo(
        field: 'RepSpecifiedContentStartNum',
        section: 'MachineInfo',
        name: "开始替换的位置(就是从第几个开始替换)",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
          field: 'RepSpecifiedContentNum',
          section: 'MachineInfo',
          name: "替换的次数",
          renderType: RenderType.radio,
          options: {
            "替换一次": "0",
            "全部替换": "1",
          }),
      RenderFieldInfo(
        field: 'RepSpecifiedContentOldMark',
        section: 'MachineInfo',
        name: "需要替换的原始内容",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'RepSpecifiedContentNewMark',
        section: 'MachineInfo',
        name: "需要替换的新内容",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'RotatCoordinateAddMode',
          section: 'MachineInfo',
          name: "程序添加坐标旋转模式",
          renderType: RenderType.radio,
          options: {
            "添加标识之前": "1",
            "添加标识之后": "2",
          }),
      RenderFieldInfo(
          field: 'RotatCoordinateAddNum',
          section: 'MachineInfo',
          name: "程序添加坐标旋转次数",
          renderType: RenderType.radio,
          options: {
            "添加一次": "0",
            "所有标识处全部添加": "1",
          }),
      RenderFieldInfo(
        field: 'RotatCoordinateMark',
        section: 'MachineInfo',
        name: "程序坐标旋转添加文本",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'RotatCoordinateFlag',
        section: 'MachineInfo',
        name: "程序坐标旋转标识文本",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'ReturnRotatCoordinateMode',
          section: 'MachineInfo',
          name: "程序取消坐标旋转模式",
          renderType: RenderType.radio,
          options: {
            "取消标识之前": "1",
            "取消标识之后": "2",
          }),
      RenderFieldInfo(
          field: 'ReturnRotatCoordinateNum',
          section: 'MachineInfo',
          name: "程序取消坐标旋转次数",
          renderType: RenderType.radio,
          options: {
            "取消一次": "0",
            "所有标识处全部取消": "1",
          }),
      RenderFieldInfo(
        field: 'ReturnRotatCoordinateMark',
        section: 'MachineInfo',
        name: "程序坐标旋转取消添加文本",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ReturnRotatCoordinateFlag',
        section: 'MachineInfo',
        name: "程序坐标旋转取消标识文本",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ZCorrectionValueMode',
        section: 'MachineInfo',
        name: "卡盘Z方向补正值添加标识",
        renderType: RenderType.toggleSwitch,
      ),
      RenderFieldInfo(
        field: 'szZCorrectionValueMark',
        section: 'MachineInfo',
        name: "卡盘Z方向补正添加标识文本",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ZCorrectionMargin',
        section: 'MachineInfo',
        name: "补正余量",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ChuckCoordZValue',
        section: 'MachineInfo',
        name: "卡盘Z值",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'CoordinatePeplaceMode',
          section: 'MachineInfo',
          name: "坐标系替换标志",
          renderType: RenderType.select,
          options: {"不替换": "0", "替换为配置 ChuckNum 里面的坐标系名称（对于单卡盘）": "1"}),
      RenderFieldInfo(
          field: 'CoordinatePeplaceNum',
          section: 'MachineInfo',
          name: "坐标替换次数",
          renderType: RenderType.radio,
          options: {"只替换一次": "0", "全部替换": "1"}),
      RenderFieldInfo(
        field: 'CoordinatePeplaceMark',
        section: 'MachineInfo',
        name: "坐标系替换文本，程序里面原来的坐标系名称",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'DeleteSpecifiedContentMode',
          section: 'MachineInfo',
          name: "删除程序中的指定内容标志",
          renderType: RenderType.radio,
          options: {"不删除": "0", "删除": "1"}),
      RenderFieldInfo(
          field: 'DeleteSpecifiedContentNum',
          section: 'MachineInfo',
          name: "删除程序指定内容的次数",
          renderType: RenderType.radio,
          options: {"删除一次": "0", "删除多次": "1"}),
      RenderFieldInfo(
        field: 'DeleteSpecifiedContentMark',
        section: 'MachineInfo',
        name: "删除程序中的指定内容",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'AddProgramNameMode',
          section: 'MachineInfo',
          name: "程序开头是否加主程序名",
          renderType: RenderType.select,
          options: {"不添加": "0", "添加之前": "1", "添加标志之后": "2"}),
      RenderFieldInfo(
        field: 'AddProgramNameMak',
        section: 'MachineInfo',
        name: "程序名出现%",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'IsRemoveSpacesMode',
          section: 'MachineInfo',
          name: "是否去掉空格",
          renderType: RenderType.radio,
          options: {"不去掉": "0", "去掉": "1"}),
      RenderFieldInfo(
        field: 'AddClampStatusMode',
        section: 'MachineInfo',
        name: "添加夹具状态标志",
        renderType: RenderType.toggleSwitch,
      ),
      RenderFieldInfo(
        field: 'ClampCloseMark',
        section: 'MachineInfo',
        name: "夹具夹紧",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ClampRelaxMark',
        section: 'MachineInfo',
        name: "夹具放松",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'AddPrgLineNumNode',
          section: 'MachineInfo',
          name: "程序添加行号的标志",
          renderType: RenderType.radio,
          options: {"不添加": "0", "添加": "1"}),
      RenderFieldInfo(
          field: 'MacBlowMode',
          section: 'MachineInfo',
          name: "机床吹气的标志",
          renderType: RenderType.select,
          options: {
            "不吹气": "0",
            "电气(PLC)控制吹气(机床加工完成软件控制开始吹气)": "1",
            "按照指定行(程序倒数指定行)开始吹气": "2"
          }),
      RenderFieldInfo(
        field: 'MacBlowTime',
        section: 'MachineInfo',
        name: "吹气时间配置(单位：秒)(吹气时常软件控制)",
        renderType: RenderType.numberInput,
      ),
      RenderFieldInfo(
        field: 'MacBlowAheadLine',
        section: 'MachineInfo',
        name: "机床提前吹气的行数",
        renderType: RenderType.numberInput,
      ),
    ]),
    RenderFieldGroup(groupName: "加工放电相关", children: [
      RenderFieldInfo(
        field: 'SteelPosBallPrgName',
        section: 'MachineInfo',
        name: "钢件分中程序名",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacOriginPrgName',
        section: 'MachineInfo',
        name: "机床原点程式命名",
        renderType: RenderType.input,
      ),
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
        field: 'MacPosX',
        section: 'MachineInfo',
        name: "电极原点坐标X",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
        field: 'MacPosY',
        section: 'MachineInfo',
        name: "电极原点坐标Y",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
        field: 'MacPosZ',
        section: 'MachineInfo',
        name: "电极原点坐标Z",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
        field: 'MacPosU',
        section: 'MachineInfo',
        name: "电极原点坐标U",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
        field: 'MacPosA',
        section: 'MachineInfo',
        name: "电极原点坐标A",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
        field: 'MacPosW',
        section: 'MachineInfo',
        name: "电极原点坐标W",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
        field: 'MacOriginPrgNameInfo',
        section: 'MachineInfo',
        name: "机床原点程序名称信息",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
          field: 'WorkSteelAbalmIsPutDown',
          section: 'MachineInfo',
          name: "钢件异常是否下料",
          renderType: RenderType.radio,
          options: {"不下料": "0", "下料": "1"}),
      RenderFieldInfo(
        field: 'MacOrgionInterceptStartMark',
        section: 'MachineInfo',
        name: "回原点截取开始文本标识",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacOrgionInterceptEndMark',
        section: 'MachineInfo',
        name: "回原点截取结束文本标识",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacOrgoinInsertMark',
        section: 'MachineInfo',
        name: "回原点插入位置文本标志",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'SteelPosBallMark',
          section: 'MachineInfo',
          name: "钢件是否需要分中",
          renderType: RenderType.select,
          options: {
            "不需要分中": "0",
            "需要分中但不需要生成分中程序": "1",
            "需要分中同时需要生成分中程序": "2"
          }),
    ]),
    RenderFieldGroup(groupName: "加工检测相关", children: [
      RenderFieldInfo(
        field: 'SrcPrgServerNodeName',
        section: 'MachineInfo',
        name: "源程序服务节点名称",
        renderType: RenderType.choose,
        chooseType: ChooseType.macProgramSource,
      ),
      RenderFieldInfo(
        field: 'SrcPrgLocalNodeName',
        section: 'MachineInfo',
        name: "源程序本地节点名称",
        renderType: RenderType.choose,
        chooseType: ChooseType.localStorePath,
      ),
    ])
  ];
  // 检测相关
  List<RenderField> detectionMenuList = [
    RenderFieldInfo(
      field: 'OutPutNodeName',
      section: 'MachineInfo',
      name: "执行程序本地节点名称",
      renderType: RenderType.choose,
      chooseType: ChooseType.localStorePath,
    ),
    RenderFieldInfo(
        field: 'ExtServerConnectMak',
        section: 'MachineInfo',
        name: "外部服务器连接标识",
        renderType: RenderType.radio,
        options: {"不需要连接": "0", "需要连接": "1"}),
    RenderFieldInfo(
      field: 'ExtServiceAddr',
      section: 'MachineInfo',
      name: "外部连接服务器IP",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'ExtServicePort',
      section: 'MachineInfo',
      name: "外部连接服务器端口",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'AheadTaskMonitorFolder',
      section: 'MachineInfo',
      name: "提前任务监控文件夹，CMM快检测完成时，eact会在该文件夹下生成txt通知eatm",
      renderType: RenderType.path,
    ),
    RenderFieldInfo(
      field: 'ZeissStartFileFolder',
      section: 'MachineInfo',
      name: "创建蔡司startinfo.txt 启动文件的路径(若不在本机上，则为共享路径)",
      renderType: RenderType.path,
    ),
    RenderFieldInfo(
      field: 'ZeissConnectMode',
      section: 'MachineInfo',
      name: "蔡司连接模式",
      renderType: RenderType.radio,
      options: {"IO模式": "0", "TCP模式": "1"},
    ),
    RenderFieldInfo(
      field: 'CmmDriveMode',
      section: 'MachineInfo',
      name: "仅用于检测机床驱动模式",
      renderType: RenderType.select,
      options: {
        "仅驱动(zeiss)": "1",
        "编程+驱动(hexagon)": "2",
        "EATM仅驱动（展会）": "3",
        "EATM编程+驱动": "4"
      },
    ),
    RenderFieldInfo(
      field: 'MacWaitFinishTime',
      section: 'MachineInfo',
      name: "机床超时未完成检测一个点需要的时间(单位:秒)",
      renderType: RenderType.numberInput,
    ),
    RenderFieldGroup(groupName: "加工检测相关", children: [
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
    ])
  ];
  // 放电相关
  List<RenderField> dischargeMenuList = [
    RenderFieldInfo(
      field: 'OrginAbsoluteW',
      section: 'MachineInfo',
      name: "用于机器人上料时的机床的坐标W",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'MacOilLiftPumpMode',
      section: 'MachineInfo',
      name: "机床添加升油泵标志",
      renderType: RenderType.toggleSwitch,
    ),
    RenderFieldInfo(
      field: 'MacOilLiftPumpMark',
      section: 'MachineInfo',
      name: "机床添加升油泵标识文本",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
        field: 'EdmMoreSteelTask',
        section: 'MachineInfo',
        name: "手动上钢件是否是多钢件连续放电",
        renderType: RenderType.radio,
        options: {"单钢件放完下线": "0", "多钢件连续放电": "1"}),
    RenderFieldInfo(
      field: 'OilTankReserve',
      section: 'MachineInfo',
      name: "油槽上升的预留量,单位:毫米",
      renderType: RenderType.numberInput,
    ),
    RenderFieldInfo(
        field: 'OilGrooveCtrlType',
        section: 'MachineInfo',
        name: "用于火花机油槽的驱动",
        renderType: RenderType.radio,
        options: {"机床自身驱动": "0", "PLC来驱动": "1"}),
    RenderFieldInfo(
      field: 'SpAccuracyRange',
      section: 'MachineInfo',
      name: "分中球精度范围",
      renderType: RenderType.input,
    ),
    RenderFieldGroup(groupName: '分中球校验坐标', children: [
      RenderFieldInfo(
        field: 'SplitBallChuckCoordinateX',
        section: 'MachineInfo',
        name: "分中球卡盘X坐标",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'SplitBallChuckCoordinateY',
        section: 'MachineInfo',
        name: "分中球卡盘Y坐标",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'SplitBallChuckCoordinateZ',
        section: 'MachineInfo',
        name: "分中球卡盘Z坐标",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'SplitBallChuckCoordinateU',
        section: 'MachineInfo',
        name: "分中球卡盘U坐标",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldGroup(groupName: "分中球卡盘结果坐标", children: [
      RenderFieldInfo(
        field: 'SplitBallChuckResultCoordinateX',
        section: 'MachineInfo',
        name: "分中球卡盘结果X坐标",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'SplitBallChuckResultCoordinateY',
        section: 'MachineInfo',
        name: "分中球卡盘结果Y坐标",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'SplitBallChuckResultCoordinateZ',
        section: 'MachineInfo',
        name: "分中球卡盘结果Z坐标",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'SplitBallChuckResultCoordinateU',
        section: 'MachineInfo',
        name: "分中球卡盘结果U坐标",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldGroup(groupName: "平面度检测校验坐标系", children: [
      RenderFieldInfo(
        field: 'FlatnessChuckCoordinationX',
        section: 'MachineInfo',
        name: "平面度卡盘协调X",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'FlatnessChuckCoordinationY',
        section: 'MachineInfo',
        name: "平面度卡盘协调Y",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'FlatnessChuckCoordinationZ',
        section: 'MachineInfo',
        name: "平面度卡盘协调Z",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'FlatnessChuckCoordinationU',
        section: 'MachineInfo',
        name: "平面度卡盘协调U",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldInfo(
      field: 'FlatnessChuckAccuracyRange',
      section: 'MachineInfo',
      name: "平面度检测精度范围",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'ReferenceToMacHeadSpace',
      section: 'MachineInfo',
      name: "基准台上表面~机头零点距离",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'DistanceFromTubingToMacX',
      section: 'MachineInfo',
      name: "吸油管相对于机头的位置X",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'DistanceFromTubingToMacY',
      section: 'MachineInfo',
      name: "吸油管相对于机头的位置Y",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'DistanceFromTubingToMacZ',
      section: 'MachineInfo',
      name: "吸油管相对于机头的位置Z",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'DistanceFromTubingToMacU',
      section: 'MachineInfo',
      name: "吸油管相对于机头的位置U",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'PumpingFaultDistance',
      section: 'MachineInfo',
      name: "抽油下降距离容错空间",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'UpperChuckHeight',
      section: 'MachineInfo',
      name: "上卡盘高度",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'LowerChuckHeight',
      section: 'MachineInfo',
      name: "下卡盘高度",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'G54CoordinateZ',
      section: 'MachineInfo',
      name: "G54坐标Z值",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'ChuckZeroCoordinateZ',
      section: 'MachineInfo',
      name: "卡盘零点Z值",
      renderType: RenderType.input,
    ),
    RenderFieldGroup(groupName: "卡盘中心坐标", children: [
      RenderFieldInfo(
        field: 'ChuckCenterCoordinateX',
        section: 'MachineInfo',
        name: "卡盘中心坐标X",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ChuckCenterCoordinateY',
        section: 'MachineInfo',
        name: "卡盘中心坐标Y",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ChuckCenterCoordinateZ',
        section: 'MachineInfo',
        name: "卡盘中心坐标Z",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'ChuckCenterCoordinateU',
        section: 'MachineInfo',
        name: "卡盘中心坐标U",
        renderType: RenderType.input,
      ),
    ]),
    RenderFieldGroup(groupName: "加工放电相关", children: [
      RenderFieldInfo(
        field: 'SteelPosBallPrgName',
        section: 'MachineInfo',
        name: "钢件分中程序名",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacOriginPrgName',
        section: 'MachineInfo',
        name: "机床原点程式命名",
        renderType: RenderType.input,
      ),
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
        field: 'MacPosX',
        section: 'MachineInfo',
        name: "电极原点坐标X",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
        field: 'MacPosY',
        section: 'MachineInfo',
        name: "电极原点坐标Y",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
        field: 'MacPosZ',
        section: 'MachineInfo',
        name: "电极原点坐标Z",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
        field: 'MacPosU',
        section: 'MachineInfo',
        name: "电极原点坐标U",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
        field: 'MacPosA',
        section: 'MachineInfo',
        name: "电极原点坐标A",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
        field: 'MacPosW',
        section: 'MachineInfo',
        name: "电极原点坐标W",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
        field: 'MacOriginPrgNameInfo',
        section: 'MachineInfo',
        name: "机床原点程序名称信息",
        renderType: RenderType.custom,
      ),
      RenderFieldInfo(
          field: 'WorkSteelAbalmIsPutDown',
          section: 'MachineInfo',
          name: "钢件异常是否下料",
          renderType: RenderType.radio,
          options: {"不下料": "0", "下料": "1"}),
      RenderFieldInfo(
        field: 'MacOrgionInterceptStartMark',
        section: 'MachineInfo',
        name: "回原点截取开始文本标识",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacOrgionInterceptEndMark',
        section: 'MachineInfo',
        name: "回原点截取结束文本标识",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
        field: 'MacOrgoinInsertMark',
        section: 'MachineInfo',
        name: "回原点插入位置文本标志",
        renderType: RenderType.input,
      ),
      RenderFieldInfo(
          field: 'SteelPosBallMark',
          section: 'MachineInfo',
          name: "钢件是否需要分中",
          renderType: RenderType.select,
          options: {
            "不需要分中": "0",
            "需要分中但不需要生成分中程序": "1",
            "需要分中同时需要生成分中程序": "2"
          }),
    ])
  ];

  String get currentMachineType => macInfo.machineType ?? "";

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
    var menuList = [
      macInfoMenuList,
      eatmSettingMenuList,
      processingMenuList,
      detectionMenuList,
      dischargeMenuList
    ];

    for (var menu in menuList) {
      for (var element in menu) {
        if (element is RenderFieldInfo) {
          element.section = widget.section;
        } else if (element is RenderFieldGroup) {
          for (var element in element.children) {
            if (element is RenderFieldInfo) {
              element.section = widget.section;
              if (element.field == 'ChuckNum') {
                element.builder =
                    (context) => _buildChuckNumberInformation(context, element);
              } else if (element.field == 'MacProcessLimit') {
                element.builder =
                    (context) => _buildMacProcessLimit(context, element);
              } else if ([
                'MacPosX',
                'MacPosY',
                'MacPosZ',
                'MacPosU',
                'MacPosA',
                'MacPosW'
              ].contains(element.field)) {
                element.builder =
                    (context) => _buildOriginCoordinates(context, element);
              } else if (element.field == 'MacOriginPrgNameInfo') {
                element.builder =
                    (context) => _buildOriginProgramInfo(context, element);
              }
            }
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
      macInfo =
          MacInfo.fromSectionJson((res.data as List).first, widget.section);
      setState(() {});
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
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
    getSectionDetail();
  }

  _buildRenderField(RenderField info) {
    if (info is RenderFieldGroup) {
      return Container(
        margin: EdgeInsets.only(bottom: 5.r),
        child: FieldGroup(
          isExpanded: info.isExpanded ?? false,
          visible: info.visible ?? true,
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
        readOnly: info.readOnly ?? false,
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
        ),
        if (currentMachineType == MachineType.CNC.value)
          KeyedSubtree(
            key: Key('3'),
            child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(children: [
                    ...processingMenuList
                        .map((e) => _buildRenderField(e))
                        .toList(),
                  ]),
                )),
          ),
        if (currentMachineType == MachineType.CMM.value)
          KeyedSubtree(
            key: Key('4'),
            child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(children: [
                    ...detectionMenuList
                        .map((e) => _buildRenderField(e))
                        .toList(),
                  ]),
                )),
          ),
        if (currentMachineType == MachineType.EDM.value)
          KeyedSubtree(
            key: Key('5'),
            child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(children: [
                    ...dischargeMenuList
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

  // ------ 定制设置组件 ----------------
  // 卡盘号信息设置
  Widget _buildChuckNumberInformation(
      BuildContext context, RenderFieldInfo info) {
    return FilledButton(
        child: const Text('编辑'),
        onPressed: () {
          var _key = GlobalKey();
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  constraints: const BoxConstraints(maxWidth: 500),
                  title: Text('${info.name}').fontSize(24.sp),
                  content: SizedBox(
                    height: 300,
                    child: ChuckNumberInfo(
                      key: _key,
                      showValue: getFieldValue(info.fieldKey) ?? '',
                    ),
                  ),
                  actions: [
                    Button(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消')),
                    FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          var state =
                              _key.currentState! as ChuckNumberInfoState;
                          var value = state.currentValue;
                          onFieldChange(info.fieldKey, value);
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  // 机床限制工艺
  Widget _buildMacProcessLimit(BuildContext context, RenderFieldInfo info) {
    return FilledButton(
        child: const Text('编辑'),
        onPressed: () {
          var _key = GlobalKey();
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  constraints: const BoxConstraints(maxWidth: 800),
                  title: Text('${info.name}').fontSize(24.sp),
                  content: SizedBox(
                    height: 300,
                    child: MacProcessLimit(
                      key: _key,
                      showValue: getFieldValue(info.fieldKey) ?? '',
                    ),
                  ),
                  actions: [
                    Button(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消')),
                    FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          var state =
                              _key.currentState! as MacProcessLimitState;
                          var value = state.currentValue;
                          onFieldChange(info.fieldKey, value);
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  // 原点坐标
  Widget _buildOriginCoordinates(BuildContext context, RenderFieldInfo info) {
    return FilledButton(
        child: const Text('编辑'),
        onPressed: () {
          var _key = GlobalKey();
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  constraints: const BoxConstraints(maxWidth: 500),
                  title: Text('${info.name}').fontSize(24.sp),
                  content: SizedBox(
                    height: 300,
                    child: OriginCoordinatesSetting(
                      key: _key,
                      showValue: getFieldValue(info.fieldKey) ?? '',
                    ),
                  ),
                  actions: [
                    Button(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消')),
                    FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          var state = _key.currentState!
                              as OriginCoordinatesSettingState;
                          var value = state.currentValue;
                          onFieldChange(info.fieldKey, value);
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  // 原点程序名称信息
  Widget _buildOriginProgramInfo(BuildContext context, RenderFieldInfo info) {
    return FilledButton(
        child: const Text('编辑'),
        onPressed: () {
          var _key = GlobalKey();
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  constraints: const BoxConstraints(maxWidth: 500),
                  title: Text('${info.name}').fontSize(24.sp),
                  content: SizedBox(
                    height: 300,
                    child: OriginProgramInfo(
                      key: _key,
                      showValue: getFieldValue(info.fieldKey) ?? '',
                    ),
                  ),
                  actions: [
                    Button(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消')),
                    FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          var state =
                              _key.currentState! as OriginProgramInfoState;
                          var value = state.currentValue;
                          onFieldChange(info.fieldKey, value);
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        // _buildCustomTab(context),
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
                text: Text('自动化相关'),
                body: Container(
                  child: Text('自动化相关'),
                ),
              ),
            if (currentMachineType == MachineType.CNC.value)
              Tab(
                id: '3',
                key: Key('3'),
                text: Text('加工相关'),
                body: Container(
                  child: Text('加工相关'),
                ),
              ),
            if (currentMachineType == MachineType.CMM.value)
              Tab(
                id: '4',
                key: Key('4'),
                text: Text('检测相关'),
                body: Container(
                  child: Text('检测相关'),
                ),
              ),
            if (currentMachineType == MachineType.EDM.value)
              Tab(
                id: '5',
                key: Key('5'),
                text: Text('放电相关'),
                body: Container(
                  child: Text('放电相关'),
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
