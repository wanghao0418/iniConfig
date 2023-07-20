/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-18 14:16:49
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 14:53:00
 * @FilePath: /iniConfig/lib/pages/setting/device_settings/shelf_management/shelf_info/widgets/button_lights_associate.dart
 * @Description: 接驳按钮灯关联
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iniConfig/common/api/common.dart';
import 'package:iniConfig/common/style/global_theme.dart';
import 'package:iniConfig/common/utils/popup_message.dart';
import 'package:iniConfig/pages/setting/device_settings/shelf_management/shelf_info/controller.dart';

import '../widgets/shelf_info_setting.dart';

class ButtonLightsAssociate extends StatefulWidget {
  const ButtonLightsAssociate({Key? key, required this.showValue})
      : super(key: key);

  final String showValue;
  @override
  ButtonLightsAssociateState createState() => ButtonLightsAssociateState();
}

class ButtonLightsAssociateState extends State<ButtonLightsAssociate> {
  List optionsList = [];
  List<String> selectedList = [];
  List<List> associateGroupList = [];

  get currentValue => associateGroupList.map((e) => e.join('&')).join('-');

  // 关联
  associate() {
    if (selectedList.length > 1) {
      associateGroupList.add(selectedList);
      optionsList.removeWhere((element) => selectedList.contains(element));
      selectedList = [];
      setState(() {});
    }
  }

  // 取消关联
  cancelAssociate(String value) {
    var group =
        associateGroupList.firstWhere((element) => element.contains(value));
    if (group.length == 2) {
      associateGroupList.remove(group);
      optionsList.addAll(group);
      setState(() {});
    } else {
      group.remove(value);
      optionsList.add(value);
      setState(() {});
    }
  }

  // 获取所有可选项
  initOptions() async {
    var shelfInfoController = Get.find<ShelfInfoController>();
    var shelfSectionList = shelfInfoController.shelfList;
    // var queryList = shelfSectionList.map((e) => '$e/ShelfFuncType').toList();
    var res = await CommonApi.getSectionDetail({
      "params": shelfSectionList,
    });
    if (res.success == true) {
      List shelfDetailList = res.data.map((e) {
        var index = res.data.indexOf(e);
        return Shelf.fromSectionJson(e, shelfSectionList[index]);
      }).toList();
      // 去除已关联的选项 去除不是接驳类型的货架
      optionsList = shelfDetailList
          .where((element) => element.shelfFuncType == 'connection')
          .map((e) => e.shelfNum)
          .toList()
          .where((element) {
        for (var group in associateGroupList) {
          if (group.contains(element)) {
            return false;
          }
        }
        return true;
      }).toList();
      // optionsList = res.data.values.toList();
      setState(() {});
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  initValue() {
    if (widget.showValue.isNotEmpty) {
      associateGroupList =
          widget.showValue.split('-').map((e) => e.split('&')).toList();
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValue();
    initOptions();
  }

  Widget _buildGroupList() {
    return Card(
      backgroundColor: FluentTheme.of(context).cardColor,
      child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                size: 2,
              ),
          itemBuilder: (context, index) {
            var group = associateGroupList[index];
            return Container(
              // color: Colors.green.lightest,
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: Wrap(
                  spacing: 5.0,
                  runSpacing: 5.0,
                  children: group
                      .map((e) => Container(
                          decoration: BoxDecoration(
                              color: FluentTheme.of(context).accentColor,
                              border: Border.all(
                                  color: GlobalTheme.instance.accentColor),
                              borderRadius: BorderRadius.circular(5.0)),
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(e),
                              5.horizontalSpaceRadius,
                              IconButton(
                                  icon: Icon(
                                    FluentIcons.delete,
                                    color: GlobalTheme.instance.buttonIconColor,
                                  ),
                                  onPressed: () => cancelAssociate(e))
                            ],
                          )))
                      .toList()),
            );
          },
          itemCount: associateGroupList.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        Column(
          children: [
            Expanded(
                child: Card(
                    padding: EdgeInsets.all(5.0),
                    backgroundColor: FluentTheme.of(context).cardColor,
                    child: SizedBox(
                      width: 200.0,
                      child: ListView.builder(
                          itemCount: optionsList.length,
                          itemBuilder: (context, index) {
                            return ListTile.selectable(
                              title: Text(optionsList[index]),
                              selected:
                                  selectedList.contains(optionsList[index]),
                              selectionMode: ListTileSelectionMode.multiple,
                              onSelectionChange: (value) {
                                if (value) {
                                  selectedList.add(optionsList[index]);
                                  // currentValue = optionsList[index];
                                } else {
                                  selectedList.remove(optionsList[index]);
                                }
                                setState(() {});
                              },
                            );
                          }),
                    ))),
            10.verticalSpacingRadius,
            SizedBox(
              width: 120.0,
              child: FilledButton(child: Text('关联'), onPressed: associate),
            )
          ],
        ),
        10.horizontalSpaceRadius,
        Icon(
          FluentIcons.insert_columns_right,
          size: 30,
          color: Colors.blue,
        ),
        10.horizontalSpaceRadius,
        Expanded(child: _buildGroupList())
      ]),
    );
  }
}
