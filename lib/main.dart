/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-05-17 10:05:30
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-14 15:10:08
 * @FilePath: /eatm_ini_config/lib/main.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import './pages/configAutomation/configAutomation_main.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iniConfig/common/routers/index.dart';

import 'common/routers/pages.dart';
import 'common/store/config.dart';

void main() {
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    final initialSize = Size(1360, 768);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Eatm自动化ini文件配置工具";
    win.show();
  });
  Get.put<ConfigStore>(ConfigStore());
}

// 重写滚动行为
class MyCustomScrollBehavior extends material.MaterialScrollBehavior {
// Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1920, 1080),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return FluentApp(
            debugShowCheckedModeBanner: false,
            home: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              // color: AppTheme.systemAccentColor,
              themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              theme: material.ThemeData(
                primarySwatch: material.Colors.blue,
                visualDensity: VisualDensity.standard,
                fontFamily: 'MyFont',
                // primaryColor: AppTheme.systemAccentColor,
              ),
              darkTheme: material.ThemeData(
                primarySwatch: material.Colors.blue,
                visualDensity: VisualDensity.standard,
                fontFamily: 'MyFont',
                // primaryColor: systemAccentColor,
              ),
              title: 'Eatm自动化ini文件配置工具',
              initialRoute: RouteNames.main,
              localizationsDelegates: [
                FluentLocalizations.delegate,
              ],
              getPages: RoutePages.list,
              scrollBehavior: MyCustomScrollBehavior(),
              navigatorObservers: [FlutterSmartDialog.observer],
              builder: FlutterSmartDialog.init(),
            ),
          );
        });
  }
}
