/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 11:08:32
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-21 13:18:24
 * @FilePath: /eatm_ini_config/lib/common/components/field_group.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import 'field_change.dart';

class RenderField {}

class RenderFieldGroup implements RenderField {
  String groupName;
  List<RenderFieldInfo> children;
  // Function(String, String) onChanged;
  // Function getValue;
  RenderFieldGroup({
    required this.groupName,
    required this.children,
    // required this.onChanged,
    // required this.getValue,
  });
}

class FieldGroup extends StatefulWidget {
  const FieldGroup(
      {Key? key,
      required this.groupName,
      required this.children,
      required this.onChanged,
      required this.getValue,
      required this.isChanged})
      : super(key: key);
  final String groupName;
  final List<RenderFieldInfo> children;
  final Function(String, String) onChanged;
  final Function(String) getValue;
  final Function(String) isChanged;

  @override
  _FieldGroupState createState() => _FieldGroupState();
}

class _FieldGroupState extends State<FieldGroup> {
  @override
  Widget build(BuildContext context) {
    return Expander(
      headerHeight: 70,
      header: Padding(
          padding: EdgeInsets.only(left: 40.r),
          child:
              Text(widget.groupName).fontWeight(FontWeight.bold).fontSize(16)),
      content: Column(
          children: widget.children
              .map((e) => FieldChange(
                    renderFieldInfo: e,
                    showValue: widget.getValue(e.fieldKey),
                    isChanged: widget.isChanged(e.fieldKey),
                    onChanged: widget.onChanged,
                  ))
              .toList()),
    );
  }
}
