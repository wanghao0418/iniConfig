/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 15:58:21
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-25 18:12:16
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/collection_service/in_line_mac/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class InLineMacController extends GetxController {
  InLineMacController();
  List sectionList = ['mac01', 'mac02', 'mac03', 'mac04', 'mac05'];
  final List selectedSections = [];

  _initData() {
    update(["in_line_mac"]);
  }

  void getSectionList() async {
    ResponseApiBody res = await CommonApi.getSectionList({
      "params": [
        {
          "list_node": "ScanDevice",
          "parent_node": null,
        }
      ],
    });
    if (res.success == true) {
      // 查询成功
      var data = res.data;
      sectionList = ((data as List).first as String).split('-');
      _initData();
    } else {
      // 查询失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
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
