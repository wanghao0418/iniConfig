/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-13 11:34:05
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-15 17:31:30
 * @FilePath: /eatm_ini_config/lib/pages/setting/store_settings/database/database_connection/controller.dart
 * @Description: 连接设置 控制器
 */
import 'package:get/get.dart';
import 'package:iniConfig/common/utils/http.dart';

import '../../../../../common/api/database.dart';
import '../../../../../common/components/field_change.dart';
import '../../../../../common/utils/popup_message.dart';

class DatabaseConnectionController extends GetxController {
  DatabaseConnectionController();
  DatabaseConnection databaseConnection = DatabaseConnection();
  List<RenderFieldInfo> renderList = [
    RenderFieldInfo(
      field: 'DBType',
      section: 'DataBaseInfo',
      name: '数据库类型',
      renderType: RenderType.select,
      options: {
        "SQLSERVER": "SQLSERVER",
        "MYSQL": "MYSQL",
        "QSQLITE": "QSQLITE",
      },
    ),
    RenderFieldInfo(
      field: 'OdbcName',
      section: 'DataBaseInfo',
      name: 'Windows ODBC时使用的连接名称',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'DataSource',
      section: 'DataBaseInfo',
      name: '数据库连接IP',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'UserID',
      section: 'DataBaseInfo',
      name: '数据库的用户名',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'Password',
      section: 'DataBaseInfo',
      name: '数据库的密码',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'SqlPort',
      section: 'DataBaseInfo',
      name: '数据库端口',
      renderType: RenderType.input,
    ),
    RenderFieldInfo(
      field: 'UseDbXml',
      section: 'DataBaseInfo',
      name: '标志查询 xml',
      renderType: RenderType.radio,
      options: {"查询数据库表": "0", "查询xml文件": "1"},
    ),
  ];
  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  query() async {
    ResponseApiBody res = await DatabaseApi.databaseFieldQuery({
      "params": databaseConnection.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      databaseConnection = DatabaseConnection.fromJson(res.data);
      update(["database_connection"]);
    } else {
      // 保存失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 保存
  save() async {
    // 组装传参
    List<Map<String, dynamic>> params = _makeParams();
    print(params);
    ResponseApiBody res =
        await DatabaseApi.databaseFieldUpdate({"params": params});
    if (res.success == true) {
      // 保存成功
      changedList.clear();
      PopupMessage.showSuccessInfoBar('保存成功');
      update(["database_connection"]);
    } else {
      // 保存失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  String? getFieldValue(String field) {
    return databaseConnection.toJson()[field];
  }

  void setFieldValue(String field, String val) {
    var temp = databaseConnection.toJson();
    temp[field] = val;
    databaseConnection = DatabaseConnection.fromJson(temp);
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
    update(["database_connection"]);
  }

  _initData() {
    update(["database_connection"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    query();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

class DatabaseConnection {
  String? dataBaseInfoDBType;
  String? dataBaseInfoOdbcName;
  String? dataBaseInfoDataSource;
  String? dataBaseInfoUserID;
  String? dataBaseInfoPassword;
  String? dataBaseInfoSqlPort;
  String? dataBaseInfoUseDbXml;

  DatabaseConnection(
      {this.dataBaseInfoDBType,
      this.dataBaseInfoOdbcName,
      this.dataBaseInfoDataSource,
      this.dataBaseInfoUserID,
      this.dataBaseInfoPassword,
      this.dataBaseInfoSqlPort,
      this.dataBaseInfoUseDbXml});

  DatabaseConnection.fromJson(Map<String, dynamic> json) {
    dataBaseInfoDBType = json['DataBaseInfo/DBType'];
    dataBaseInfoOdbcName = json['DataBaseInfo/OdbcName'];
    dataBaseInfoDataSource = json['DataBaseInfo/DataSource'];
    dataBaseInfoUserID = json['DataBaseInfo/UserID'];
    dataBaseInfoPassword = json['DataBaseInfo/Password'];
    dataBaseInfoSqlPort = json['DataBaseInfo/SqlPort'];
    dataBaseInfoUseDbXml = json['DataBaseInfo/UseDbXml'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DataBaseInfo/DBType'] = this.dataBaseInfoDBType;
    data['DataBaseInfo/OdbcName'] = this.dataBaseInfoOdbcName;
    data['DataBaseInfo/DataSource'] = this.dataBaseInfoDataSource;
    data['DataBaseInfo/UserID'] = this.dataBaseInfoUserID;
    data['DataBaseInfo/Password'] = this.dataBaseInfoPassword;
    data['DataBaseInfo/SqlPort'] = this.dataBaseInfoSqlPort;
    data['DataBaseInfo/UseDbXml'] = this.dataBaseInfoUseDbXml;
    return data;
  }
}


// class DatabaseConnection {
//   Field? dBType;
//   Field? odbcName;
//   Field? dataSource;
//   Field? userID;
//   Field? password;
//   Field? sqlPort;
//   Field? useDbXml;

//   DatabaseConnection(
//       {this.dBType,
//       this.odbcName,
//       this.dataSource,
//       this.userID,
//       this.password,
//       this.sqlPort,
//       this.useDbXml});

//   DatabaseConnection.fromJson(Map<String, dynamic> json) {
//     dBType = json['DBType'] != null ? Field.fromJson(json['DBType']) : null;
//     odbcName =
//         json['OdbcName'] != null ? Field.fromJson(json['OdbcName']) : null;
//     dataSource =
//         json['DataSource'] != null ? Field.fromJson(json['DataSource']) : null;
//     userID = json['UserID'] != null ? Field.fromJson(json['UserID']) : null;
//     password =
//         json['Password'] != null ? Field.fromJson(json['Password']) : null;
//     sqlPort = json['SqlPort'] != null ? Field.fromJson(json['SqlPort']) : null;
//     useDbXml =
//         json['UseDbXml'] != null ? Field.fromJson(json['UseDbXml']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['DBType'] = this.dBType != null ? this.dBType!.toJson() : null;
//     data['OdbcName'] = this.odbcName != null ? this.odbcName!.toJson() : null;
//     data['DataSource'] =
//         this.dataSource != null ? this.dataSource!.toJson() : null;
//     data['UserID'] = this.userID != null ? this.userID!.toJson() : null;
//     data['Password'] = this.password != null ? this.password!.toJson() : null;
//     data['SqlPort'] = this.sqlPort != null ? this.sqlPort!.toJson() : null;
//     data['UseDbXml'] = this.useDbXml != null ? this.useDbXml!.toJson() : null;
//     return data;
//   }

//   String? getValueByKey(String key) {
//     switch (key) {
//       case 'DBType':
//         return dBType?.value;
//       case 'OdbcName':
//         return odbcName?.value;
//       case 'DataSource':
//         return dataSource?.value;
//       case 'UserID':
//         return userID?.value;
//       case 'Password':
//         return password?.value;
//       case 'SqlPort':
//         return sqlPort?.value;
//       case 'UseDbXml':
//         return useDbXml?.value;
//       default:
//         return null;
//     }
//   }

//   void setValueByKey(String key, String value) {
//     switch (key) {
//       case 'DBType':
//         dBType ??= Field();
//         dBType?.value = value;
//         break;
//       case 'OdbcName':
//         odbcName ??= Field();
//         odbcName?.value = value;
//         break;
//       case 'DataSource':
//         dataSource ??= Field();
//         dataSource?.value = value;
//         break;
//       case 'UserID':
//         userID ??= Field();
//         userID?.value = value;
//         break;
//       case 'Password':
//         password ??= Field();
//         password?.value = value;
//         break;
//       case 'SqlPort':
//         sqlPort ??= Field();
//         sqlPort?.value = value;
//         break;
//       case 'UseDbXml':
//         useDbXml ??= Field();
//         useDbXml?.value = value;
//         break;
//       default:
//     }
//   }
// }
