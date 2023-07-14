/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-20 18:20:54
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-05 14:05:04
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
  Widget _buildView(context) {
    return Column(
      children: [
        PageHeader(
            title: Text(
              "夹具类型限制",
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
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.r),
          child: Column(
            children: [
              SizedBox(
                  child: Column(
                      children: controller.menuList
                          .map((e) => FieldChange(
                                isChanged: controller
                                    .isChanged("${e.section}/${e.field}"),
                                renderFieldInfo: e,
                                showValue: controller
                                    .getFieldValue("${e.section}/${e.field}"),
                                onChanged: controller.onFieldChange,
                              ))
                          .toList())),
              // 15.verticalSpacingRadius,
            ],
          ),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClampTypeManagementController>(
      init: ClampTypeManagementController(),
      id: "clamp_type_management",
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
