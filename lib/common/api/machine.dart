/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-19 09:06:44
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-19 09:07:01
 * @FilePath: /iniConfig/lib/common/api/machine.dart
 * @Description: 机床相关接口
 */
import 'package:iniConfig/common/utils/http.dart';

class MachineApi {
  // 新增机床
  static Future<ResponseApiBody> addMachine(data) async {
    ResponseApiBody responseBodyApi =
        await HttpUtil.post('/Eatm/iniConfig/mac/MachineAdd', data: data);
    return responseBodyApi;
  }
}
