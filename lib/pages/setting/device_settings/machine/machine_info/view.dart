/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-20 13:38:43
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-27 09:32:49
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/machine/machine_info/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iniConfig/pages/setting/device_settings/machine/machine_info/widgets/mac_info_setting.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../../common/components/index.dart';
import 'index.dart';

class MachineInfoPage extends StatefulWidget {
  const MachineInfoPage({Key? key}) : super(key: key);

  @override
  State<MachineInfoPage> createState() => MachineInfoPageState();
}

class MachineInfoPageState extends State<MachineInfoPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MachineInfoViewGetX();
  }
}

class _MachineInfoViewGetX extends GetView<MachineInfoController> {
  const _MachineInfoViewGetX({Key? key}) : super(key: key);

  _buildRenderField(RenderField info) {
    if (info is RenderFieldGroup) {
      return Container(
        margin: EdgeInsets.only(bottom: 5.r),
        child: FieldGroup(
          isExpanded: info.isExpanded ?? false,
          visible: info.visible ?? true,
          groupName: info.groupName,
          getValue: controller.getFieldValue,
          children: info.children,
          isChanged: controller.isChanged,
          onChanged: (field, value) {
            controller.onFieldChange(field, value);
          },
        ),
      );
    } else {
      return FieldChange(
        renderFieldInfo: info as RenderFieldInfo,
        showValue: controller.getFieldValue(info.fieldKey),
        isChanged: controller.isChanged(info.fieldKey),
        onChanged: (field, value) {
          controller.onFieldChange(field, value);
        },
      );
    }
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return Column(
      children: [
        PageHeader(
            title: Text(
              "全局配置",
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
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.r),
            child: Column(
              children: [
                ...controller.menuList
                    .map((e) => _buildRenderField(e))
                    .toList(),
              ],
            )
            // Expander(
            //     headerHeight: 70,
            //     header: Padding(
            //         padding: EdgeInsets.only(left: 40.r),
            //         child: Text('全局配置').fontWeight(FontWeight.bold).fontSize(16)),
            //     content: SizedBox(
            //       height: 200,
            //     )),
            ),
        15.verticalSpacingRadius,
        PageHeader(
          title: Text(
            "机床管理",
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
                  onPressed: () => controller.add(context),
                  icon: Icon(FluentIcons.add)),
              CommandBarSeparator(),
              CommandBarButton(
                  label: Text('删除'),
                  onPressed: () {},
                  icon: Icon(FluentIcons.delete)),
              // CommandBarSeparator(),
              // CommandBarButton(
              //     label: Text('保存'),
              //     onPressed: controller.save,
              //     icon: Icon(FluentIcons.save)),
              // CommandBarSeparator(),
              // CommandBarButton(
              //     label: Text('测试'),
              //     onPressed: controller.save,
              //     icon: Icon(FluentIcons.test_plan)),
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
                          title: Text(contact),
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
                            : MacInfoSetting(
                                isLineOut: false,
                                key: Key(controller.currentSection.value),
                                section: controller.currentSection.value,
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
    return GetBuilder<MachineInfoController>(
      init: MachineInfoController(),
      id: "machine_info",
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
