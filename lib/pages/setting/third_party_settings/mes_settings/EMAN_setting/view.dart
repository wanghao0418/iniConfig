/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-26 19:31:02
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-04 16:27:39
 * @FilePath: /eatm_ini_config/lib/pages/setting/third_party_settings/mes_settings/EMAN_setting/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../../common/components/index.dart';
import 'index.dart';

class EmanSettingPage extends StatefulWidget {
  const EmanSettingPage({Key? key}) : super(key: key);

  @override
  State<EmanSettingPage> createState() => _EmanSettingPageState();
}

class _EmanSettingPageState extends State<EmanSettingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _EmanSettingViewGetX();
  }
}

class _EmanSettingViewGetX extends GetView<EmanSettingController> {
  const _EmanSettingViewGetX({Key? key}) : super(key: key);

  // 表格
  Widget _buildTable() {
    return Container(
      margin: EdgeInsets.only(bottom: 5.r),
      child: Expander(
        initiallyExpanded: true,
        headerHeight: 70,
        header: Padding(
            padding: EdgeInsets.only(left: 40.r),
            child: Text('对应关系').fontWeight(FontWeight.bold).fontSize(16)),
        content: SizedBox(
            height: 300,
            child: LayoutBuilder(
              builder: (context, constraints) {
                var width = constraints.maxWidth;
                return PlutoGrid(
                    noRowsWidget: Center(child: Text('暂无数据')),
                    columns: [
                      PlutoColumn(
                          title: '线内机床',
                          field: 'macSection',
                          type: PlutoColumnType.text(),
                          readOnly: true,
                          sort: PlutoColumnSort.none,
                          enableContextMenu: false,
                          width: width / 3),
                      PlutoColumn(
                          title: '对应机床名称',
                          field: 'correspondMacName',
                          type: PlutoColumnType.text(),
                          sort: PlutoColumnSort.none,
                          enableContextMenu: false,
                          width: width / 3),
                      PlutoColumn(
                          title: '对应监控ID',
                          field: 'correspondMacMonitorId',
                          type: PlutoColumnType.text(),
                          sort: PlutoColumnSort.none,
                          enableContextMenu: false,
                          width: width / 3),
                    ],
                    rows: controller.rows,
                    // columnGroups: columnGroups,
                    onLoaded: (PlutoGridOnLoadedEvent event) {
                      controller.stateManager = event.stateManager;
                    },
                    onChanged: controller.onTableCellChanged,
                    configuration: const PlutoGridConfiguration(
                      style: PlutoGridStyleConfig(
                          gridBorderRadius:
                              BorderRadius.all(Radius.circular(10))),
                    ));
              },
            )),
      ),
    );
  }

  _buildRenderField(RenderField info) {
    if (info is RenderFieldGroup) {
      return Container(
        margin: EdgeInsets.only(bottom: 5.r),
        child: FieldGroup(
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
    } else if (info is RenderFieldInfo) {
      return FieldChange(
        renderFieldInfo: info as RenderFieldInfo,
        showValue: controller.getFieldValue(info.fieldKey),
        isChanged: controller.isChanged(info.fieldKey),
        onChanged: (field, value) {
          controller.onFieldChange(field, value);
        },
      );
    } else if (info is RenderCustomByTag) {
      if (info.tag == 'table') {
        return _buildTable();
      }
    }
  }

  // 主视图
  Widget _buildView() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.r),
        child: Column(
          children: [
            ...controller.menuList.map((e) => _buildRenderField(e)).toList(),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmanSettingController>(
      init: EmanSettingController(),
      id: "eman_setting",
      builder: (_) {
        return ScaffoldPage.scrollable(
          children: [
            PageHeader(
                title: Text(
                  "EMan设置",
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
