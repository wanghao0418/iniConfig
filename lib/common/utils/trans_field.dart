/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-13 17:27:04
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-13 17:34:48
 * @FilePath: /iniConfig/lib/common/utils/trans_field.dart
 */
class TransUtils {
  // 获取翻译节点字段
  static String getTransField(String str, String replaceText) {
    RegExp reg = RegExp(r'[a-zA-Z]+');
    var match = reg.firstMatch(str);
    if (match != null) {
      var matchStr = match.group(0);
      return str.replaceFirst(matchStr!, replaceText);
    }
    return str;
  }
}
