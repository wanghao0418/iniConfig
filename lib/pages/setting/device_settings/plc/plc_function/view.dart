/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-15 11:06:58
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-30 11:39:16
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/plc/plc_function/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';
import 'index.dart';

class PlcFunctionPage extends StatefulWidget {
  const PlcFunctionPage({Key? key}) : super(key: key);

  @override
  State<PlcFunctionPage> createState() => _PlcFunctionPageState();
}

class _PlcFunctionPageState extends State<PlcFunctionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _PlcFunctionViewGetX();
  }
}

class _PlcFunctionViewGetX extends GetView<PlcFunctionController> {
  const _PlcFunctionViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return SizedBox(
        child: Column(
            children: controller.functionList
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
    return GetBuilder<PlcFunctionController>(
      init: PlcFunctionController(),
      id: "plc_function",
      builder: (_) {
        return ScaffoldPage.scrollable(
          children: [
            PageHeader(
                title: Text(
                  "plc功能设置",
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
