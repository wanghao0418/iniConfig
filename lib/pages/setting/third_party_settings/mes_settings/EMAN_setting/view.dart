/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-26 19:31:02
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-21 18:04:10
 * @FilePath: /eatm_ini_config/lib/pages/setting/third_party_settings/mes_settings/EMAN_setting/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iniConfig/common/style/global_theme.dart';
import 'package:iniConfig/pages/setting/third_party_settings/mes_settings/EMAN_setting/subComponents/correspond_process.dart';
import 'package:iniConfig/pages/setting/third_party_settings/mes_settings/EMAN_setting/subComponents/eman_correspond_source.dart';
import 'package:iniConfig/pages/setting/third_party_settings/mes_settings/EMAN_setting/subComponents/process_preparation.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../../common/components/index.dart';
import 'index.dart';

class EmanSettingPage extends StatefulWidget {
  const EmanSettingPage({Key? key}) : super(key: key);

  @override
  State<EmanSettingPage> createState() => _EmanSettingPageState();
}

class _EmanSettingPageState extends State<EmanSettingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _EmanSettingViewGetX();
  }
}

class _EmanSettingViewGetX extends GetView<EmanSettingController> {
  const _EmanSettingViewGetX({Key? key}) : super(key: key);

  _buildRenderField(RenderField info, context) {
    if (info is RenderFieldGroup) {
      return Container(
        margin: EdgeInsets.only(bottom: 5.r),
        child: FieldGroup(
          visible: info.visible ?? true,
          groupName: info.groupName,
          getValue: controller.getFieldValue,
          children: info.children,
          isChanged: controller.isChanged,
          onChanged: (field, value) {
            controller.onFieldChange(field, value);
          },
        ),
      );
    } else if (info is RenderFieldInfo) {
      if (info.field == 'EmanReportType') {
        return FieldChange(
          renderFieldInfo: info as RenderFieldInfo,
          showValue: controller.getFieldValue(info.fieldKey),
          isChanged: controller.isChanged(info.fieldKey),
          onChanged: (field, value) {
            controller.onFieldChange(field, value);
          },
          builder: (context) {
            var _key = GlobalKey();
            return FilledButton(
                child: const Text('编辑'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ContentDialog(
                          constraints:
                              BoxConstraints(maxWidth: 800, maxHeight: 500),
                          title: Text('${info.name}').fontSize(20.sp),
                          content: ProcessPreparation(
                            key: _key,
                            showValue:
                                controller.getFieldValue(info.fieldKey) ?? '',
                          ),
                          actions: [
                            Button(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('取消')),
                            FilledButton(
                                onPressed: () {
                                  var value = (_key.currentState
                                          as ProcessPreparationState)
                                      .currentValue;
                                  controller.onFieldChange(
                                      info.fieldKey, value);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('确定'))
                          ],
                        );
                      });
                });
          },
        );
      } else if (info.field == 'WorkpieceCraft') {
        return FieldChange(
            renderFieldInfo: info as RenderFieldInfo,
            showValue: controller.getFieldValue(info.fieldKey),
            isChanged: controller.isChanged(info.fieldKey),
            onChanged: (field, value) {
              controller.onFieldChange(field, value);
            },
            builder: (context) => _buildCorrespondingProcess(context, info));
      } else if (info.field == 'MacMonitorId') {
        return FieldChange(
            renderFieldInfo: info as RenderFieldInfo,
            showValue: controller.getFieldValue(info.fieldKey),
            isChanged: controller.isChanged(info.fieldKey),
            onChanged: (field, value) {
              controller.onFieldChange(field, value);
            },
            builder: (context) => _buildCorrespondingMonitorId(context, info));
      }
      return FieldChange(
        renderFieldInfo: info as RenderFieldInfo,
        showValue: controller.getFieldValue(info.fieldKey),
        isChanged: controller.isChanged(info.fieldKey),
        onChanged: (field, value) {
          controller.onFieldChange(field, value);
        },
      );
    }
    return Container();
  }

  // 对应工艺
  Widget _buildCorrespondingProcess(
      BuildContext context, RenderFieldInfo info) {
    var _key = GlobalKey();
    return FilledButton(
        child: const Text('编辑'),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  constraints: BoxConstraints(maxWidth: 800, maxHeight: 500),
                  title: Text('${info.name}').fontSize(20.sp),
                  content: CorrespondProcess(
                    key: _key,
                    showValue: controller.getFieldValue(info.fieldKey) ?? '',
                  ),
                  actions: [
                    Button(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消')),
                    FilledButton(
                        onPressed: () {
                          var value =
                              (_key.currentState as CorrespondProcessState)
                                  .currentValue;
                          controller.onFieldChange(info.fieldKey, value);
                          Navigator.of(context).pop();
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  // 对应资源
  Widget _buildCorrespondingMonitorId(
      BuildContext context, RenderFieldInfo info) {
    var _key = GlobalKey();
    return FilledButton(
        child: const Text('编辑'),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  constraints: BoxConstraints(maxWidth: 800, maxHeight: 500),
                  title: Text('${info.name}').fontSize(20.sp),
                  content: EmanCorrespondSource(
                    key: _key,
                    showValue: controller.getFieldValue(info.fieldKey) ?? '',
                  ),
                  actions: [
                    Button(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消')),
                    FilledButton(
                        onPressed: () {
                          var value =
                              (_key.currentState as EmanCorrespondSourceState)
                                  .currentValue;
                          controller.onFieldChange(info.fieldKey, value);
                          Navigator.of(context).pop();
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  // 主视图
  Widget _buildView(context) {
    return Column(
      children: [
        PageHeader(
            title: Text(
              "EMan设置",
              style: FluentTheme.of(context).typography.subtitle,
            ),
            commandBar: FilledButton(
              child: Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Icon(FluentIcons.save),
                  Text("保存"),
                ],
              ),
              onPressed: controller.save,
            )),
        const Divider(),
        15.verticalSpacingRadius,
        Expanded(
            child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  ...controller.menuList
                      .map((e) => _buildRenderField(e, context))
                      .toList(),
                ],
              )),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmanSettingController>(
      init: EmanSettingController(),
      id: "eman_setting",
      builder: (_) {
        return ScaffoldPage(
          content: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: _buildView(context),
          ),
        );
      },
    );
  }
}
