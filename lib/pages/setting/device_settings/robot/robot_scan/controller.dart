/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-15 14:03:26
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-27 10:46:29
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/robot/robot_scan/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import '../../../../../common/api/common.dart';
import '../../../../../common/components/field_change.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';
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

  void getSectionList() async {
    ResponseApiBody res = await CommonApi.getSectionList({
      "params": [
        {
          "list_node": "TcpScanDriverInfo",
          "parent_node": null,
        }
      ],
    });
    if (res.success == true) {
      // 查询成功
      var data = res.data;
      deviceList = ((data as List).first as String).split('-');
      currentDeviceId = deviceList.isNotEmpty ? deviceList.first : "";
      _initData();
    } else {
      // 查询失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 新增
  void add() async {
    var res = await CommonApi.addSection({
      "params": [
        {
          "list_node": "TcpScanDriverInfo",
          "parent_node": null,
        }
      ],
    });
    if (res.success == true) {
      // 新增成功
      // getSectionList();
      deviceList.add((res.data as List).first as String);
      _initData();
    } else {
      // 新增失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 删除
  void delete() async {
    var res = await CommonApi.deleteSection({
      "params": [
        {
          "list_node": currentDeviceId,
          "parent_node": null,
        }
      ],
    });
    if (res.success == true) {
      // 删除成功
      // getSectionList();
      deviceList.remove(currentDeviceId);
      currentDeviceId = deviceList.isNotEmpty ? deviceList.first : "";
      _initData();
    } else {
      // 删除失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  _initData() {
    update(["robot_scan"]);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    getSectionList();
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
