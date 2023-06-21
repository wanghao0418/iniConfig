import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';

class AcquisitionDatabaseController extends GetxController {
  AcquisitionDatabaseController();
  AcquisitionDatabase acquisitionDatabase = AcquisitionDatabase();
  List<RenderFieldInfo> menuList = [
    RenderFieldInfo(
      field: 'DBType',
      section: 'RomoteDataBaseInfo',
      name: '数据库类型',
      renderType: RenderType.select,
      options: {
        "SQLSERVER": "SQLSERVER",
        "MARIADB": "MARIADB",
      },
    ),
    RenderFieldInfo(
      field: 'OdbcName',
      section: 'RomoteDataBaseInfo',
      name: 'Windows ODBC时使用的连接名称',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'DataSource',
      section: 'RomoteDataBaseInfo',
      name: '数据库连接IP',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'UserID',
      section: 'RomoteDataBaseInfo',
      name: '数据库的用户名',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'Password',
      section: 'RomoteDataBaseInfo',
      name: '数据库的密码',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'SqlPort',
      section: 'RomoteDataBaseInfo',
      name: '数据库端口',
      renderType: RenderType.input,
    ),
    // RenderFieldInfo(
    //   field: 'UseDbXml',
    //   section: 'DataBaseInfo',
    //   name: '标志查询 xml',
    //   renderType: RenderType.radio,
    //   options: {"查询数据库表": "0", "查询xml文件": "1"},
    // ),
  ];

  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  String? getFieldValue(String field) {
    return acquisitionDatabase.toJson()[field];
  }

  void setFieldValue(String field, String val) {
    var temp = acquisitionDatabase.toJson();
    temp[field] = val;
    acquisitionDatabase = AcquisitionDatabase.fromJson(temp);
  }

  _makeParams() {
    List<Map<String, dynamic>> params = [];
    for (var element in changedList) {
      params.add({"key": element, "value": getFieldValue(element)});
    }
    return params;
  }

  // 通用的修改字段方法
  onFieldChange(String field, String val) {
    if (getFieldValue(field) == val) {
      return;
    }
    if (!changedList.contains(field)) {
      changedList.add(field);
    }
    setFieldValue(field, val);
    update(["acquisition_database"]);
  }

  _initData() {
    update(["acquisition_database"]);
  }

  void save() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

class AcquisitionDatabase {
  String? romoteDataBaseInfoDBType;
  String? romoteDataBaseInfoOdbcName;
  String? romoteDataBaseInfoDataSource;
  String? romoteDataBaseInfoSqlPort;
  String? romoteDataBaseInfoUserID;
  String? romoteDataBaseInfoPassword;

  AcquisitionDatabase(
      {this.romoteDataBaseInfoDBType,
      this.romoteDataBaseInfoOdbcName,
      this.romoteDataBaseInfoDataSource,
      this.romoteDataBaseInfoSqlPort,
      this.romoteDataBaseInfoUserID,
      this.romoteDataBaseInfoPassword});

  AcquisitionDatabase.fromJson(Map<String, dynamic> json) {
    romoteDataBaseInfoDBType = json['RomoteDataBaseInfo/DBType'];
    romoteDataBaseInfoOdbcName = json['RomoteDataBaseInfo/OdbcName'];
    romoteDataBaseInfoDataSource = json['RomoteDataBaseInfo/DataSource'];
    romoteDataBaseInfoSqlPort = json['RomoteDataBaseInfo/SqlPort'];
    romoteDataBaseInfoUserID = json['RomoteDataBaseInfo/UserID'];
    romoteDataBaseInfoPassword = json['RomoteDataBaseInfo/Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RomoteDataBaseInfo/DBType'] = this.romoteDataBaseInfoDBType;
    data['RomoteDataBaseInfo/OdbcName'] = this.romoteDataBaseInfoOdbcName;
    data['RomoteDataBaseInfo/DataSource'] = this.romoteDataBaseInfoDataSource;
    data['RomoteDataBaseInfo/SqlPort'] = this.romoteDataBaseInfoSqlPort;
    data['RomoteDataBaseInfo/UserID'] = this.romoteDataBaseInfoUserID;
    data['RomoteDataBaseInfo/Password'] = this.romoteDataBaseInfoPassword;
    return data;
  }
}
