/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-26 19:20:36
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-26 19:30:37
 * @FilePath: /eatm_ini_config/lib/pages/setting/third_party_settings/mes_settings/EACT_setting/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/components/index.dart';
import 'index.dart';

class EactSettingPage extends StatefulWidget {
  const EactSettingPage({Key? key}) : super(key: key);

  @override
  State<EactSettingPage> createState() => _EactSettingPageState();
}

class _EactSettingPageState extends State<EactSettingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _EactSettingViewGetX();
  }
}

class _EactSettingViewGetX extends GetView<EactSettingController> {
  const _EactSettingViewGetX({Key? key}) : super(key: key);

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
    return GetBuilder<EactSettingController>(
      init: EactSettingController(),
      id: "eact_setting",
      builder: (_) {
        return ScaffoldPage.scrollable(
          children: [
            PageHeader(
                title: Text(
                  "EAct设置",
                  style: FluentTheme.of(context).typography.subtitle,
                ),
                commandBar: CommandBar(
                  mainAxisAlignment: MainAxisAlignment.end,
                  primaryItems: [
                    CommandBarButton(
                      icon: const Icon(FluentIcons.save),
                      label: const Text('保存'),
                      onPressed: controller.save,
                    ),
                  ],
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
