/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-03 11:31:48
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-03 13:23:26
 * @FilePath: /eatm_ini_config/lib/pages/setting/third_party_settings/mes_settings/external_interface/view.dart
 * @Description: 对外接口
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/components/index.dart';
import 'index.dart';

class ExternalInterfacePage extends StatefulWidget {
  const ExternalInterfacePage({Key? key}) : super(key: key);

  @override
  State<ExternalInterfacePage> createState() => _ExternalInterfacePageState();
}

class _ExternalInterfacePageState extends State<ExternalInterfacePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _ExternalInterfaceViewGetX();
  }
}

class _ExternalInterfaceViewGetX extends GetView<ExternalInterfaceController> {
  const _ExternalInterfaceViewGetX({Key? key}) : super(key: key);

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
  Widget _buildView() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.r),
        child: Column(
          children: [
            ...controller.menuList.map((e) => _buildRenderField(e)).toList(),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExternalInterfaceController>(
      init: ExternalInterfaceController(),
      id: "external_interface",
      builder: (_) {
        return ScaffoldPage.scrollable(
          children: [
            PageHeader(
                title: Text(
                  "自动化对外接口",
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
            _buildView()
          ],
        );
      },
    );
  }
}
