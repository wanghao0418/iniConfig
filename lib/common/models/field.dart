/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-14 18:09:17
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-14 18:14:30
 * @FilePath: /eatm_ini_config/lib/common/models/field.dart
 * @Description: 字段类
 */
class Field {
  String? section;
  String? field;
  String? value;

  Field({this.section, this.field, this.value});

  Field.fromJson(Map<String, dynamic> json) {
    section = json['section'];
    field = json['field'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['section'] = this.section;
    data['field'] = this.field;
    data['value'] = this.value;
    return data;
  }
}
