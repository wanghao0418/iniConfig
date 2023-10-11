/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-14 09:26:02
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 13:33:16
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/plc/plc_communication_protocol/view.dart
 * @Description: 通讯协议设置界面
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../../common/components/field_change.dart';
import '../../../../../common/index.dart';
import 'index.dart';

class PlcCommunicationProtocolPage extends StatefulWidget {
  const PlcCommunicationProtocolPage({Key? key}) : super(key: key);

  @override
  State<PlcCommunicationProtocolPage> createState() =>
      _PlcCommunicationProtocolPageState();
}

class _PlcCommunicationProtocolPageState
    extends State<PlcCommunicationProtocolPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _PlcCommunicationProtocolViewGetX();
  }
}

class _PlcCommunicationProtocolViewGetX
    extends GetView<PlcCommunicationProtocolController> {
  const _PlcCommunicationProtocolViewGetX({Key? key}) : super(key: key);

  // Modbus命令号功能码
  Widget _buildModbus(context) {
    return Expander(
        initiallyExpanded: true,
        // headerHeight: 70,
        header: Padding(
            padding: EdgeInsets.only(left: 40.r),
            child: Text(
              'Modbus命令号功能码',
              style: FluentTheme.of(context).typography.display,
            ).fontWeight(FontWeight.bold).fontSize(16)),
        // header: const Text('Modbus命令号功能码'),
        content: Column(
            children: controller.modbusAreaList.map((e) {
          return FieldChange(
            isChanged: controller.isChanged(e.fieldKey),
            renderFieldInfo: e,
            showValue: controller.getFieldValue(e.fieldKey),
            onChanged: controller.onFieldChange,
          );
        }).toList()));
  }

  // 命令区
  Widget _buildCommand(context) {
    return Expander(
        // headerHeight: 70,
        header: Padding(
            padding: EdgeInsets.only(left: 40.r),
            child:
                Text('命令区', style: FluentTheme.of(context).typography.display)
                    .fontWeight(FontWeight.bold)
                    .fontSize(16)),
        // header: const Text('命令区'),
        content: Column(
            children: controller.commandAreaList.map((e) {
          return FieldChange(
            isChanged: controller.isChanged(e.fieldKey),
            renderFieldInfo: e,
            showValue: controller.getFieldValue(e.fieldKey),
            onChanged: controller.onFieldChange,
          );
        }).toList()));
  }

  // 扩展区
  Widget _buildExpandArea(context) {
    return Expander(
        // headerHeight: 70,
        header: Padding(
            padding: EdgeInsets.only(left: 40.r),
            child:
                Text('扩展区', style: FluentTheme.of(context).typography.display)
                    .fontWeight(FontWeight.bold)
                    .fontSize(16)),
        // header: const Text('扩展区'),
        content: Column(
            children: controller.expandAreaList.map((e) {
          return FieldChange(
            isChanged: controller.isChanged(e.fieldKey),
            renderFieldInfo: e,
            showValue: controller.getFieldValue(e.fieldKey),
            onChanged: controller.onFieldChange,
          );
        }).toList()));
  }

  // 监控区
  Widget _buildMonitorArea(context) {
    return Expander(
        // headerHeight: 70,
        header: Padding(
            padding: EdgeInsets.only(left: 40.r),
            child:
                Text('监控区', style: FluentTheme.of(context).typography.display)
                    .fontWeight(FontWeight.bold)
                    .fontSize(16)),
        content: Column(
            children: controller.monitorAreaList.map((e) {
          if (e is RenderCustomByTag) {
            return Container(
              margin: EdgeInsets.only(bottom: 5.r),
              child: _buildIdentificationArea(context),
            );
          } else if (e is RenderFieldInfo) {
            return FieldChange(
              isChanged: controller.isChanged(e.fieldKey),
              renderFieldInfo: e,
              showValue: controller.getFieldValue(e.fieldKey),
              onChanged: controller.onFieldChange,
            );
          }
          return Container();
        }).toList()));
  }

  // 货位区
  Widget _buildLocationArea(context) {
    return Expander(
        // headerHeight: 70,
        header: Padding(
            padding: EdgeInsets.only(left: 40.r),
            child:
                Text('货位区', style: FluentTheme.of(context).typography.display)
                    .fontWeight(FontWeight.bold)
                    .fontSize(16)),
        content: Column(
            children: controller.locationAreaList.map((e) {
          return FieldChange(
            isChanged: controller.isChanged(e.fieldKey),
            renderFieldInfo: e,
            showValue: controller.getFieldValue(e.fieldKey),
            onChanged: controller.onFieldChange,
          );
        }).toList()));
  }

  // 标识区
  Widget _buildIdentificationArea(context) {
    return Expander(
        // headerHeight: 70,
        header: Padding(
            padding: EdgeInsets.only(left: 40.r),
            child: Text('标识符 基础信息BaseInfo之下的按位区分标识',
                    style: FluentTheme.of(context).typography.display)
                .fontWeight(FontWeight.bold)
                .fontSize(16)),
        content: Column(
            children: controller.identificationAreaList.map((e) {
          return FieldChange(
            isChanged: controller.isChanged(e.fieldKey),
            renderFieldInfo: e,
            showValue: controller.getFieldValue(e.fieldKey),
            onChanged: controller.onFieldChange,
          );
        }).toList()));
  }

  // 对应区
  Widget _buildCorrespondingArea(context) {
    return Expander(
        // headerHeight: 70,
        header: Padding(
            padding: EdgeInsets.only(left: 40.r),
            child:
                Text('DB存储区', style: FluentTheme.of(context).typography.display)
                    .fontWeight(FontWeight.bold)
                    .fontSize(16)),
        content: Column(
            children: controller.correspondingAreaList.map((e) {
          return FieldChange(
            isChanged: controller.isChanged(e.fieldKey),
            renderFieldInfo: e,
            showValue: controller.getFieldValue(e.fieldKey),
            onChanged: controller.onFieldChange,
          );
        }).toList()));
  }

  // 主视图
  Widget _buildView(context) {
    return Column(
      children: [
        PageHeader(
            title: Text(
              'plc通讯协议设置',
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
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.r),
            child: Column(children: [
              _buildModbus(context),
              15.verticalSpacingRadius,
              _buildCommand(context),
              15.verticalSpacingRadius,
              _buildExpandArea(context),
              15.verticalSpacingRadius,
              _buildMonitorArea(context),
              15.verticalSpacingRadius,
              _buildLocationArea(context),
              // 15.verticalSpacingRadius,
              // _buildIdentificationArea(),
              15.verticalSpacingRadius,
              _buildCorrespondingArea(context)
            ]),
          ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlcCommunicationProtocolController>(
      init: PlcCommunicationProtocolController(),
      id: "plc_communication_protocol",
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
