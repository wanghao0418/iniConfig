/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-14 15:30:08
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-05 14:23:39
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/plc/plc_connection/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';
import 'index.dart';

class PlcConnectionPage extends StatefulWidget {
  const PlcConnectionPage({Key? key}) : super(key: key);

  @override
  State<PlcConnectionPage> createState() => _PlcConnectionPageState();
}

class _PlcConnectionPageState extends State<PlcConnectionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _PlcConnectionViewGetX();
  }
}

class _PlcConnectionViewGetX extends GetView<PlcConnectionController> {
  const _PlcConnectionViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView(context) {
    return Column(
      children: [
        PageHeader(
            title: Text(
              "plc连接设置",
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
                  children: controller.connectList
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
    return GetBuilder<PlcConnectionController>(
      init: PlcConnectionController(),
      id: "plc_connection",
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
