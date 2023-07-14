/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-20 09:20:48
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-13 17:36:08
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/shelf_management/shelf_info/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iniConfig/common/utils/trans_field.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../../common/components/field_change.dart';
import 'index.dart';
import 'widgets/select_shelf_component.dart';
import 'widgets/shelf_info_setting.dart';

class ShelfInfoPage extends StatefulWidget {
  const ShelfInfoPage({Key? key}) : super(key: key);

  @override
  State<ShelfInfoPage> createState() => _ShelfInfoPageState();
}

class _ShelfInfoPageState extends State<ShelfInfoPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _ShelfInfoViewGetX();
  }
}

class _ShelfInfoViewGetX extends GetView<ShelfInfoController> {
  const _ShelfInfoViewGetX({Key? key}) : super(key: key);

  // 选择货架按钮弹窗
  Widget _buildSelectShelf(BuildContext context, RenderFieldInfo fieldInfo) {
    return FilledButton(
        child: const Text('编辑'),
        onPressed: () {
          var shelfSelectKey = GlobalKey();
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  constraints: const BoxConstraints(maxWidth: 500),
                  title: Text('${fieldInfo.name}').fontSize(24.sp),
                  content: SizedBox(
                      height: 500,
                      child: SelectShelfComponent(
                        key: shelfSelectKey,
                        showValue:
                            controller.getFieldValue(fieldInfo.fieldKey) ?? '',
                        shelfSectionList: controller.shelfList,
                      )),
                  actions: [
                    Button(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消')),
                    FilledButton(
                        onPressed: () {
                          var selectedShelf = (shelfSelectKey.currentState!
                                  as SelectShelfComponentState)
                              .selectedSections;
                          controller.onFieldChange(fieldInfo.fieldKey,
                              selectedShelf.map((e) => e.number).join('-'));
                          Navigator.of(context).pop();
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return Column(
      children: [
        PageHeader(
            title: Text(
              "全局设置",
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
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10.r),
            child: Column(
                children: controller.menuList.map((e) {
              if (e.field == 'rightBtnPutShelf') {
                return FieldChange(
                  isChanged: controller.isChanged(e.fieldKey),
                  renderFieldInfo: e,
                  showValue: controller.getFieldValue(e.fieldKey),
                  onChanged: controller.onFieldChange,
                  builder: (context) {
                    return _buildSelectShelf(context, e);
                  },
                );
              }

              return FieldChange(
                isChanged: controller.isChanged(e.fieldKey),
                renderFieldInfo: e,
                showValue: controller.getFieldValue(e.fieldKey),
                onChanged: controller.onFieldChange,
              );
            }).toList())),
        15.verticalSpacingRadius,
        PageHeader(
          title: Text(
            "货架管理",
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
                      itemCount: controller.shelfList.length,
                      itemBuilder: (context, index) {
                        final contact = controller.shelfList[index];
                        return ListTile.selectable(
                          title: Text(TransUtils.getTransField(contact, '货架')),
                          selected: controller.currentShelf.value == contact,
                          onSelectionChange: (v) =>
                              controller.onShelfChange(contact),
                        );
                      }),
                ),
                10.horizontalSpaceRadius,
                Expanded(
                    child: Container(
                        color: FluentTheme.of(context).menuColor,
                        padding: EdgeInsets.all(10.0),
                        child: controller.currentShelf.value.isEmpty
                            ? Container(
                                color: FluentTheme.of(context).menuColor,
                              )
                            : ShelfInfoSetting(
                                key: Key(controller.currentShelf.value),
                                section: controller.currentShelf.value,
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
    return GetBuilder<ShelfInfoController>(
      init: ShelfInfoController(),
      id: "shelf_info",
      builder: (_) {
        return ScaffoldPage(
            content: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: _buildView(context)));
      },
    );
  }
}
