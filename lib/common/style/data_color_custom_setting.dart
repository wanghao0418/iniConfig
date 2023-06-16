import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// @author eatm

/// @date  2023/1/9

/// @email

/// @description data_color_custom_setting

class DataColorCustomSetting {
  double _dBorderDistance;
  bool _isDarkMode;
  Color _ColorBg; //深色界面背景颜色
  Color _ColorBgLight; //浅色界面背景颜色
  Color _ColorWidget; //深色widget背景颜色
  Color _ColorWidgetLight; //浅色widget背景颜色
  BoxShadow _boxShadow;
  Color _ColorGridTheme; //列表深色鼠标放上去颜色
  Color _ColorGridThemeLight; //列表浅色鼠标放上去颜色
  Color _ColorGridThemeSelect; //列表选中颜色
  double _expandMenuOpenWidth; //左边抽屉打开宽度
  double _expandMenuCloseWidth; //左边抽屉关闭时宽度

  DataColorCustomSetting(
      this._dBorderDistance,
      this._isDarkMode,
      this._ColorBg,
      this._ColorBgLight,
      this._ColorWidget,
      this._ColorWidgetLight,
      this._boxShadow,
      this._ColorGridTheme,
      this._ColorGridThemeLight,
      this._ColorGridThemeSelect,
      this._expandMenuOpenWidth,
      this._expandMenuCloseWidth) {
    _dBorderDistance = 15.0;
    _isDarkMode = false;
    _ColorBg = const Color(0xFF1E1E28);
    _ColorBgLight = const Color(0xffebedef);
    _ColorWidget = const Color(0xe427293d);
//  _ColorWidget = const Color(0xff1f1f1f);
    _ColorWidgetLight = const Color(0xfff5f6fa);
    _boxShadow = const BoxShadow(
        color: Colors.black12,
        offset: Offset(0.0, 0.0), //阴影x轴偏移量
        blurRadius: 8, //阴影模糊程度
        spreadRadius: 2 //阴影扩散程度
        );

    _ColorGridTheme = const Color(0xFF72A8CE);
    _ColorGridThemeLight = const Color(0xFF72A8CE);
    _ColorGridThemeSelect = const Color(0x72A8CEFF);

    _expandMenuOpenWidth = 240;
    _expandMenuCloseWidth = 80;
  }

  double get BorderDistance {
    return _dBorderDistance;
  }

  get isDarkMode {
    return _isDarkMode;
  }

  set isDarkModeSet(isDarkMode) {
    _isDarkMode = isDarkMode;
  }

  Color get ColorBg {
    return _ColorBg;
  }

  Color get ColorBgLight {
    return _ColorBgLight;
  }

  Color get ColorWidget {
    return _ColorWidget;
  }

  Color get ColorWidgetLight {
    return _ColorWidgetLight;
  }

  Color get ColorGridTheme {
    return _ColorGridTheme;
  }

  Color get ColorGridThemeLight {
    return _ColorGridThemeLight;
  }

  Color get ColorGridThemeSelect {
    return _ColorGridThemeSelect;
  }

  double get expandMenuOpenWidth {
    return _expandMenuOpenWidth;
  }

  double get expandMenuCloseWidth {
    return _expandMenuCloseWidth;
  }

  get boxShadow {
    return _boxShadow;
  }

  static DataColorCustomSetting init() {
    return DataColorCustomSetting(
      10.0,
      false,
      const Color(0xFF1E1E28),
      //const Color.fromARGB(255, 65, 65, 65),
      const Color(0xffebedef),
      const Color(0xff27293D),
      //_ColorWidget = const Color.fromARGB(255, 38,52,61),
      const Color(0xfff5f6fa),
      const BoxShadow(
          color: Colors.black12,
          offset: Offset(0.0, 0.0), //阴影x轴偏移量
          blurRadius: 8, //阴影模糊程度
          spreadRadius: 3 //阴影扩散程度
          ),
      const Color(0xBB69EEFD),
      const Color(0xFFBDB365),
      const Color(0x72A8CEFF),
      240.0,
      60.0,
    );
  }
}
