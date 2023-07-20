/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-20 10:25:25
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 17:16:26
 * @FilePath: /iniConfig/lib/common/style/global_theme.dart
 * @Description: 全局主题控制器
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GlobalTheme extends GetxController {
  static GlobalTheme get instance => Get.find<GlobalTheme>();
  final GetStorage _storage = GetStorage('globalTheme');
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  set isDarkMode(bool value) {
    _isDarkMode.value = value;
    _mode = value ? ThemeMode.dark : ThemeMode.light;
    _storage.write('isDarkMode', value);
    Get.forceAppUpdate();
  }

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  set mode(ThemeMode mode) {
    _mode = mode;
    Get.forceAppUpdate();
  }

  AccentColor _accentColor = Colors.blue;
  AccentColor get accentColor => _accentColor;
  set accentColor(AccentColor color) {
    _accentColor = color;
    Get.forceAppUpdate();
  }

  PaneDisplayMode _navigationIndicator = PaneDisplayMode.auto;
  PaneDisplayMode get navigationIndicator => _navigationIndicator;
  set navigationIndicator(PaneDisplayMode mode) {
    _navigationIndicator = mode;
    _storage.write('navigationIndicator', mode.toString());
    Get.forceAppUpdate();
  }

  Color get buttonIconColor => _isDarkMode.value ? Colors.white : Colors.black;

  _initStore() {
    int readAccentColorIndex = _storage.read('accentColorIndex') ?? 5;
    bool readIsDarkMode = _storage.read('isDarkMode') ?? false;
    String readNavigationIndicator =
        _storage.read('navigationIndicator') ?? 'PaneDisplayMode.auto';

    Future.delayed(Duration.zero).then((value) {
      isDarkMode = readIsDarkMode;
      accentColor = Colors.accentColors[readAccentColorIndex];
      navigationIndicator = PaneDisplayMode.values.firstWhere(
          (element) => element.toString() == readNavigationIndicator);
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    // 初始化主题色、模式、导航指示器
    _initStore();
  }
}
