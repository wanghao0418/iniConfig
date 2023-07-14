/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-04 17:34:03
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-05 14:21:51
 * @FilePath: /iniConfig/lib/pages/setting/device_settings/robot/robot_communication_protocol/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';
import 'index.dart';

class RobotCommunicationProtocolPage extends StatefulWidget {
  const RobotCommunicationProtocolPage({Key? key}) : super(key: key);

  @override
  State<RobotCommunicationProtocolPage> createState() =>
      _RobotCommunicationProtocolPageState();
}

class _RobotCommunicationProtocolPageState
    extends State<RobotCommunicationProtocolPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _RobotCommunicationProtocolViewGetX();
  }
}

class _RobotCommunicationProtocolViewGetX
    extends GetView<RobotCommunicationProtocolController> {
  const _RobotCommunicationProtocolViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView(context) {
    return Column(
      children: [
        PageHeader(
            title: Text(
              "机器人连接设置",
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
                  children: controller.menuList
                      .map((e) => FieldChange(
                            isChanged: controller.isChanged(e.fieldKey),
                            renderFieldInfo: e,
                            showValue: controller.getFieldValue(e.fieldKey),
                            onChanged: controller.onFieldChange,
                          ))
                      .toList())),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RobotCommunicationProtocolController>(
      init: RobotCommunicationProtocolController(),
      id: "robot_communication_protocol",
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
