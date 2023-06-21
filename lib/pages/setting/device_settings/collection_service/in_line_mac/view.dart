/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 15:58:21
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-21 18:14:44
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/collection_service/in_line_mac/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';

class InLineMacPage extends StatefulWidget {
  const InLineMacPage({Key? key}) : super(key: key);

  @override
  State<InLineMacPage> createState() => _InLineMacPageState();
}

class _InLineMacPageState extends State<InLineMacPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _InLineMacViewGetX();
  }
}

class _InLineMacViewGetX extends GetView<InLineMacController> {
  const _InLineMacViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          title: Text(
            "线体机床采集",
            style: FluentTheme.of(context).typography.subtitle,
          ),
          commandBar: CommandBar(
            mainAxisAlignment: MainAxisAlignment.end,
            primaryItems: [
              CommandBarButton(
                  label: Text('保存'),
                  onPressed: () {},
                  icon: Icon(FluentIcons.save)),
            ],
          ),
        ),
        const Divider(),
        15.verticalSpacingRadius,
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.r),
          child: Card(
              child: SizedBox(
            child: ListView.builder(
                itemCount: controller.sectionList.length,
                itemBuilder: (context, index) {
                  final contact = controller.sectionList[index];
                  return ListTile.selectable(
                    title: Text(contact),
                    selected: controller.selectedSections.contains(contact),
                    selectionMode: ListTileSelectionMode.multiple,
                    onSelectionChange: (selected) {
                      if (selected) {
                        controller.selectedSections.add(contact);
                      } else {
                        controller.selectedSections.remove(contact);
                      }
                      controller.update(["in_line_mac"]);
                    },
                  );
                }),
          )),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InLineMacController>(
      init: InLineMacController(),
      id: "in_line_mac",
      builder: (_) {
        return ScaffoldPage(
          content: Padding(
              padding: EdgeInsets.fromLTRB(20.r, 0, 20.r, 20.r),
              child: _buildView(context)),
        );
      },
    );
  }
}
