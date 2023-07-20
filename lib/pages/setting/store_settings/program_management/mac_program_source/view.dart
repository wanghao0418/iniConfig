/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 09:57:41
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 13:56:34
 * @FilePath: /eatm_ini_config/lib/pages/setting/store_settings/program_management/mac_program_source/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iniConfig/common/style/global_theme.dart';
import 'package:iniConfig/common/utils/trans_field.dart';
import 'package:iniConfig/pages/setting/store_settings/program_management/mac_program_source/widgets/mac_program_setting.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class MacProgramSourcePage extends StatefulWidget {
  const MacProgramSourcePage({Key? key}) : super(key: key);

  @override
  State<MacProgramSourcePage> createState() => _MacProgramSourcePageState();
}

class _MacProgramSourcePageState extends State<MacProgramSourcePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MacProgramSourceViewGetX();
  }
}

class _MacProgramSourceViewGetX extends GetView<MacProgramSourceController> {
  const _MacProgramSourceViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          title: Text(
            "机床程序来源",
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
                  icon: Icon(
                    FluentIcons.add,
                    color: GlobalTheme.instance.buttonIconColor,
                  )),
              CommandBarSeparator(
                color: GlobalTheme.instance.buttonIconColor,
              ),
              CommandBarButton(
                  label: Text('删除'),
                  onPressed: () {
                    if (controller.sectionList.isEmpty) {
                      return;
                    }
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
                  icon: Icon(
                    FluentIcons.delete,
                    color: GlobalTheme.instance.buttonIconColor,
                  )),
            ])),
        5.verticalSpacingRadius,
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.r),
          child: Card(
              child: SizedBox(
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: ListView.builder(
                      itemCount: controller.sectionList.length,
                      itemBuilder: (context, index) {
                        final contact = controller.sectionList[index];
                        return ListTile.selectable(
                          title:
                              Text(TransUtils.getTransField(contact, '机床程序')),
                          selected: controller.currentSection.value == contact,
                          onSelectionChange: (v) =>
                              controller.onSectionChange(contact),
                        );
                      }),
                ),
                10.horizontalSpaceRadius,
                Expanded(
                    child: Container(
                        color: FluentTheme.of(context).menuColor,
                        padding: EdgeInsets.all(10.0),
                        child: controller.currentSection.value.isEmpty
                            ? Container(
                                color: FluentTheme.of(context).menuColor,
                              )
                            : MacProgramSetting(
                                key: Key(controller.currentSection.value),
                                section: controller.currentSection.value,
                                macSectionList: controller.macSectionList,
                              )))
              ],
            ),
          )),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MacProgramSourceController>(
      init: MacProgramSourceController(),
      id: "mac_program_source",
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
