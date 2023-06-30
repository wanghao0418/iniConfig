/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 10:09:31
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-30 09:11:43
 * @FilePath: /eatm_ini_config/lib/pages/setting/store_settings/program_management/mac_program_source/widgets/mac_program_setting.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/components/field_subTitle.dart';

import '../../../../../../common/api/common.dart';
import '../../../../../../common/components/field_change.dart';
import '../../../../../../common/components/field_group.dart';
import '../../../../../../common/utils/http.dart';
import '../../../../../../common/utils/popup_message.dart';

class MacProgramSetting extends StatefulWidget {
  const MacProgramSetting({Key? key, required this.section}) : super(key: key);
  final String section;

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
    RenderFieldInfo(
      field: 'SrcPrgExtern',
      section: 'PrgServerInfo',
      name: "各系统类型对应的服务器上的源程式后缀",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'ExecPrgExtern',
      section: 'PrgServerInfo',
      name: "各系统类型对应的服务器上的执行程式后缀",
      renderType: RenderType.input,
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
      } else if (element is RenderFieldGroup) {
        for (var element in element.children) {
          if (element is RenderFieldInfo) element.section = widget.section;
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
    prgServerInfo = PrgServerInfo(section: widget.section);
    initMenu();
    getSectionDetail();
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
                icon: Icon(FluentIcons.save)),
            CommandBarSeparator(),
            CommandBarButton(
                label: Text('测试'),
                onPressed: save,
                icon: Icon(FluentIcons.test_plan)),
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
                } else {
                  return FieldChange(
                    renderFieldInfo: e as RenderFieldInfo,
                    showValue: getFieldValue(e.fieldKey),
                    isChanged: isChanged(e.fieldKey),
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
