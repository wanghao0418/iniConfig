/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-15 11:17:42
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-15 11:30:11
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/robot/robot_connection/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';
import 'index.dart';

class RobotConnectionPage extends StatefulWidget {
  const RobotConnectionPage({Key? key}) : super(key: key);

  @override
  State<RobotConnectionPage> createState() => _RobotConnectionPageState();
}

class _RobotConnectionPageState extends State<RobotConnectionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _RobotConnectionViewGetX();
  }
}

class _RobotConnectionViewGetX extends GetView<RobotConnectionController> {
  const _RobotConnectionViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return SizedBox(
        child: Column(
            children: controller.menuList
                .map((e) => FieldChange(
                      isChanged: controller.isChanged(e.fieldKey),
                      renderFieldInfo: e,
                      showValue: controller.getFieldValue(e.fieldKey),
                      onChanged: controller.onFieldChange,
                    ))
                .toList()));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RobotConnectionController>(
      init: RobotConnectionController(),
      id: "robot_connection",
      builder: (_) {
        return ScaffoldPage.scrollable(
          children: [
            PageHeader(
                title: const Text("机器人连接设置"),
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
