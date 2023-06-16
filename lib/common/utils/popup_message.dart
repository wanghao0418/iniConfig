/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-14 14:48:08
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-14 15:18:35
 * @FilePath: /eatm_ini_config/lib/common/utils/popup_message.dart
 * @Description: 弹窗消息
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class PopupMessage {
  static void showSuccessInfoBar(String message) {
    SmartDialog.show(
        debounce: true,
        alignment: Alignment.topCenter,
        maskColor: Colors.transparent,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(top: 10),
            child: InfoBar(
              title: const Text('成功'),
              content: Text(message),
              action: IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: () {
                  SmartDialog.dismiss();
                },
              ),
              severity: InfoBarSeverity.success,
            ),
          );
        });
  }

  static void showFailInfoBar(String message) {
    SmartDialog.show(
        debounce: true,
        alignment: Alignment.topCenter,
        maskColor: Colors.transparent,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(top: 10),
            child: InfoBar(
              title: const Text('失败'),
              content: Text(message),
              action: IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: () {
                  SmartDialog.dismiss();
                },
              ),
              severity: InfoBarSeverity.error,
            ),
          );
        });
  }
}
