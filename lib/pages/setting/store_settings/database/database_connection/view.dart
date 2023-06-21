/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-13 11:34:05
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-21 14:28:37
 * @FilePath: /eatm_ini_config/lib/pages/setting/store_settings/database/database_connection/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';
import 'index.dart';

class DatabaseConnectionPage extends StatefulWidget {
  const DatabaseConnectionPage({Key? key}) : super(key: key);

  @override
  State<DatabaseConnectionPage> createState() => _DatabaseConnectionPageState();
}

class _DatabaseConnectionPageState extends State<DatabaseConnectionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _DatabaseConnectionViewGetX();
  }
}

class _DatabaseConnectionViewGetX
    extends GetView<DatabaseConnectionController> {
  const _DatabaseConnectionViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView(context) {
    return Column(
      children: [
        SizedBox(
            child: Column(
                children: controller.renderList
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
    return GetBuilder<DatabaseConnectionController>(
      init: DatabaseConnectionController(),
      id: "database_connection",
      builder: (_) {
        return ScaffoldPage.scrollable(
          children: [
            PageHeader(
                title: Text(
                  "自动化数据库连接设置",
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
            _buildView(context)
          ],
        );
      },
    );
  }
}
