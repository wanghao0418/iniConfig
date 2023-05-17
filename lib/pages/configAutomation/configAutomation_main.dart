/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-04-12 14:36:33
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-05-17 15:12:13
 * @FilePath: /mesui/lib/pages/configAutomation/configAutomation_main.dart
 * @Description: 自动化配置
 */

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../components/customCard.dart';
import '../../common/data_color_custom_setting.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:ini/ini.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, MethodChannel, PlatformException, rootBundle;
import 'annotationTextMap.dart';
import 'componentMap.dart';
import 'fieldChineseMap.dart';
import 'package:path/path.dart' as Path;
import 'scalableField.dart';

class ConfigAutomation extends StatefulWidget {
  const ConfigAutomation({Key? key}) : super(key: key);

  @override
  _ConfigAutomationState createState() => _ConfigAutomationState();
}

class _ConfigAutomationState extends State<ConfigAutomation> {
  final DataColorCustomSetting _colorCustomSetting =
      DataColorCustomSetting.init();
  late bool _isDart = false;
  final configController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _filePath = '';
  // 当前高亮配置tab索引
  int _currentConfigIndex = 0;
  // 当前高亮section索引
  int _currentSectionIndex = 0;

  late final _publicPath;
  late File plcFile;
  late File userFile;
  late File uiFile;
  late Config plcConfig;
  late Config userConfig;
  late Config uiConfig;

  Map<String, Map<String, String>> _plcSectionMap = {};
  Map<String, Map<String, String>> _userSectionMap = {};
  Map<String, Map<String, String>> _uiSectionMap = {};

  Map<String, Map<String, String>> get _sectionMap {
    if (_currentConfigIndex == 0) {
      return _plcSectionMap;
    } else if (_currentConfigIndex == 1) {
      return _userSectionMap;
    } else if (_currentConfigIndex == 2) {
      return _uiSectionMap;
    } else {
      return {};
    }
  }

  String get currentSection {
    return _sectionMap.keys.toList().length > 0
        ? _sectionMap.keys.toList()[_currentSectionIndex]
        : '';
  }

  String get currentConfigName {
    return _currentConfigIndex == 0
        ? 'plcAddress'
        : _currentConfigIndex == 1
            ? 'userConfig'
            : _currentConfigIndex == 2
                ? 'ui'
                : '';
  }

  void _openDirectory() async {
    if (await Directory(_publicPath).exists()) {
      var path = Path.join(_publicPath, 'config');
      if (Platform.isWindows) {
        await Process.run('explorer.exe', [path]);
      }
    } else {
      print('目录不存在');
    }
  }

  String _getCurrentOptionKey(index) =>
      _sectionMap[currentSection]?.keys?.toList()[index] ?? '';
  String _getCurrentOptionValue(index) =>
      _sectionMap[currentSection]?.values?.toList()[index] ?? '';

  // 初始化配置文件
  Future<void> copyAssetToLocal() async {
    _publicPath = (await path_provider.getApplicationDocumentsDirectory()).path;
    plcFile = new File("$_publicPath/config/plcAddress.ini");
    userFile = new File("$_publicPath/config/userConfig.ini");
    uiFile = new File("$_publicPath/config/ui.ini");

    [plcFile, userFile, uiFile].forEach((file) async {
      var index = [plcFile, userFile, uiFile].indexOf(file);
      var assetData;
      if (!file.existsSync()) {
        if (index == 0) {
          assetData = await rootBundle.load('config/plcAddress.ini');
        } else if (index == 1) {
          assetData = await rootBundle.load('config/userConfig.ini');
        } else if (index == 2) {
          assetData = await rootBundle.load('config/ui.ini');
        }
        final bytes = assetData.buffer
            .asUint8List(assetData.offsetInBytes, assetData.lengthInBytes);
        file.createSync(recursive: true);
        await file.writeAsBytes(bytes);
      }
    });

    _readConfig();
  }

  void _readConfig() async {
    plcConfig = new Config.fromStrings(plcFile.readAsLinesSync());
    userConfig = new Config.fromStrings(userFile.readAsLinesSync());
    uiConfig = new Config.fromStrings(uiFile.readAsLinesSync());
    List<Config> configList = [plcConfig, userConfig, uiConfig];
    configList.forEach((config) {
      Map<String, Map<String, String>> sectionsMap = {};
      var index = configList.indexOf(config);
      config.sections().forEach((section) {
        // Log.i(section);
        Map<String, String> optionMap = {};
        config.options(section)!.forEach((opntion) {
          optionMap[opntion] = config.get(section, opntion) ?? '';
        });
        sectionsMap[section] = optionMap;
      });
      if (index == 0) {
        _plcSectionMap = sectionsMap;
      } else if (index == 1) {
        _userSectionMap = sectionsMap;
      } else if (index == 2) {
        _uiSectionMap = sectionsMap;
      }
    });
    setState(() {});
  }

  // 写入配置
  void _writeConfig() async {
    plcFile.writeAsString(plcConfig.toString());
    userFile.writeAsString(userConfig.toString());
    uiFile.writeAsString(uiConfig.toString());
    final snackBar = SnackBar(content: Text('保存成功'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // 管理拓展字段
  void _onFieldExpand(
      String title,
      String field,
      Map<String, Map<String, String>> sectionMap,
      Config config,
      String configName,
      {Function? onFinishCallBack = null}) {
    // SmartDialog.show(builder: (context) {
    //   return Container(
    //     child: CustomCard(
    //         title: title,
    //         padding: EdgeInsets.all(10),
    //         containChild: Container(
    //           child: ScalableField(
    //             field: field,
    //             section: sectionMap,
    //             onConfirmCallBack: (Map newSectionsMap) {
    //               Log.i(newSectionsMap);
    //               RegExp regExp = RegExp('^${field}(\\d+)\$');
    //               // 先删除原有section
    //               var oldSections = config
    //                   .sections()
    //                   .where((section) => regExp.hasMatch(section))
    //                   .toList();
    //               oldSections.forEach((section) {
    //                 config.removeSection(section);
    //                 sectionMap.remove(section);
    //               });
    //               // 再添加新的section
    //               newSectionsMap.forEach((section, optionMap) {
    //                 config.addSection(section);
    //                 optionMap.forEach((option, value) {
    //                   config.set(section, option, value);
    //                 });
    //                 sectionMap[section] = optionMap;
    //                 // if (sectionMap[section] != null) {
    //                 //   sectionMap[section]!.addAll(optionMap);
    //                 // } else {
    //                 //   sectionMap[section] = optionMap;
    //                 // }
    //               });
    //               if (onFinishCallBack != null) {
    //                 var newSections = newSectionsMap.keys.toList();
    //                 onFinishCallBack(newSections);
    //               }
    //               setState(() {});
    //             },
    //           ),
    //         )),
    //   ).width(800).height(600);
    // });

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              child: CustomCard(
                  title: title,
                  padding: EdgeInsets.all(10),
                  containChild: Container(
                    child: ScalableField(
                      context: context,
                      field: field,
                      section: sectionMap,
                      configName: configName,
                      onConfirmCallBack: (Map newSectionsMap) {
                        RegExp regExp = RegExp('^${field}(\\d+)\$');
                        // 先删除原有section
                        var oldSections = config
                            .sections()
                            .where((section) => regExp.hasMatch(section))
                            .toList();
                        oldSections.forEach((section) {
                          config.removeSection(section);
                          sectionMap.remove(section);
                        });
                        // 再添加新的section
                        newSectionsMap.forEach((section, optionMap) {
                          config.addSection(section);
                          optionMap.forEach((option, value) {
                            config.set(section, option, value);
                          });
                          sectionMap[section] = optionMap;
                          // if (sectionMap[section] != null) {
                          //   sectionMap[section]!.addAll(optionMap);
                          // } else {
                          //   sectionMap[section] = optionMap;
                          // }
                        });
                        if (onFinishCallBack != null) {
                          var newSections = newSectionsMap.keys.toList();
                          onFinishCallBack(newSections);
                        }
                        setState(() {});
                      },
                    ),
                  )),
            ).width(1200).height(600)));
  }

  // 导航到指定section
  void _navigateToSection(int configIndex, String section) {
    var curSectionMap = configIndex == 0
        ? _plcSectionMap
        : configIndex == 1
            ? _userSectionMap
            : _uiSectionMap;
    var index = curSectionMap.keys.toList().indexOf(section);
    if (index != -1) {
      setState(() {
        _currentConfigIndex = configIndex;
        _currentSectionIndex = index;
      });
    }
    // 滚动到当前section
    _scrollController.animateTo((40 * index).toDouble(),
        duration: Duration(milliseconds: 100), curve: Curves.ease);
  }

  Widget _renderTopLine() {
    return SizedBox(
      height: 60,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentConfigIndex = 0;
                        _currentSectionIndex = 0;
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                          width: 120,
                          height: 40,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: _currentConfigIndex == 0
                                  ? Colors.white
                                  : Color(0xff999999),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4)),
                              boxShadow: _currentConfigIndex == 0
                                  ? [
                                      BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 0),
                                          blurRadius: 10,
                                          spreadRadius: 0)
                                    ]
                                  : []),
                          alignment: Alignment.center,
                          child: Text('plc设置').textColor(
                              _currentConfigIndex == 0
                                  ? Color(0xff1C5CFF)
                                  : Colors.white)),
                    )),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentConfigIndex = 1;
                        _currentSectionIndex = 0;
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                          width: 120,
                          height: 40,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: _currentConfigIndex == 1
                                  ? Colors.white
                                  : Color(0xff999999),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4)),
                              boxShadow: _currentConfigIndex == 1
                                  ? [
                                      BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 0),
                                          blurRadius: 10,
                                          spreadRadius: 0)
                                    ]
                                  : []),
                          alignment: Alignment.center,
                          child: Text('用户设置').textColor(_currentConfigIndex == 1
                              ? Color(0xff1C5CFF)
                              : Colors.white)),
                    )),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentConfigIndex = 2;
                        _currentSectionIndex = 0;
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                          width: 120,
                          height: 40,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: _currentConfigIndex == 2
                                  ? Colors.white
                                  : Color(0xff999999),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4)),
                              boxShadow: _currentConfigIndex == 2
                                  ? [
                                      BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 0),
                                          blurRadius: 10,
                                          spreadRadius: 0)
                                    ]
                                  : []),
                          alignment: Alignment.center,
                          child: Text('UI设置').textColor(_currentConfigIndex == 2
                              ? Color(0xff1C5CFF)
                              : Colors.white)),
                    ))
              ],
            ),
            Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          blurRadius: 10,
                          spreadRadius: 0)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ElevatedButton(onPressed: () {}, child: Text('新增配置')),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    ElevatedButton(
                        onPressed: () {
                          _openDirectory();
                        },
                        child: Text('打开目录')),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: '$_publicPath/config'));
                          final snackBar = SnackBar(content: Text('复制成功'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: Text('复制目录')),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xff6ED760))),
                        onPressed: () {
                          _writeConfig();
                        },
                        child: Text('保存设置')),
                  ],
                ))
          ]),
    );
  }

  // 纵向间距
  Widget _renderColumnDistanceBox() => SizedBox(
        height: _colorCustomSetting.BorderDistance,
      );

  // 快捷配置入口
  Widget _renderQuicklyEntries() {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              GestureDetector(
                  child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 120,
                        height: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0, 0),
                                  blurRadius: 10,
                                  spreadRadius: 0)
                            ]),
                        alignment: Alignment.center,
                        child: Text('常用快捷配置').textColor(Color(0xff1C5CFF)),
                      ))),
            ],
          ),
        ),
        Container(
          // height: 50,
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4)),
            color: Colors.white,
          ),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _onFieldExpand(
                        '机床管理',
                        'MachineInfo',
                        _userSectionMap,
                        userConfig,
                        'userConfig', onFinishCallBack: (List sections) {
                      _userSectionMap['MacInfo']!['total'] =
                          sections.length.toString();
                      _userSectionMap['MacInfo']!['index'] = sections.join('-');
                      // 更改MacInfo配置
                      userConfig.set(
                          'MacInfo', 'total', sections.length.toString());
                      userConfig.set('MacInfo', 'index', sections.join('-'));
                    });
                  },
                  child: Text('机床管理')),
              ElevatedButton(
                  onPressed: () {
                    _onFieldExpand(
                        '线外机床管理',
                        'TestCMMInfo',
                        _userSectionMap,
                        userConfig,
                        'userConfig', onFinishCallBack: (List sections) {
                      _userSectionMap['MacCollectionInfo']!['total'] =
                          sections.length.toString();
                      _userSectionMap['MacCollectionInfo']!['index'] =
                          sections.join('-');
                      // 更改MacInfo配置
                      userConfig.set('MacCollectionInfo', 'total',
                          sections.length.toString());
                      userConfig.set(
                          'MacCollectionInfo', 'index', sections.join('-'));
                    });
                  },
                  child: Text('线外机床管理')),
              ElevatedButton(
                  onPressed: () {
                    _onFieldExpand(
                        '货架管理', 'Shelf', _uiSectionMap, uiConfig, 'ui',
                        onFinishCallBack: (List sections) {
                      _uiSectionMap['ShelfInfo']!['total'] =
                          sections.length.toString();
                      _uiSectionMap['ShelfInfo']!['index'] = sections.join('-');
                      // 更改ShelfInfo配置
                      uiConfig.set(
                          'ShelfInfo', 'total', sections.length.toString());
                      uiConfig.set('ShelfInfo', 'index', sections.join('-'));
                    });
                  },
                  child: Text('货架管理')),
              ElevatedButton(
                  onPressed: () {
                    _onFieldExpand(
                        '扫码设备管理',
                        'ScanDevice',
                        _userSectionMap,
                        userConfig,
                        'userConfig', onFinishCallBack: (List sections) {
                      _userSectionMap['ScanDeviceInfo']!['total'] =
                          sections.length.toString();
                      _userSectionMap['ScanDeviceInfo']!['index'] =
                          sections.join('-');
                      // 更改ShelfInfo配置
                      userConfig.set('ScanDeviceInfo', 'total',
                          sections.length.toString());
                      userConfig.set(
                          'ScanDeviceInfo', 'index', sections.join('-'));
                    });
                  },
                  child: Text('扫码设备管理')),
              ElevatedButton(
                  onPressed: () {
                    _navigateToSection(1, 'DataBaseInfo');
                  },
                  child: Text('DB配置')),
              ElevatedButton(
                  onPressed: () {
                    _navigateToSection(0, 'RobotTaskPosition');
                  },
                  child: Text('机器人配置')),
              ElevatedButton(
                  onPressed: () {
                    _navigateToSection(1, 'PrgServerInfo');
                  },
                  child: Text('Prg配置')),
              // ElevatedButton(onPressed: () {}, child: Text('Prg配置')),
              // ElevatedButton(onPressed: () {}, child: Text('Prg配置')),
              // ElevatedButton(onPressed: () {}, child: Text('Prg配置')),
              // ElevatedButton(onPressed: () {}, child: Text('Prg配置')),
              // ElevatedButton(onPressed: () {}, child: Text('Prg配置')),
              // ElevatedButton(onPressed: () {}, child: Text('Prg配置')),
              // ElevatedButton(onPressed: () {}, child: Text('Prg配置')),
              // ElevatedButton(onPressed: () {}, child: Text('Prg配置')),
            ],
          ),
        )
      ],
    );
  }

  // 主内容
  Widget _renderMainContent() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
      ),
      child: Row(
        children: [
          _renderSideBar(),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: _sectionMap[currentSection] != null
                  ? ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          height: 1,
                          color: Colors.grey[400],
                        );
                      },
                      itemBuilder: ((context, index) {
                        var optionKey = _getCurrentOptionKey(index);
                        var optionValue = _getCurrentOptionValue(index);
                        return renderComponent(optionKey, optionValue,
                            (newVal) {
                          var configList = [userConfig, plcConfig, uiConfig];
                          var currentConfig = configList
                              .where((config) =>
                                  config.hasOption(currentSection, optionKey) &&
                                  config.hasSection(currentSection))
                              .toList()
                              .first;
                          if (currentConfig != null) {
                            currentConfig.set(
                                currentSection, optionKey, newVal);
                          }
                          print(newVal);
                          // 如果是拼接组件，则需要重新渲染
                          if (getComponentType(optionKey, currentSection,
                                  currentConfigName) ==
                              RenderComponents.splitJoint) {
                            setState(() {
                              _sectionMap[currentSection]![optionKey] = newVal;
                            });
                          }
                        }, currentSection, currentConfigName, context);
                      }),
                      itemCount:
                          _sectionMap[currentSection]!.values.toList().length)
                  : Container()),
        ],
      ),
    );
  }

  // 侧边栏
  Widget _renderSideBar() {
    return CustomCard(
        cardBackgroundColor: Color(0xffE9F2FF),
        containChild: Container(
          width: 200,
          height: double.infinity,
          padding: EdgeInsets.all(5),
          child: _sectionMap.length > 0
              ? ListView.builder(
                  controller: _scrollController,
                  itemBuilder: ((context, index) {
                    return _renderSection(
                            _sectionMap.keys.toList()[index], index) ??
                        Container();
                  }),
                  itemCount: _sectionMap.length)
              : Container(),
        ));
  }

  // 渲染节点
  Widget _renderSection(section, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentSectionIndex = index;
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Tooltip(
          message: getFieldChinese(section),
          child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Text(
                    getFieldChinese(section),
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                  )
                      .textColor(_currentSectionIndex == index
                          ? Color(0xff1677FF)
                          : Color(0xff5E5E5E))
                      .fontSize(18)
                      .textAlignment(TextAlign.center))
              .decorated(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  color: _currentSectionIndex == index
                      ? Color(0xffE9F2FF)
                      : Colors.white,
                  boxShadow: _currentSectionIndex == index
                      ? []
                      : [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 0),
                              blurRadius: 10,
                              spreadRadius: 0)
                        ]),
        ),
      ).height(40).padding(all: 5),
    );
  }

  // // 输入组件
  // Widget _renderInputWidget(String title, String value, {String? hintText}) {
  //   return Container(
  //     padding: EdgeInsets.all(10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Expanded(
  //             child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(title).fontWeight(FontWeight.bold).fontSize(20),
  //             SizedBox(
  //               height: 10.0,
  //             ),
  //             hintText != null
  //                 ? Text(hintText).fontSize(12).textColor(Color(0xff999999))
  //                 : Text('')
  //           ],
  //         )),
  //         Container(
  //             child: TextField(
  //           controller: TextEditingController(text: value),
  //           decoration: InputDecoration(
  //               label: Text(title),
  //               border: OutlineInputBorder(),
  //               hintText: '请输入$title'),
  //           onChanged: (value) {
  //             plcConfig.set(currentSection, title, value);
  //           },
  //         )).width(300)
  //       ],
  //     ),
  //   );
  // }

  // // 下拉选择组件
  // Widget _renderSelectWidget(String title, String value, List<String> options,
  //     {String? hintText}) {
  //   return Container(
  //     padding: EdgeInsets.all(10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Expanded(
  //             child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(title).fontWeight(FontWeight.bold).fontSize(20),
  //             SizedBox(
  //               height: 10.0,
  //             ),
  //             hintText != null
  //                 ? Text(hintText).fontSize(12).textColor(Color(0xff999999))
  //                 : Text('')
  //           ],
  //         )),
  //         Container(
  //             child: DropdownButton(
  //           value: value,
  //           items: options.map((e) {
  //             return DropdownMenuItem(
  //               child: Text(e),
  //               value: e,
  //             );
  //           }).toList(),
  //           onChanged: (value) {
  //             plcConfig.set(currentSection, title, value.toString());
  //           },
  //         )).width(300)
  //       ],
  //     ),
  //   );
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _readConfig();
    if (kIsWeb) {
    } else {
      copyAssetToLocal();
    }
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    _isDart = isDarkMode(context);
    return Scaffold(
      body: Container(
          color: _isDart
              ? _colorCustomSetting!.ColorBg
              : _colorCustomSetting.ColorBgLight,
          padding: EdgeInsets.fromLTRB(
              _colorCustomSetting!.BorderDistance,
              _colorCustomSetting!.BorderDistance,
              _colorCustomSetting!.BorderDistance,
              _colorCustomSetting!.BorderDistance),
          child: Column(children: [
            _renderQuicklyEntries(),
            _renderColumnDistanceBox(),
            _renderTopLine(),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10),
              child: _renderMainContent(),
            ).backgroundColor(Colors.white).boxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 10),
                    blurRadius: 10,
                    spreadRadius: 0))
          ])),
    );
  }
}
