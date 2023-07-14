/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-12 13:34:49
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-05 18:35:03
 * @FilePath: /eatm_ini_config/lib/pages/system/home/view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart' hide Tab;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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

  // 主视图
  Widget _buildView(context) {
    return NavigationView(
      key: controller.viewKey,
      // appBar: kIsWeb
      //     ? null
      //     : NavigationAppBar(
      //         height: 40,
      //         automaticallyImplyLeading: false,
      //         actions: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      //           if (!kIsWeb) const WindowButtons(),
      //         ]),
      //       ),
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
              final color = Colors.blue;
              return LinearGradient(
                colors: [
                  color,
                  color,
                ],
              ).createShader(rect);
            },
            child: Image.asset(
              'assets/images/home/eman.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        displayMode: PaneDisplayMode.open,
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
        footerItems: controller.footerItems,
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
