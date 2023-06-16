/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-14 09:26:02
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-15 14:12:02
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/plc/plc_communication_protocol/view.dart
 * @Description: 通讯协议设置界面
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/components/field_change.dart';
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
  Widget _buildModbus() {
    return Expander(
        initiallyExpanded: true,
        header: const Text('Modbus命令号功能码'),
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
  Widget _buildCommand() {
    return Expander(
        header: const Text('命令区'),
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
  Widget _buildExpandArea() {
    return Expander(
        header: const Text('扩展区'),
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
  Widget _buildMonitorArea() {
    return Expander(
        header: const Text('监控区'),
        content: Column(
            children: controller.monitorAreaList.map((e) {
          return FieldChange(
            isChanged: controller.isChanged(e.fieldKey),
            renderFieldInfo: e,
            showValue: controller.getFieldValue(e.fieldKey),
            onChanged: controller.onFieldChange,
          );
        }).toList()));
  }

  // 货位区
  Widget _buildLocationArea() {
    return Expander(
        header: const Text('货位区'),
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
  Widget _buildIdentificationArea() {
    return Expander(
        header: const Text('标识符 基础信息BaseInfo之下的按位区分标识'),
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
  Widget _buildCorrespondingArea() {
    return Expander(
        header: const Text('对应区'),
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
  Widget _buildView() {
    return Column(
      children: [
        15.verticalSpacingRadius,
        _buildModbus(),
        15.verticalSpacingRadius,
        _buildCommand(),
        15.verticalSpacingRadius,
        _buildExpandArea(),
        15.verticalSpacingRadius,
        _buildMonitorArea(),
        15.verticalSpacingRadius,
        _buildLocationArea(),
        15.verticalSpacingRadius,
        _buildIdentificationArea(),
        15.verticalSpacingRadius,
        _buildCorrespondingArea()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlcCommunicationProtocolController>(
      init: PlcCommunicationProtocolController(),
      id: "plc_communication_protocol",
      builder: (_) {
        return ScaffoldPage.scrollable(
          children: [
            PageHeader(
                title: Text('plc通讯协议设置'),
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
            _buildView()
          ],
        );
      },
    );
  }
}
