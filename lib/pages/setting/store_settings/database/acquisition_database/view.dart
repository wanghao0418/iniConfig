/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-20 15:48:32
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-30 11:40:54
 * @FilePath: /eatm_ini_config/lib/pages/setting/store_settings/database/acquisition_database/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';
import 'index.dart';

class AcquisitionDatabasePage extends StatefulWidget {
  const AcquisitionDatabasePage({Key? key}) : super(key: key);

  @override
  State<AcquisitionDatabasePage> createState() =>
      _AcquisitionDatabasePageState();
}

class _AcquisitionDatabasePageState extends State<AcquisitionDatabasePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _AcquisitionDatabaseViewGetX();
  }
}

class _AcquisitionDatabaseViewGetX
    extends GetView<AcquisitionDatabaseController> {
  const _AcquisitionDatabaseViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView(context) {
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
    return GetBuilder<AcquisitionDatabaseController>(
      init: AcquisitionDatabaseController(),
      id: "acquisition_database",
      builder: (_) {
        return ScaffoldPage.scrollable(
          children: [
            PageHeader(
                title: Text(
                  "采集数据库连接设置",
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
            _buildView(context)
          ],
        );
      },
    );
  }
}
