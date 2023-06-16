import 'package:flutter/material.dart';
import '../../common/widgets/customCard.dart';

class SplitJointContainer extends StatefulWidget {
  SplitJointContainer(
      {Key? key,
      required this.field,
      required this.value,
      required this.onValueChange})
      : super(key: key);

  String field = '';
  String value = '';
  Function onValueChange = () {};

  @override
  _SplitJointContainerState createState() => _SplitJointContainerState();
}

class _SplitJointContainerState extends State<SplitJointContainer> {
  List<String> _subValueList = [];
  String _inputValue = '';
  String _selectValue = '';
  String _checkboxValue = 'input';

  // 解析value
  _initSubValueList() {
    var splitList = widget.value.split('/');
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
  _buildSubValueList() {
    return _subValueList
        .map((e) => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: e == '/' ? Color(0xffEE606B) : Colors.blue),
              padding: EdgeInsets.all(10),
              child: Text(e),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomCard(
          padding: EdgeInsets.all(10),
          title: '设置${widget.field}',
          containChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                    child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: _buildSubValueList(),
                )),
              )),
              Row(
                children: [
                  Checkbox(
                      value: _checkboxValue == 'input',
                      onChanged: (v) {
                        setState(() {
                          _checkboxValue = v! ? 'input' : '';
                        });
                      }),
                  Container(
                    width: 200,
                    child: TextField(
                      // controller: TextEditingController(text: value),
                      decoration: InputDecoration(
                        labelText: '自定义输入',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _inputValue = value;
                      },
                    ),
                  ),
                  Checkbox(
                      value: _checkboxValue == 'select',
                      onChanged: (v) {
                        setState(() {
                          _checkboxValue = v! ? 'select' : '';
                        });
                      }),
                  Container(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: '选择转义',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectValue.isNotEmpty ? _selectValue : null,
                      items: escapeList
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (v) {
                        _selectValue = v!;
                      },
                    ),
                  ),
                  Spacer(),
                  ElevatedButton.icon(
                      label: Text('添加'),
                      onPressed: () {
                        if (_checkboxValue == 'input' &&
                            _inputValue.isNotEmpty) {
                          _subValueList.add(_inputValue);
                        } else if (_checkboxValue == 'select' &&
                            _selectValue.isNotEmpty) {
                          _subValueList.add(_selectValue);
                        }
                        setState(() {});
                      },
                      icon: Icon(Icons.add)),
                  SizedBox(
                    width: 10.0,
                  ),
                  ElevatedButton.icon(
                      label: Text('删除'),
                      onPressed: () {
                        setState(() {
                          _subValueList.removeLast();
                        });
                      },
                      icon: Icon(Icons.delete)),
                  SizedBox(
                    width: 10.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _subValueList.add('/');
                        });
                      },
                      child: Text('/'))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff6ED760))),
                      onPressed: () {
                        var value = _subValueList.join('');
                        widget.onValueChange(value);
                        Navigator.pop(context);
                      },
                      child: Text('保存')),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('取消')),
                ],
              )
            ],
          )),
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
