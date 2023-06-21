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
    return GetBuilder<RobotCommunicationProtocolController>(
      init: RobotCommunicationProtocolController(),
      id: "robot_communication_protocol",
      builder: (_) {
        return ScaffoldPage.scrollable(
          children: [
            PageHeader(
                title: Text(
                  "机器人连接设置",
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
