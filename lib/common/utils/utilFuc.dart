/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-19 09:40:37
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-19 09:41:47
 * @FilePath: /iniConfig/lib/common/utils/utils.dart
 * @Description: 工具函数集合
 * 
 */
class UtilFunc {
  // 数组合并去重
  static List<T> mergeAndDistinct<T>(List<T> list1, List<T> list2) {
    Set<T> set = Set<T>.from(list1)..addAll(list2);
    return List<T>.from(set);
  }
}
