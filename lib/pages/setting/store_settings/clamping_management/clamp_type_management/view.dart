/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-20 18:20:54
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-21 14:28:20
 * @FilePath: /eatm_ini_config/lib/pages/setting/store_settings/clamping_management/clamp_type_management/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';
import 'index.dart';

class ClampTypeManagementPage extends StatefulWidget {
  const ClampTypeManagementPage({Key? key}) : super(key: key);

  @override
  State<ClampTypeManagementPage> createState() =>
      _ClampTypeManagementPageState();
}

class _ClampTypeManagementPageState extends State<ClampTypeManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _ClampTypeManagementViewGetX();
  }
}

class _ClampTypeManagementViewGetX
    extends GetView<ClampTypeManagementController> {
  const _ClampTypeManagementViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Column(
      children: [
        SizedBox(
            child: Column(
                children: controller.menuList
                    .map((e) => FieldChange(
                          isChanged:
                              controller.isChanged("${e.section}/${e.field}"),
                          renderFieldInfo: e,
                          showValue: controller
                              .getFieldValue("${e.section}/${e.field}"),
                          onChanged: controller.onFieldChange,
                        ))
                    .toList())),
        // 15.verticalSpacingRadius,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClampTypeManagementController>(
      init: ClampTypeManagementController(),
      id: "clamp_type_management",
      builder: (_) {
        return ScaffoldPage.scrollable(
          children: [
            PageHeader(
                title: Text(
                  "夹具类型限制",
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
