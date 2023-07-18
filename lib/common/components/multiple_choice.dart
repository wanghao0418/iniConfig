/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-14 11:35:55
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-17 18:00:47
 * @FilePath: /iniConfig/lib/common/components/multiple_choice.dart
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultipleChoice extends StatefulWidget {
  const MultipleChoice(
      {Key? key, required this.showValue, required this.splitKey})
      : super(key: key);
  final String showValue;
  final String splitKey;

  @override
  MultipleChoiceState createState() => MultipleChoiceState();
}

class MultipleChoiceState extends State<MultipleChoice> {
  List craftList = [];
  List selectedList = [];
  TextEditingController textController = TextEditingController();

  get currentValue => selectedList.join(widget.splitKey);

  add() {
    var text = textController.text;
    if (text.isNotEmpty && !craftList.contains(text)) {
      craftList.add(textController.text);
      selectedList.add(textController.text);
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
      selectedList = widget.showValue.split(widget.splitKey);
      for (var element in selectedList) {
        if (!craftList.contains(element)) {
          craftList.add(element);
        }
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValue();
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
