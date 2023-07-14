/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-26 19:20:36
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-13 17:49:11
 * @FilePath: /eatm_ini_config/lib/pages/setting/third_party_settings/mes_settings/EACT_setting/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../../common/components/index.dart';
import 'index.dart';

class EactSettingPage extends StatefulWidget {
  const EactSettingPage({Key? key}) : super(key: key);

  @override
  State<EactSettingPage> createState() => _EactSettingPageState();
}

class _EactSettingPageState extends State<EactSettingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _EactSettingViewGetX();
  }
}

class _EactSettingViewGetX extends GetView<EactSettingController> {
  const _EactSettingViewGetX({Key? key}) : super(key: key);

  Widget _buildTable() {
    return Container(
      margin: EdgeInsets.only(bottom: 5.r),
      child: Expander(
        initiallyExpanded: true,
        headerHeight: 70,
        header: Padding(
            padding: EdgeInsets.only(left: 40.r),
            child: Text('编号对应关系').fontWeight(FontWeight.bold).fontSize(16)),
        content: SizedBox(
            height: 300,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return PlutoGrid(
                    noRowsWidget: Center(child: Text('暂无数据')),
                    columns: [
                      PlutoColumn(
                        title: '自动化机床名称',
                        field: 'macSection',
                        type: PlutoColumnType.text(),
                        readOnly: true,
                        enableContextMenu: false,
                        // enableDropToResize: false,
                        enableSorting: false,
                      ),
                      PlutoColumn(
                        title: 'Eact中对应设备的唯一编号',
                        field: 'correspondMacMarkCode',
                        type: PlutoColumnType.text(),
                        enableContextMenu: false,
                        // enableDropToResize: false,
                        enableSorting: false,
                      ),
                    ],
                    rows: controller.rows,
                    // columnGroups: columnGroups,
                    onLoaded: (PlutoGridOnLoadedEvent event) {
                      controller.stateManager = event.stateManager;
                    },
                    onChanged: controller.onTableCellChanged,
                    configuration: const PlutoGridConfiguration(
                      columnSize: PlutoGridColumnSizeConfig(
                          autoSizeMode: PlutoAutoSizeMode.scale),
                      // style: PlutoGridStyleConfig(
                      //     gridBorderRadius:
                      //         BorderRadius.all(Radius.circular(10))),
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
        visible: (info.associatedField != null && info.associatedValue != null)
            ? controller.getFieldValue(info.associatedField!) ==
                info.associatedValue
            : true,
      );
    } else if (info is RenderCustomByTag) {
      if (info.tag == 'table') {
        return _buildTable();
      }
    }
  }

  // 主视图
  Widget _buildView(context) {
    return Column(
      children: [
        PageHeader(
            title: Text(
              "EAct设置",
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
          child: SingleChildScrollView(
              child: Column(
            children: [
              ...controller.menuList.map((e) => _buildRenderField(e)).toList(),
            ],
          )),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EactSettingController>(
      init: EactSettingController(),
      id: "eact_setting",
      builder: (_) {
        return ScaffoldPage(
          content: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: _buildView(context),
          ),
        );
      },
    );
  }
}
