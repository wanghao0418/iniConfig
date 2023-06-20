/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-20 09:20:48
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-20 09:38:01
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/shelf_management/shelf_info/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';
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

  // 主视图
  Widget _buildView(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          title: const Text("货架设置"),
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
        CommandBarCard(
            margin: EdgeInsets.symmetric(horizontal: 10.r),
            child: CommandBar(primaryItems: [
              CommandBarButton(
                  label: Text('新增'),
                  onPressed: () {},
                  icon: Icon(FluentIcons.add)),
              CommandBarSeparator(),
              CommandBarButton(
                  label: Text('删除'),
                  onPressed: () {},
                  icon: Icon(FluentIcons.delete)),
              CommandBarSeparator(),
              CommandBarButton(
                  label: Text('保存'),
                  onPressed: controller.save,
                  icon: Icon(FluentIcons.save)),
              CommandBarSeparator(),
              CommandBarButton(
                  label: Text('测试'),
                  onPressed: controller.save,
                  icon: Icon(FluentIcons.test_plan)),
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
                          title: Text(contact),
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
                            : ShelfInfoSetting()))
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
                padding: EdgeInsets.all(20.r), child: _buildView(context)));
      },
    );
  }
}
