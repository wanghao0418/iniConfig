/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-21 09:57:41
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-25 18:06:42
 * @FilePath: /eatm_ini_config/lib/pages/setting/store_settings/program_management/mac_program_source/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class MacProgramSourceController extends GetxController {
  MacProgramSourceController();
  List sectionList = ['1', '2', '3'];
  var currentSection = '1'.obs;

  onSectionChange(String value) {
    currentSection.value = value;
    update(["mac_program_source"]);
  }

  _initData() {
    update(["mac_program_source"]);
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
      currentSection = sectionList.isNotEmpty ? sectionList.first : "";
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
