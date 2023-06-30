/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-15 11:39:57
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-30 11:39:53
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/robot/robot_task/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';
import 'index.dart';

class RobotTaskPage extends StatefulWidget {
  const RobotTaskPage({Key? key}) : super(key: key);

  @override
  State<RobotTaskPage> createState() => _RobotTaskPageState();
}

class _RobotTaskPageState extends State<RobotTaskPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _RobotTaskViewGetX();
  }
}

class _RobotTaskViewGetX extends GetView<RobotTaskController> {
  const _RobotTaskViewGetX({Key? key}) : super(key: key);

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
    return GetBuilder<RobotTaskController>(
      init: RobotTaskController(),
      id: "robot_task",
      builder: (_) {
        return ScaffoldPage.scrollable(
          children: [
            PageHeader(
                title: Text(
                  "机器人任务设置",
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
                )
                // commandBar: CommandBar(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   primaryItems: [
                //     CommandBarButton(
                //       icon: const Icon(FluentIcons.save),
                //       label: const Text('保存'),
                //       onPressed: controller.save,
                //     ),
                //   ],
                // )
                ),
            const Divider(),
            15.verticalSpacingRadius,
            _buildView()
          ],
        );
      },
    );
  }
}
