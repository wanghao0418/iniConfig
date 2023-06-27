/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-25 10:51:47
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-26 09:10:28
 * @FilePath: /eatm_ini_config/lib/common/components/path_edit.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PathEdit extends StatefulWidget {
  const PathEdit({Key? key, required this.showValue}) : super(key: key);
  final String showValue;

  @override
  PathEditState createState() => PathEditState();
}

class PathEditState extends State<PathEdit> {
  List<String> _subValueList = [];
  String _inputValue = '';
  String _selectValue = '';
  // String _checkboxValue = 'input';

  String get currentValue => _subValueList.join('');

  // 解析value
  _initSubValueList() {
    var splitList = widget.showValue.split('/');
    List<String> list = [];
    for (var i = 0; i < splitList.length; i++) {
      var val = splitList[i];
      list.add(val);
      if (i != splitList.length - 1) {
        list.add('/');
      }
    }
    setState(() {
      _subValueList = list.where((element) => element.isNotEmpty).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _initSubValueList();
    super.initState();
  }

  // 根据数组画视图
  // _buildSubValueList() {
  //   return _subValueList
  //       .map((e) => Container(
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(5),
  //                 color: e == '/' ? Color(0xffEE606B) : Colors.blue),
  //             padding: EdgeInsets.all(10),
  //             child: Text(e),
  //           ))
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('预览:'),
        SizedBox(
          height: 60,
          child: TextBox(
            maxLines: null,
            controller: TextEditingController(text: currentValue),
            readOnly: true,
          ),
        ),
        10.verticalSpacingRadius,
        Text('自定义输入:'),
        Row(
          children: [
            Expanded(
              child: TextBox(
                controller: TextEditingController(text: _inputValue),
                onChanged: (value) {
                  setState(() {
                    _inputValue = value.trim();
                  });
                },
              ),
            ),
            10.horizontalSpaceRadius,
            Button(
              child: const Text('添加'),
              onPressed: () {
                setState(() {
                  if (_inputValue.isNotEmpty) _subValueList.add(_inputValue);
                  _inputValue = '';
                });
              },
            )
          ],
        ),
        10.verticalSpacingRadius,
        Text('转义字符:'),
        Row(
          children: [
            Expanded(
              child: ComboBox(
                value: _selectValue,
                items: escapeList
                    .map((e) => ComboBoxItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectValue = value.toString();
                  });
                },
              ),
            ),
            10.horizontalSpaceRadius,
            Button(
              child: Text('添加'),
              onPressed: () {
                setState(() {
                  if (_selectValue.isNotEmpty) _subValueList.add(_selectValue);
                });
              },
            )
          ],
        ),
        10.verticalSpacingRadius,
        Row(
          children: [
            Button(
                child: Text('/'),
                onPressed: () {
                  setState(() {
                    _subValueList.add('/');
                  });
                }),
            10.horizontalSpaceRadius,
            Button(
              child: Text('删除'),
              onPressed: () {
                setState(() {
                  _subValueList.removeLast();
                });
              },
            ),
          ],
        )
      ]),
    );
  }
}

// 转义字符列表
const List<String> escapeList = [
  '\$\$MachineType\$',
  '\$\$MachineName\$',
  '\$\$PARTFILENAME&',
  '\$\$MOULDSN&',
  '\$\$PARTSN&',
  '\$\$RMF&',
  '\$\$SN&',
  '\$\$CLAMP&'
];
