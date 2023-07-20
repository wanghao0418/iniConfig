/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-13 11:06:23
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-20 15:56:37
 * @FilePath: /iniConfig/lib/pages/setting/device_settings/shelf_management/shelf_info/widgets/craft_select_form.dart
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iniConfig/common/api/special.dart';
import 'package:iniConfig/common/utils/http.dart';

class CraftSelectForm extends StatefulWidget {
  const CraftSelectForm({Key? key, required this.showValue}) : super(key: key);
  final String showValue;
  @override
  CraftSelectFormState createState() => CraftSelectFormState();
}

class CraftSelectFormState extends State<CraftSelectForm> {
  List craftList = [];
  List selectedList = [];
  TextEditingController textController = TextEditingController();

  get currentValue => selectedList.join('&');

  add() {
    var text = textController.text;
    if (text.isNotEmpty && !craftList.contains(text)) {
      craftList.add(textController.text);
      setState(() {});
    }
  }

  delete() {
    if (selectedList.isNotEmpty) {
      craftList.removeWhere((element) => selectedList.contains(element));
      selectedList.clear();
      setState(() {});
    }
  }

  initValue() {
    if (widget.showValue.isNotEmpty) {
      selectedList = widget.showValue.split('&');
      for (var element in selectedList) {
        if (!craftList.contains(element)) {
          craftList.add(element);
        }
      }
      setState(() {});
    }
  }

  // 获取货架限制工艺
  getShelfCraft() async {
    ResponseApiBody result = await SpecialApi.getShelfLimitProcess();
    if (result.success == true) {
      var data = result.data as List;
      print(data);
      // 去掉括号及注释
      final regexp = RegExp(r'\((.*?)\)');

      if (data.isNotEmpty) {
        craftList = data.map((e) => e.replaceAll(regexp, '')).toList();
        setState(() {});
      }
    }
    initValue();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initValue();
    getShelfCraft();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: craftList.length,
                itemBuilder: (context, index) {
                  return ListTile.selectable(
                    title: Text(craftList[index]),
                    selected: selectedList.contains(craftList[index]),
                    selectionMode: ListTileSelectionMode.multiple,
                    onSelectionChange: (value) {
                      if (value) {
                        selectedList.add(craftList[index]);
                      } else {
                        selectedList.remove(craftList[index]);
                      }
                      setState(() {});
                    },
                  );
                })),
        Row(
          children: [
            Expanded(
                child: TextBox(
              controller: textController,
              placeholder: "请输入",
            )),
            10.horizontalSpaceRadius,
            FilledButton(
              onPressed: add,
              child: Wrap(
                spacing: 5,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(FluentIcons.add),
                  10.horizontalSpaceRadius,
                  Text("添加"),
                ],
              ),
            ),
            10.horizontalSpaceRadius,
            FilledButton(
              onPressed: delete,
              child: Wrap(
                spacing: 5,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(FluentIcons.delete),
                  10.horizontalSpaceRadius,
                  Text("删除"),
                ],
              ),
            )
          ],
        )
      ],
    ));
  }
}
