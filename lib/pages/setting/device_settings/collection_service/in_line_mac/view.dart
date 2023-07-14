/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 15:58:21
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-13 17:39:55
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/collection_service/in_line_mac/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iniConfig/common/utils/trans_field.dart';

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
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.r),
          child: Card(
              child: SizedBox(
            child: controller.isSearching
                ? Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: ProgressRing(),
                    ),
                  )
                : ListView.builder(
                    itemCount: controller.sectionList.length,
                    itemBuilder: (context, index) {
                      final MacData contact = controller.sectionList[index];
                      return ListTile.selectable(
                        title: Text(
                            TransUtils.getTransField(contact.section!, '机床')),
                        subtitle: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            Text(
                                '机床号：${contact.data!['${contact.section}/MachineNum']}'),
                            Text(
                                '机床名称：${contact.data!['${contact.section}/MachineName']}'),
                            Text(
                                '机床类型：${contact.data!['${contact.section}/MachineType']}'),
                            Text(
                                '机床系统：${contact.data!['${contact.section}/MacSystemType']}'),
                          ],
                        ),
                        selected: controller.selectedSections
                            .contains(contact.section),
                        selectionMode: ListTileSelectionMode.multiple,
                        onSelectionChange: (selected) {
                          if (selected) {
                            controller.selectedSections.add(contact.section);
                          } else {
                            var index = controller.selectedSections
                                .indexOf(contact.section);
                            controller.selectedSections.removeAt(index);
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
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: _buildView(context)),
        );
      },
    );
  }
}
