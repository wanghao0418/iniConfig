/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-20 15:46:30
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 15:47:26
 * @FilePath: /iniConfig/lib/common/api/special.dart
 * @Description: 特殊逻辑接口集合
 */
import 'package:iniConfig/common/utils/http.dart';

class SpecialApi {
  // 获取货架限制工艺
  static Future getShelfLimitProcess() async {
    var res = await HttpUtil.get('/Eatm/iniConfig/userConfig/GetProcessLimit');
    return res;
  }
}
