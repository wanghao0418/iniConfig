/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-27 09:07:37
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-30 10:49:52
 * @FilePath: /eatm_ini_config/lib/common/components/choose_list.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';

import '../api/common.dart';
import '../utils/http.dart';
import '../utils/popup_message.dart';

class ChooseList extends StatefulWidget {
  const ChooseList(
      {Key? key, required this.showValue, required this.chooseType})
      : super(key: key);
  final String showValue;
  final ChooseType chooseType;

  @override
  ChooseListState createState() => ChooseListState();
}

class ChooseListState extends State<ChooseList> {
  List<String> _optionList = [];
  String currentValue = '';

  _initOptionList() async {
    var params = {};
    if (widget.chooseType == ChooseType.macProgramSource) {
      params = {
        "list_node": "PrgServerInfo",
        "parent_node": "NULL",
      };
    } else if (widget.chooseType == ChooseType.localStorePath) {
      params = {
        "list_node": "PrgLocalInfo",
        "parent_node": "NULL",
      };
    }

    ResponseApiBody res = await CommonApi.getSectionList({
      "params": [params],
    });
    if (res.success == true) {
      // 查询成功
      var data = res.data;
      var result = (data as List).first as String;
      _optionList = result.isEmpty ? [] : result.split('-');
      setState(() {});
    } else {
      // 查询失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentValue = widget.showValue;
    _initOptionList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ComboBox<String>(
        isExpanded: true,
        value: currentValue,
        items: _optionList.map((e) {
          return ComboBoxItem(
            value: e,
            child: Text(e),
          );
        }).toList(),
        onChanged: (val) {
          setState(() {
            currentValue = val!;
          });
        },
      ),
    );
  }
}

enum ChooseType {
  macProgramSource(chooseType: "MacProgramSource"),
  localStorePath(chooseType: "LocalStorePath");

  const ChooseType({required this.chooseType});
  final String chooseType;
}
