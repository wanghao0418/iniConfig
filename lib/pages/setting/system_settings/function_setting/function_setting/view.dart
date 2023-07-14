/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-26 17:04:53
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-05 14:03:58
 * @FilePath: /eatm_ini_config/lib/pages/setting/system_settings/function_setting/function_setting/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/components/index.dart';
import 'index.dart';

class FunctionSettingPage extends StatefulWidget {
  const FunctionSettingPage({Key? key}) : super(key: key);

  @override
  State<FunctionSettingPage> createState() => _FunctionSettingPageState();
}

class _FunctionSettingPageState extends State<FunctionSettingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _FunctionSettingViewGetX();
  }
}

class _FunctionSettingViewGetX extends GetView<FunctionSettingController> {
  const _FunctionSettingViewGetX({Key? key}) : super(key: key);

  _buildRenderField(RenderField info) {
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
    } else {
      return FieldChange(
        renderFieldInfo: info as RenderFieldInfo,
        showValue: controller.getFieldValue(info.fieldKey),
        isChanged: controller.isChanged(info.fieldKey),
        onChanged: (field, value) {
          controller.onFieldChange(field, value);
        },
      );
    }
  }

  // 主视图
  Widget _buildView(context) {
    return Column(children: [
      PageHeader(
          title: Text(
            "功能设置",
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
            padding: EdgeInsets.symmetric(horizontal: 10.r),
            child: Column(
              children: [
                ...controller.menuList
                    .map((e) => _buildRenderField(e))
                    .toList(),
              ],
            )),
      ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FunctionSettingController>(
      init: FunctionSettingController(),
      id: "function_setting",
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
