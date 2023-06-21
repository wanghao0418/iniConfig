import 'package:fluent_ui/fluent_ui.dart' hide Tab;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../setting/device_settings/collection_service/in_line_mac/view.dart';
import '../../setting/device_settings/collection_service/out_line_mac/view.dart';
import '../../setting/device_settings/machine/machine_info/view.dart';
import '../../setting/device_settings/plc/plc_communication_protocol/view.dart';
import '../../setting/device_settings/plc/plc_connection/view.dart';
import '../../setting/device_settings/plc/plc_function/view.dart';
import '../../setting/device_settings/robot/robot_communication_protocol/view.dart';
import '../../setting/device_settings/robot/robot_connection/view.dart';
import '../../setting/device_settings/robot/robot_scan/view.dart';
import '../../setting/device_settings/robot/robot_task/view.dart';
import '../../setting/device_settings/shelf_management/shelf_info/view.dart';
import '../../setting/device_settings/shelf_management/shelf_management_light/view.dart';
import '../../setting/store_settings/clamping_management/clamp_type_management/view.dart';
import '../../setting/store_settings/clamping_management/tray_settings/view.dart';
import '../../setting/store_settings/database/acquisition_database/view.dart';
import '../../setting/store_settings/database/database_connection/view.dart';
import '../../setting/store_settings/program_management/local_store_path/view.dart';
import '../../setting/store_settings/program_management/mac_program_source/view.dart';
import 'widgets/fluent_tab.dart';

class HomeController extends GetxController {
  HomeController();
  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
  final tabViewKey = GlobalKey(debugLabel: 'Tab View Key');
  final navigationPaneKey = GlobalKey(debugLabel: 'Navigation Pane Key');
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();
  var currentTabIndex = 0.obs;
  late PageController pageController;

  // var tabs = [].obs;
  Key? currentMenuKey = const Key('1-1');
  final List<NavigationPaneItem> menuItems = [];
  final List<NavigationPaneItem> footerItems = [
    PaneItemSeparator(),
    PaneItem(
      key: const Key('/settings'),
      icon: const Icon(FluentIcons.settings),
      title: const Text('Settings'),
      body: const SizedBox.shrink(),
      onTap: () {},
    ),
  ];

  final List<PrimaryMenu> menuList = [
    PrimaryMenu(id: '1', title: '设备设置', iconData: FluentIcons.list, children: [
      SecondaryMenu(id: '1-1', title: 'plc', children: [
        TertiaryMenu(
            id: '1-1-1', title: '连接设置', bodyPage: const PlcConnectionPage()),
        TertiaryMenu(
            id: '1-1-2', title: '功能设置', bodyPage: const PlcFunctionPage()),
        TertiaryMenu(
            id: '1-1-3',
            title: '通讯协议设置',
            bodyPage: const PlcCommunicationProtocolPage()),
      ]),
      SecondaryMenu(
          id: '1-2',
          title: '机器人',
          iconData: FluentIcons.robot,
          children: [
            TertiaryMenu(
                id: '1-2-1',
                title: '连接设置',
                bodyPage: const RobotConnectionPage()),
            TertiaryMenu(
                id: '1-2-2', title: '任务设置', bodyPage: const RobotTaskPage()),
            TertiaryMenu(
                id: '1-2-3', title: '扫码设置 ', bodyPage: const RobotScanPage()),
            TertiaryMenu(
                id: '1-2-4',
                title: '通讯协议设置 ',
                bodyPage: const RobotCommunicationProtocolPage()),
          ]),
      SecondaryMenu(
          id: '1-3',
          title: '货架管理',
          iconData: FluentIcons.branch_shelveset,
          children: [
            TertiaryMenu(id: '1-3-1', title: '货架信息', bodyPage: ShelfInfoPage()),
            TertiaryMenu(
                id: '1-3-2',
                title: '七色灯',
                bodyPage: const ShelfManagementLightPage()),
          ]),
      SecondaryMenu(
          id: '1-4',
          title: '机床',
          iconData: FluentIcons.connect_virtual_machine,
          children: [
            TertiaryMenu(
                id: '1-4-1', title: '机床管理', bodyPage: MachineInfoPage()),
            // TertiaryMenu(
            //     id: '1-4-2',
            //     title: '自动化设置',
            //     bodyPage: Container(
            //       child: Text('自动化设置'),
            //     )),
          ]),
      SecondaryMenu(
          id: '1-5',
          title: '采集服务',
          iconData: FluentIcons.server,
          children: [
            TertiaryMenu(
                id: '1-5-1', title: '线外机床', bodyPage: OutLineMacPage()),
            TertiaryMenu(id: '1-5-2', title: '线体机床', bodyPage: InLineMacPage()),
          ]),
      // SecondaryMenu(id: '1-6', title: '其他', children: [
      //   TertiaryMenu(
      //       id: '1-6-1',
      //       title: '七色灯',
      //       bodyPage: Container(
      //         child: Text('七色灯'),
      //       )),
      // ]),
    ]),
    PrimaryMenu(id: '2', title: '存储设置', iconData: FluentIcons.list, children: [
      SecondaryMenu(
          id: '2-1',
          title: '数据库',
          iconData: FluentIcons.save_all,
          children: [
            TertiaryMenu(
                id: '2-1-1',
                title: '自动化数据库',
                bodyPage: DatabaseConnectionPage()),
            TertiaryMenu(
                id: '2-1-2',
                title: '采集数据库',
                bodyPage: AcquisitionDatabasePage()),
          ]),
      SecondaryMenu(
          id: '2-2',
          title: '程序管理',
          iconData: FluentIcons.system,
          children: [
            TertiaryMenu(
                id: '2-2-1', title: '机床程序来源', bodyPage: MacProgramSourcePage()),
            TertiaryMenu(
                id: '2-2-2', title: '本地存储路径', bodyPage: LocalStorePathPage()),
          ]),
      SecondaryMenu(id: '2-3', title: '装夹管理', children: [
        TertiaryMenu(
            id: '2-3-1', title: '夹具类型管理', bodyPage: ClampTypeManagementPage()),
        TertiaryMenu(id: '2-3-2', title: '托盘管理', bodyPage: TraySettingsPage()),
      ]),
    ]),
    PrimaryMenu(id: '3', title: '系统设置', iconData: FluentIcons.list, children: [
      SecondaryMenu(id: '3-1', title: '功能设置', children: [
        TertiaryMenu(
            id: '3-1-1',
            title: '用户信息',
            bodyPage: Container(
              child: Text('用户信息'),
            )),
      ]),
      SecondaryMenu(id: '3-2', title: '行为设置', children: [
        TertiaryMenu(
            id: '3-2-1',
            title: '权限信息',
            bodyPage: Container(
              child: Text('权限信息'),
            )),
      ]),
    ]),
    PrimaryMenu(id: '4', title: '第三方设置', iconData: FluentIcons.list, children: [
      SecondaryMenu(id: '4-1', title: 'mes设置', children: [
        TertiaryMenu(
            id: '4-1-1',
            title: 'EACT',
            bodyPage: Container(
              child: Text('EACT'),
            )),
        TertiaryMenu(
            id: '4-1-2',
            title: 'EMAN',
            bodyPage: Container(
              child: Text('EMAN'),
            )),
      ]),
    ]),
  ];

  SecondaryMenu get currentSecondaryMenu {
    List<SecondaryMenu> secondaryMenus = [];
    for (var element in menuList) {
      secondaryMenus.addAll(element.children);
    }
    return secondaryMenus.firstWhere(
      (element) => Key(element.id) == currentMenuKey,
    );
  }

  // 获取三级菜单tab列表
  List<Tab> get currentTabs {
    return currentSecondaryMenu.children
        .map((e) => Tab(
              id: e.id,
              key: Key(e.id),
              text: Text(e.title),
              body: e.bodyPage,
            ))
        .toList();
  }

  // 初始化菜单
  void _initMenu() {
    for (var element in menuList) {
      menuItems.add(PaneItemExpander(
          key: Key(element.id),
          icon: Icon(element.iconData),
          title: Text(element.title),
          items: element.children
              .map((e) => PaneItem(
                    key: Key(e.id),
                    icon: Icon(e.iconData ?? FluentIcons.settings),
                    title: Text(e.title),
                    body: const SizedBox.shrink(),
                    onTap: () {
                      if (currentMenuKey == Key(e.id)) return;
                      currentMenuKey = Key(e.id);
                      currentTabIndex.value = 0;
                      update(['home']);
                    },
                  ))
              .toList(),
          body: const SizedBox.shrink()));
    }
  }

  // 获取可选菜单
  List<NavigationPaneItem> get canSelectMenuItems {
    List<NavigationPaneItem> items = [];
    for (var item in menuItems) {
      if (item is PaneItemExpander) {
        items.addAll([...item.items]);
      } else {
        items.add(item);
      }
    }
    return items;
  }

  int calculateSelectedIndex() {
    var flatMenuItems = [];
    for (var item in menuItems) {
      if (item is PaneItemExpander) {
        flatMenuItems.addAll([item, ...item.items]);
      } else {
        flatMenuItems.add(item);
      }
    }
    int indexOriginal = flatMenuItems
        .where((element) => element.key != null)
        .toList()
        .indexWhere((element) => element.key == currentMenuKey);

    if (indexOriginal == -1) {
      int indexFooter = footerItems
          .where((element) => element.key != null)
          .toList()
          .indexWhere((element) => element.key == currentMenuKey);
      if (indexFooter == -1) {
        return 0;
      }
      return flatMenuItems
              .where((element) => element.key != null)
              .toList()
              .length +
          indexFooter;
    } else {
      return indexOriginal;
    }
  }

  _initData() {
    update(["home"]);
  }

  void onTap() {}

  @override
  void onInit() {
    super.onInit();
    currentTabIndex.listen((value) {
      pageController.animateToPage(
        value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initMenu();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

// 一级菜单
class PrimaryMenu {
  final String id;
  final String title;
  IconData? iconData;
  final List<SecondaryMenu> children;
  PrimaryMenu(
      {required this.id,
      required this.title,
      this.iconData,
      required this.children});
}

// 二级菜单
class SecondaryMenu {
  final String id;
  final String title;
  IconData? iconData;
  final List<TertiaryMenu> children;
  SecondaryMenu(
      {required this.id,
      required this.title,
      this.iconData,
      required this.children});
}

// 三级菜单
class TertiaryMenu {
  final String id;
  final String title;
  IconData? iconData;
  final Widget bodyPage;
  TertiaryMenu(
      {required this.id,
      required this.title,
      this.iconData,
      required this.bodyPage});
}
