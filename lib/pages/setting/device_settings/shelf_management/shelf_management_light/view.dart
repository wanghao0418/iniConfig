/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-15 14:57:37
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-13 17:38:04
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/shelf_management/shelf_management_light/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iniConfig/common/utils/trans_field.dart';
import 'package:iniConfig/pages/setting/device_settings/shelf_management/shelf_management_light/widgets/storage_light_device.dart';

import '../../../../../common/components/field_change.dart';
import 'index.dart';

class ShelfManagementLightPage extends StatefulWidget {
  const ShelfManagementLightPage({Key? key}) : super(key: key);

  @override
  State<ShelfManagementLightPage> createState() =>
      _ShelfManagementLightPageState();
}

class _ShelfManagementLightPageState extends State<ShelfManagementLightPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _ShelfManagementLightViewGetX();
  }
}

class _ShelfManagementLightViewGetX
    extends GetView<ShelfManagementLightController> {
  const _ShelfManagementLightViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView(BuildContext context) {
    return SizedBox(
        child: Column(children: [
      PageHeader(
          title:
              Text("七色灯", style: FluentTheme.of(context).typography.subtitle),
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
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.r),
        child: Column(
          children: [
            ...controller.menuList
                .map((e) => FieldChange(
                      isChanged: controller.isChanged(e.fieldKey),
                      renderFieldInfo: e,
                      showValue: controller.getFieldValue(e.fieldKey),
                      onChanged: controller.onFieldChange,
                    ))
                .toList(),
          ],
        ),
      ),
      15.verticalSpacingRadius,
      PageHeader(
        title:
            Text("七色灯管理", style: FluentTheme.of(context).typography.subtitle),
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
            CommandBarSeparator(),
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
                        title: Text(TransUtils.getTransField(contact, '七色灯')),
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
                          : StorageLightDevice(
                              key: Key(controller.currentSection.value),
                              section: controller.currentSection.value,
                            )))
            ],
          ),
        )),
      ))
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShelfManagementLightController>(
      init: ShelfManagementLightController(),
      id: "shelf_management_light",
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
