/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-14 17:06:06
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-25 14:24:01
 * @FilePath: /eatm_ini_config/lib/common/api/plc.dart
 * @Description: plc api
 */
import 'package:iniConfig/common/utils/http.dart';

class PlcApi {
  // 字段查询
  static Future<ResponseApiBody> fieldQuery(data) async {
    ResponseApiBody responseBodyApi =
        await HttpUtil.post('/Eatm/iniConfig/plc/query', data: data);
    return responseBodyApi;
  }

  // 字段修改
  static Future<ResponseApiBody> fieldUpdate(data) async {
    ResponseApiBody responseBodyApi =
        await HttpUtil.post('/Eatm/iniConfig/plc/update', data: data);
    return responseBodyApi;
  }
}
