/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-12 13:34:49
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 13:19:18
 * @FilePath: /eatm_ini_config/lib/pages/system/home/view.dart
 * @Description:  主页
 */
import 'package:fluent_ui/fluent_ui.dart' hide Tab;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iniConfig/common/style/global_theme.dart';
import 'package:iniConfig/pages/system/home/widgets/setting_view.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';
import 'widgets/cached_page_view.dart';
import 'widgets/fluent_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _HomeViewGetX();
  }
}

class _HomeViewGetX extends GetView<HomeController> {
  const _HomeViewGetX({Key? key}) : super(key: key);

  // tabContent
  Widget _buildTabContent() {
    return CachedPageView(
      key: ValueKey(controller.currentMenuKey),
      initialPageIndex: controller.currentTabIndex.value,
      children: controller.currentTabs.isNotEmpty
          ? controller.currentTabs.map((Tab tab) {
              return KeyedSubtree(
                key: tab.key,
                child: tab.body ?? Container(),
              );
            }).toList()
          : [Container()],
      onPageChanged: (value) {},
      onPageControllerCreated: (pcontroller) {
        controller.pageController = pcontroller;
      },
    );
  }

  // tabView
  Widget _buildTabView(context) {
    return Container(
      child: Column(children: [
        // _buildCustomTab(context),
        controller.currentTabs.isNotEmpty
            ? FluentTab(
                key: controller.tabViewKey,
                currentIndex: controller.currentTabIndex.value,
                tabs: List<Tab>.from(controller.currentTabs),
                onChanged: (value) {
                  if (value == controller.currentTabIndex) return;
                  controller.currentTabIndex.value = value;
                  controller.update(['home']);
                },
                closeButtonVisibility: CloseButtonVisibilityMode.never,
              )
            : Container(),
        Expanded(child: _buildTabContent()),
      ]),
    );
  }

  // // tabView
  // Widget _buildTabView(context) {
  //   return TabView(
  //     key: controller.tabViewKey,
  //     currentIndex: controller.currentTabIndex.value,
  //     tabs: List<Tab>.from(controller.currentTabs),
  //     closeButtonVisibility: CloseButtonVisibilityMode.never,
  //     onChanged: (value) {
  //       if (value == controller.currentTabIndex.value) return;
  //       controller.currentTabIndex.value = value;
  //       // controller.currentTabKey = controller.tabs[value].key;
  //       controller.update(['main']);
  //     },
  //     // footer: kIsWeb ? null : WindowButtons(),
  //   );
  // }

  // 打开设置弹窗
  void _openSettings(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: const Text('设置').fontSize(24.sp),
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            content: Container(
              height: 500,
              child: SettingView(),
            ),
            actions: [
              Button(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('确定'),
              ),
            ],
          );
        });
  }

  // 主视图
  Widget _buildView(context) {
    return NavigationView(
      key: controller.viewKey,
      // appBar:
      //     GlobalTheme.instance.navigationIndicator != PaneDisplayMode.minimal
      //         ? null
      //         : NavigationAppBar(
      //             height: 40,
      //             automaticallyImplyLeading: false,
      //           ),
      paneBodyBuilder: (item, child) {
        return _buildTabView(context);
      },
      pane: NavigationPane(
        key: controller.navigationPaneKey,
        size: const NavigationPaneSize(
          openWidth: 200,
        ),
        selected: controller.calculateSelectedIndex(),
        header: SizedBox(
          height: kOneLineTileHeight,
          child: ShaderMask(
            shaderCallback: (rect) {
              // final color = AppTheme.systemAccentColor.defaultBrushFor(
              //   Get.theme.brightness,
              // );
              final color = GlobalTheme.instance.accentColor;
              return LinearGradient(
                colors: [
                  color,
                  color.withOpacity(0.5),
                ],
              ).createShader(rect);
            },
            child: Image.asset(
              'assets/images/home/eman.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        displayMode: GlobalTheme.instance.navigationIndicator,
        items: controller.menuItems,
        autoSuggestBox: AutoSuggestBox(
          key: controller.searchKey,
          focusNode: controller.searchFocusNode,
          controller: controller.searchController,
          unfocusedColor: Colors.transparent,
          items:
              controller.canSelectMenuItems.whereType<PaneItem>().map((item) {
            assert(item.title is Text);
            final text = (item.title as Text).data!;
            return AutoSuggestBoxItem(
              label: text,
              value: text,
              onSelected: () {
                item.onTap?.call();
                controller.searchController.clear();
              },
            );
          }).toList(),
          trailingIcon: IgnorePointer(
            child: IconButton(
              onPressed: () {
                controller.searchFocusNode.requestFocus();
              },
              icon: const Icon(FluentIcons.search),
            ),
          ),
          placeholder: 'Search',
        ),
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        footerItems: [
          PaneItemSeparator(),
          PaneItem(
            key: const Key('/settings'),
            icon: const Icon(FluentIcons.settings),
            title: const Text('设置'),
            body: const SizedBox.shrink(),
            onTap: () => _openSettings(context),
          )
        ],
      ),
      // onOpenSearch: () {
      //   searchFocusNode.requestFocus();
      // },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      id: "home",
      builder: (_) {
        return material.Scaffold(
          body: _buildView(context),
        );
      },
    );
  }
}
