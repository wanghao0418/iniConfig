/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 11:08:32
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-04 14:32:53
 * @FilePath: /eatm_ini_config/lib/common/components/field_group.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/components/field_subTitle.dart';
import 'package:styled_widget/styled_widget.dart';

import 'field_change.dart';

class RenderField {}

class RenderFieldGroup implements RenderField {
  String groupName;
  List<RenderField> children;
  bool? visible;
  bool? isExpanded;
  RenderFieldGroup({
    required this.groupName,
    required this.children,
    this.visible = true,
    this.isExpanded = false,
  });
}

class FieldGroup extends StatefulWidget {
  const FieldGroup(
      {Key? key,
      required this.groupName,
      required this.children,
      required this.onChanged,
      required this.getValue,
      required this.isChanged,
      this.visible = true,
      this.isExpanded = false})
      : super(key: key);
  final String groupName;
  final List children;
  final Function(String, String) onChanged;
  final Function(String) getValue;
  final Function(String) isChanged;
  final bool? visible;
  final bool? isExpanded;

  @override
  _FieldGroupState createState() => _FieldGroupState();
}

class _FieldGroupState extends State<FieldGroup> {
  @override
  Widget build(BuildContext context) {
    return widget.visible == true
        ? Expander(
            initiallyExpanded: widget.isExpanded ?? false,
            headerHeight: 70,
            header: Padding(
                padding: EdgeInsets.only(left: 40.r),
                child: Text(widget.groupName)
                    .fontWeight(FontWeight.bold)
                    .fontSize(16)),
            content: Column(
                children: widget.children.map((e) {
              if (e is RenderFieldInfo) {
                return FieldChange(
                  renderFieldInfo: e,
                  showValue: widget.getValue(e.fieldKey),
                  isChanged: widget.isChanged(e.fieldKey),
                  onChanged: widget.onChanged,
                );
              } else if (e is RenderFieldSubTitle) {
                return FieldSubTitle(title: e.title);
              }
              return Container();
            }).toList()),
          )
        : Container();
  }
}

class RenderCustomByTag implements RenderField {
  String tag;
  RenderCustomByTag({required this.tag});
}
