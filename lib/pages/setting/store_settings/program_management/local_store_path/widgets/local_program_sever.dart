/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 13:28:52
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 13:56:17
 * @FilePath: /eatm_ini_config/lib/pages/setting/store_settings/program_management/local_store_path/widgets/local_program_sever.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/style/global_theme.dart';

import '../../../../../../common/api/common.dart';
import '../../../../../../common/components/field_change.dart';
import '../../../../../../common/components/field_group.dart';
import '../../../../../../common/utils/http.dart';
import '../../../../../../common/utils/popup_message.dart';

class LocalProgramSever extends StatefulWidget {
  const LocalProgramSever({Key? key, required this.section}) : super(key: key);
  final String section;
  @override
  _LocalProgramSeverState createState() => _LocalProgramSeverState();
}

class _LocalProgramSeverState extends State<LocalProgramSever> {
  late PrgLocalInfo prgLocalInfo;
  List<RenderField> menuList = [
    RenderFieldInfo(
      field: 'LocalSrcPrgPath',
      section: 'PrgLocalInfo',
      name: "PC端取点文件或未修改过的源加工程式保存路径",
      renderType: RenderType.path,
    ),
    RenderFieldInfo(
      field: 'LocalMainPrgPath',
      section: 'PrgLocalInfo',
      name: "PC端主程序路径",
      renderType: RenderType.path,
    ),
    RenderFieldInfo(
      field: 'LocalSubPrgPath',
      section: 'PrgLocalInfo',
      name: "PC端子程序路径",
      renderType: RenderType.path,
    ),
    RenderFieldInfo(
      field: 'OrginPrgPath',
      section: 'PrgLocalInfo',
      name: "PC端原点程式存放路径",
      renderType: RenderType.path,
    ),
    RenderFieldInfo(
      field: 'KillTopPrgPath',
      section: 'PrgLocalInfo',
      name: "PC端杀顶程序路径",
      renderType: RenderType.path,
    ),
    RenderFieldInfo(
      field: 'EdmTemplatePrgPath',
      section: 'PrgLocalInfo',
      name: "PC端放电模板程序路径",
      renderType: RenderType.path,
    ),
  ];
  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = prgLocalInfo.toSectionMap();
    temp[field] = val;
    prgLocalInfo = PrgLocalInfo.fromSectionJson(temp, widget.section);
  }

  String? getFieldValue(String field) {
    return prgLocalInfo.toSectionMap()[field];
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
      prgLocalInfo = PrgLocalInfo.fromSectionJson(
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
    prgLocalInfo = PrgLocalInfo(section: widget.section);
    initMenu();
    getSectionDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(children: [
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
      ]),
    );
  }
}

class PrgLocalInfo {
  final String section;
  String? localSrcPrgPath;
  String? localMainPrgPath;
  String? localSubPrgPath;
  String? orginPrgPath;
  String? killTopPrgPath;
  String? edmTemplatePrgPath;

  PrgLocalInfo(
      {required this.section,
      this.localSrcPrgPath,
      this.localMainPrgPath,
      this.localSubPrgPath,
      this.orginPrgPath,
      this.killTopPrgPath,
      this.edmTemplatePrgPath});

  PrgLocalInfo.fromJson(Map<String, dynamic> json, this.section) {
    localSrcPrgPath = json['LocalSrcPrgPath'];
    localMainPrgPath = json['LocalMainPrgPath'];
    localSubPrgPath = json['LocalSubPrgPath'];
    orginPrgPath = json['OrginPrgPath'];
    killTopPrgPath = json['KillTopPrgPath'];
    edmTemplatePrgPath = json['EdmTemplatePrgPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LocalSrcPrgPath'] = this.localSrcPrgPath;
    data['LocalMainPrgPath'] = this.localMainPrgPath;
    data['LocalSubPrgPath'] = this.localSubPrgPath;
    data['OrginPrgPath'] = this.orginPrgPath;
    data['KillTopPrgPath'] = this.killTopPrgPath;
    data['EdmTemplatePrgPath'] = this.edmTemplatePrgPath;
    return data;
  }

  Map<String, dynamic> toSectionMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$section/LocalSrcPrgPath'] = this.localSrcPrgPath;
    data['$section/LocalMainPrgPath'] = this.localMainPrgPath;
    data['$section/LocalSubPrgPath'] = this.localSubPrgPath;
    data['$section/OrginPrgPath'] = this.orginPrgPath;
    data['$section/KillTopPrgPath'] = this.killTopPrgPath;
    data['$section/EdmTemplatePrgPath'] = this.edmTemplatePrgPath;
    return data;
  }

  PrgLocalInfo.fromSectionJson(Map<String, dynamic> json, this.section) {
    localSrcPrgPath = json['$section/LocalSrcPrgPath'];
    localMainPrgPath = json['$section/LocalMainPrgPath'];
    localSubPrgPath = json['$section/LocalSubPrgPath'];
    orginPrgPath = json['$section/OrginPrgPath'];
    killTopPrgPath = json['$section/KillTopPrgPath'];
    edmTemplatePrgPath = json['$section/EdmTemplatePrgPath'];
  }
}
