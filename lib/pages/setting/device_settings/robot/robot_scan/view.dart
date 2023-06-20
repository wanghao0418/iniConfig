/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-15 14:03:26
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-20 09:12:18
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/robot/robot_scan/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../../common/components/field_change.dart';
import 'index.dart';
import 'widgets/scan_device_form.dart';

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
      children: [
        CommandBarCard(
            child: CommandBar(primaryItems: [
          CommandBarButton(
              label: Text('新增'), onPressed: () {}, icon: Icon(FluentIcons.add)),
          CommandBarSeparator(),
          CommandBarButton(
              label: Text('删除'),
              onPressed: () {},
              icon: Icon(FluentIcons.delete)),
          CommandBarSeparator(),
          CommandBarButton(
              label: Text('保存'),
              onPressed: controller.save,
              icon: Icon(FluentIcons.save)),
          CommandBarSeparator(),
          CommandBarButton(
              label: Text('测试'),
              onPressed: controller.save,
              icon: Icon(FluentIcons.test_plan)),
        ])),
        5.verticalSpacingRadius,
        Card(
            child: SizedBox(
          height: 500.0,
          child: Row(
            children: [
              SizedBox(
                width: 200,
                child: ListView.builder(
                    itemCount: controller.deviceList.length,
                    itemBuilder: (context, index) {
                      final contact = controller.deviceList[index];
                      return ListTile.selectable(
                        title: Text(contact),
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
                          : ScanDeviceForm(
                              key: controller.scanDeviceKey,
                              section: controller.currentDeviceId,
                            )))
            ],
          ),
        ))
      ],
    );
  }

  // 主视图
  Widget _buildView(context) {
    return Column(
      children: [
        SizedBox(
            child: Column(children: [
          // ...controller.menuList
          //     .map((e) => FieldChange(
          //           isChanged: controller.isChanged("${e.section}/${e.field}"),
          //           renderFieldInfo: e,
          //           showValue:
          //               controller.getFieldValue("${e.section}/${e.field}"),
          //           onChanged: controller.onFieldChange,
          //         ))
          //     .toList(),
          // Padding(
          //   padding: const EdgeInsetsDirectional.only(
          //       top: 14.0, bottom: 14.0, start: 14.0),
          //   child: DefaultTextStyle(
          //     style: FluentTheme.of(context).typography.subtitle!,
          //     child: SizedBox(
          //       width: double.infinity,
          //       child: Text(
          //         '扫码设备列表',
          //       ),
          //     ),
          //   ),
          // ),
          _buildScanDeviceList(context)
        ])),
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
        return ScaffoldPage.scrollable(
          children: [
            PageHeader(
              title: const Text("扫码设置"),
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
            _buildView(context)
          ],
        );
      },
    );
  }
}
