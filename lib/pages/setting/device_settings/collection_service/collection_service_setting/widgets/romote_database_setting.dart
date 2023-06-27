/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-26 20:22:12
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-26 20:31:56
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/collection_service/collection_service_setting/widgets/romote_database_setting.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/api/common.dart';
import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/http.dart';
import '../../../../../../common/utils/popup_message.dart';

class RomoteDatabaseSetting extends StatefulWidget {
  const RomoteDatabaseSetting({Key? key, required this.section})
      : super(key: key);
  final String section;

  @override
  _RomoteDatabaseSettingState createState() => _RomoteDatabaseSettingState();
}

class _RomoteDatabaseSettingState extends State<RomoteDatabaseSetting> {
  late RomoteDataBaseInfo romoteDataBaseInfo;
  List<RenderField> menuList = [
    RenderFieldInfo(
        field: "DBType",
        section: "RomoteDataBaseInfo",
        name: "数据库类型",
        renderType: RenderType.radio,
        options: {
          "SQLSERVER": "SQLSERVER",
          "MariaDB": "MariaDB",
        }),
    RenderFieldInfo(
      field: "OdbcName",
      section: "RomoteDataBaseInfo",
      name: "Odbc名称",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: "DataSource",
      section: "RomoteDataBaseInfo",
      name: "数据源",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: "SqlPort",
      section: "RomoteDataBaseInfo",
      name: "端口",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: "UserID",
      section: "RomoteDataBaseInfo",
      name: "用户名",
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: "Password",
      section: "RomoteDataBaseInfo",
      name: "密码",
      renderType: RenderType.input,
    ),
  ];
  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = romoteDataBaseInfo.toJson();
    temp[field] = val;
    romoteDataBaseInfo = RomoteDataBaseInfo.fromJson(temp, widget.section);
  }

  String? getFieldValue(String field) {
    return romoteDataBaseInfo.toJson()[field];
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
    ResponseApiBody res = await CommonApi.getSectionDetail(widget.section);
    if (res.success == true) {
      romoteDataBaseInfo =
          RomoteDataBaseInfo.fromJson(res.data, widget.section);
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
    ResponseApiBody res = await CommonApi.fieldUpdate(dataList);
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
    romoteDataBaseInfo = RomoteDataBaseInfo(section: widget.section);
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

class RomoteDataBaseInfo {
  String section;
  String? dBType;
  String? odbcName;
  String? dataSource;
  String? sqlPort;
  String? userID;
  String? password;

  RomoteDataBaseInfo(
      {required this.section,
      this.dBType,
      this.odbcName,
      this.dataSource,
      this.sqlPort,
      this.userID,
      this.password});

  RomoteDataBaseInfo.fromJson(Map<String, dynamic> json, this.section) {
    dBType = json['$section/DBType'];
    odbcName = json['$section/OdbcName'];
    dataSource = json['$section/DataSource'];
    sqlPort = json['$section/SqlPort'];
    userID = json['$section/UserID'];
    password = json['$section/Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$section/DBType'] = this.dBType;
    data['$section/OdbcName'] = this.odbcName;
    data['$section/DataSource'] = this.dataSource;
    data['$section/SqlPort'] = this.sqlPort;
    data['$section/UserID'] = this.userID;
    data['$section/Password'] = this.password;
    return data;
  }
}
