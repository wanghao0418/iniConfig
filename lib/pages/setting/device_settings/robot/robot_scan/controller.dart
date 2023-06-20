/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-15 14:03:26
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-19 17:35:59
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/robot/robot_scan/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import '../../../../../common/components/field_change.dart';
import 'widgets/scan_device_form.dart';

class RobotScanController extends GetxController {
  RobotScanController();
  RobotScan robotScan = RobotScan();
  List<RenderFieldInfo> menuList = [
    RenderFieldInfo(
        section: 'ScanDevice',
        field: 'index',
        name: '扫描设备索引',
        renderType: RenderType.input),
    RenderFieldInfo(
        section: 'ScanDevice',
        field: 'total',
        name: '扫描设备总数',
        renderType: RenderType.numberInput),
  ];
  List<String> changedList = [];
  List deviceList = ['扫码1', '扫码2', '扫码3'];
  String currentDeviceId = "";
  GlobalKey scanDeviceKey = GlobalKey();

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = robotScan.toJson();
    temp[field] = val;
    robotScan = RobotScan.fromJson(temp);
  }

  String? getFieldValue(String field) {
    return robotScan.toJson()[field];
  }

  void onFieldChange(String field, String value) {
    if (value == getFieldValue(field)) {
      return;
    }
    if (!changedList.contains(field)) {
      changedList.add(field);
    }
    setFieldValue(field, value);
    update(["robot_scan"]);
  }

  void onDeviceChange(String deviceId) {
    currentDeviceId = deviceId;
    update(["robot_scan"]);
  }

  _initData() {
    update(["robot_scan"]);
  }

  void save() {
    var list = (scanDeviceKey.currentState! as ScanDeviceStateForm).onSave();
    print(list);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

class RobotScan {
  String? scanDeviceIndex;
  String? scanDeviceTotal;

  RobotScan({this.scanDeviceIndex, this.scanDeviceTotal});

  RobotScan.fromJson(Map<String, dynamic> json) {
    scanDeviceIndex = json['ScanDevice/index'];
    scanDeviceTotal = json['ScanDevice/total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ScanDevice/index'] = this.scanDeviceIndex;
    data['ScanDevice/total'] = this.scanDeviceTotal;
    return data;
  }
}
