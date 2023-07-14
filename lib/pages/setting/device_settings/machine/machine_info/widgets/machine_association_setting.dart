/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-14 14:03:38
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-14 15:30:26
 * @FilePath: /iniConfig/lib/pages/setting/device_settings/machine/machine_info/widgets/machine_association_setting.dart
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/utils/popup_message.dart';

import '../../../../../../common/api/common.dart';

class MachineAssociationSetting extends StatefulWidget {
  const MachineAssociationSetting(
      {Key? key, required this.showValue, required this.macSectionList})
      : super(key: key);
  final String showValue;
  final List macSectionList;

  @override
  MachineAssociationSettingState createState() =>
      MachineAssociationSettingState();
}

class MachineAssociationSettingState extends State<MachineAssociationSetting> {
  List optionsList = [];
  List<String> selectedList = [];
  List<List> associateGroupList = [];

  get currentValue => associateGroupList.map((e) => e.join('-')).join('&');

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
    var queryList = widget.macSectionList.map((e) => '$e/MachineName').toList();
    var res = await CommonApi.fieldQuery({
      "params": queryList,
    });
    if (res.success == true) {
      // 去除已关联的选项
      optionsList = res.data.values
          .toList()
          .map((e) => e.toString())
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
          widget.showValue.split('&').map((e) => e.split('-')).toList();
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
      backgroundColor: Colors.grey[30],
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
                              color: Colors.errorSecondaryColor,
                              border: Border.all(color: Colors.blue.lightest),
                              borderRadius: BorderRadius.circular(5.0)),
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(e),
                              5.horizontalSpaceRadius,
                              IconButton(
                                  icon: Icon(FluentIcons.delete),
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
                    backgroundColor: Colors.grey[30],
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
