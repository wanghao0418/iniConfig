/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-15 14:03:26
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-13 17:34:57
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/robot/robot_scan/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iniConfig/common/utils/trans_field.dart';
import 'index.dart';
import 'widgets/scan_device_form.dart';
import 'widgets/tcp_scan_driver.dart';

class RobotScanPage extends StatefulWidget {
  const RobotScanPage({Key? key}) : super(key: key);

  @override
  State<RobotScanPage> createState() => _RobotScanPageState();
}

class _RobotScanPageState extends State<RobotScanPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _RobotScanViewGetX();
  }
}

class _RobotScanViewGetX extends GetView<RobotScanController> {
  const _RobotScanViewGetX({Key? key}) : super(key: key);

  // 扫码设备列表
  Widget _buildScanDeviceList(context) {
    return Column(
      children: [],
    );
  }

  // 主视图
  Widget _buildView(context) {
    return Column(
      children: [
        PageHeader(
          title: Text(
            "扫码设置",
            style: FluentTheme.of(context).typography.subtitle,
          ),
        ),
        const Divider(),
        15.verticalSpacingRadius,
        CommandBarCard(
            margin: EdgeInsets.symmetric(horizontal: 10.r),
            child: CommandBar(primaryItems: [
              CommandBarButton(
                  label: Text('新增'),
                  onPressed: controller.add,
                  icon: Icon(FluentIcons.add)),
              CommandBarSeparator(),
              CommandBarButton(
                  label: Text('删除'),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ContentDialog(
                              title: Text("删除"),
                              content: Text("确认删除吗?"),
                              actions: [
                                Button(
                                    child: Text("取消"),
                                    onPressed: () => Navigator.pop(context)),
                                FilledButton(
                                    child: Text("确认"),
                                    onPressed: () {
                                      controller.delete();
                                      Navigator.pop(context);
                                    })
                              ]);
                        });
                  },
                  icon: Icon(FluentIcons.delete)),
            ])),
        5.verticalSpacingRadius,
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.r),
          child: Card(
              child: Row(
            children: [
              SizedBox(
                width: 200,
                child: ListView.builder(
                    itemCount: controller.deviceList.length,
                    itemBuilder: (context, index) {
                      final contact = controller.deviceList[index];
                      return ListTile.selectable(
                        title: Text(TransUtils.getTransField(contact, '扫码设备')),
                        selected: controller.currentDeviceId == contact,
                        onSelectionChange: (v) =>
                            controller.onDeviceChange(contact),
                      );
                    }),
              ),
              10.horizontalSpaceRadius,
              Expanded(
                  child: Container(
                      color: FluentTheme.of(context).menuColor,
                      padding: EdgeInsets.all(10.0),
                      child: controller.currentDeviceId.isEmpty
                          ? Container(
                              color: FluentTheme.of(context).menuColor,
                            )
                          : TcpScanDriver(
                              key: ValueKey(controller.currentDeviceId),
                              section: controller.currentDeviceId,
                            )))
            ],
          )),
        )),
        // 15.verticalSpacingRadius,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RobotScanController>(
      init: RobotScanController(),
      id: "robot_scan",
      builder: (_) {
        return ScaffoldPage(
          content: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: _buildView(context)),
        );
      },
    );
  }
}
