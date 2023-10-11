/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 11:08:32
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-21 17:11:56
 * @FilePath: /eatm_ini_config/lib/common/components/field_group.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/components/field_subTitle.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/material.dart' as material;

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
      this.isExpanded = false,
      this.groupHeight})
      : super(key: key);
  final String groupName;
  final List children;
  final Function(String, String) onChanged;
  final Function(String) getValue;
  final Function(String) isChanged;
  final bool? visible;
  final bool? isExpanded;
  final double? groupHeight;

  @override
  _FieldGroupState createState() => _FieldGroupState();
}

class _FieldGroupState extends State<FieldGroup> {
  _buildDetail() {
    showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
              constraints: BoxConstraints(maxWidth: 800),
              title: Text(widget.groupName),
              content: Container(
                height: 600,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...widget.children.map((e) {
                        if (e is RenderFieldInfo) {
                          return FieldChange(
                              renderFieldInfo: e,
                              showValue: widget.getValue(e.fieldKey),
                              isChanged: widget.isChanged(e.fieldKey),
                              onChanged: widget.onChanged,
                              readOnly: e.readOnly,
                              builder: e.builder,
                              visible: (e.associatedField != null &&
                                      e.associatedValue != null)
                                  ? widget.getValue(e.associatedField!) ==
                                      e.associatedValue
                                  : true);
                        } else if (e is RenderFieldSubTitle) {
                          return FieldSubTitle(title: e.title);
                        }
                        return Container();
                      }).toList()
                    ],
                  ),
                ),
              ));
        });
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      child: Column(children: [
        Card(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.groupName,
                    style: FluentTheme.of(context).typography.subtitle,
                    textAlign: TextAlign.left,
                  ).fontWeight(FontWeight.bold).fontSize(16),
                  // FilledButton(child: Text('查看'), onPressed: _buildDetail)
                ],
              ),
            ),
            20.verticalSpacingRadius,
            Divider(),
            20.verticalSpacingRadius,
            ...widget.children.map((e) {
              if (e is RenderFieldInfo) {
                return FieldChange(
                    renderFieldInfo: e,
                    showValue: widget.getValue(e.fieldKey),
                    isChanged: widget.isChanged(e.fieldKey),
                    onChanged: widget.onChanged,
                    readOnly: e.readOnly,
                    builder: e.builder,
                    visible:
                        (e.associatedField != null && e.associatedValue != null)
                            ? widget.getValue(e.associatedField!) ==
                                e.associatedValue
                            : true);
              } else if (e is RenderFieldSubTitle) {
                return FieldSubTitle(title: e.title);
              } else if (e is RenderFieldGroup) {
                return Container(
                  margin: EdgeInsets.only(bottom: 5.r),
                  child: FieldGroup(
                      groupName: e.groupName,
                      children: e.children,
                      onChanged: widget.onChanged,
                      getValue: widget.getValue,
                      isChanged: widget.isChanged,
                      visible: e.visible,
                      isExpanded: e.isExpanded),
                );
              }
              return Container();
            }).toList()
          ]),
        )
      ]),
    );
  }

  // old 抽屉组件 html下渲染有问题
  _buildExpander(context) {
    return widget.visible == true
        ? Expander(
            initiallyExpanded: widget.isExpanded ?? false,
            // headerHeight: 70,
            header: Padding(
                padding: EdgeInsets.only(left: 40.r),
                child: Text(
                  widget.groupName,
                  style: FluentTheme.of(context).typography.display,
                ).fontWeight(FontWeight.bold).fontSize(16)),
            content: widget.groupHeight == null
                ? Column(
                    children: widget.children.map((e) {
                    if (e is RenderFieldInfo) {
                      return FieldChange(
                          renderFieldInfo: e,
                          showValue: widget.getValue(e.fieldKey),
                          isChanged: widget.isChanged(e.fieldKey),
                          onChanged: widget.onChanged,
                          readOnly: e.readOnly,
                          builder: e.builder,
                          visible: (e.associatedField != null &&
                                  e.associatedValue != null)
                              ? widget.getValue(e.associatedField!) ==
                                  e.associatedValue
                              : true);
                    } else if (e is RenderFieldSubTitle) {
                      return FieldSubTitle(title: e.title);
                    }
                    return Container();
                  }).toList())
                : SizedBox(
                    height: widget.groupHeight,
                    child: SingleChildScrollView(
                        child: Column(
                            children: widget.children.map((e) {
                      if (e is RenderFieldInfo) {
                        return FieldChange(
                            renderFieldInfo: e,
                            showValue: widget.getValue(e.fieldKey),
                            isChanged: widget.isChanged(e.fieldKey),
                            onChanged: widget.onChanged,
                            readOnly: e.readOnly,
                            builder: e.builder,
                            visible: (e.associatedField != null &&
                                    e.associatedValue != null)
                                ? widget.getValue(e.associatedField!) ==
                                    e.associatedValue
                                : true);
                      } else if (e is RenderFieldSubTitle) {
                        return FieldSubTitle(title: e.title);
                      }
                      return Container();
                    }).toList())),
                  ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }
}

class RenderCustomByTag implements RenderField {
  String tag;
  RenderCustomByTag({required this.tag});
}
