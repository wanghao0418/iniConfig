/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-14 17:08:48
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-14 17:11:44
 * @FilePath: /eatm_ini_config/lib/common/api/database.dart
 * @Description: 数据库设置相关接口
 */
import 'package:iniConfig/common/utils/http.dart';

class DatabaseApi {
  // 字段查询
  static Future<ResponseApiBody> databaseFieldQuery(data) async {
    ResponseApiBody responseBodyApi =
        await HttpUtil.post('/Eatm/iniConfig/dataBase/query', data: data);
    return responseBodyApi;
  }

  // 字段修改
  static Future<ResponseApiBody> databaseFieldUpdate(data) async {
    ResponseApiBody responseBodyApi =
        await HttpUtil.post('/Eatm/iniConfig/dataBase/update', data: data);
    return responseBodyApi;
  }
}
