/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-03 10:10:45
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-03 10:39:42
 * @FilePath: /eatm_ini_config/lib/common/components/mac_associate.dart
 * @Description: 机床关联组件
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../api/common.dart';
import '../utils/http.dart';
import '../utils/popup_message.dart';

class MacAssociate extends StatefulWidget {
  const MacAssociate({Key? key, required this.showValue}) : super(key: key);
  final String showValue;
  @override
  _MacAssociateState createState() => _MacAssociateState();
}

class _MacAssociateState extends State<MacAssociate> {
  List<String> _subValueList = [];
  String get currentValue => _subValueList.join('#');
  List macNameList = [];

  // 解析value
  void _initParseValue(String value) {
    _subValueList = value.split('#');
  }

  // 获取线内机床列表
  void getSectionList() async {
    ResponseApiBody res = await CommonApi.getSectionList({
      "params": [
        {
          "list_node": "MachineInfo",
          "parent_node": "NULL",
        }
      ],
    });
    if (res.success == true) {
      // 查询成功
      var data = res.data;
      var result = (data as List).first as String;
      macNameList = result.isEmpty ? [] : result.split('-');
    } else {
      // 查询失败
      PopupMessage.showFailInfoBar(res.message as String);
    }

    _initParseValue(widget.showValue);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSectionList();
  }

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
        Expanded(
            child: ListView.separated(
          itemCount: macNameList.length,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (context, index) {
            return Container(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: TextBox(
                      controller:
                          TextEditingController(text: macNameList[index]),
                      readOnly: true,
                    ),
                  ),
                  5.horizontalSpaceRadius,
                  Text('&'),
                  5.horizontalSpaceRadius,
                  Expanded(
                      child: TextBox(
                    controller: TextEditingController(),
                    onChanged: (value) {
                      _subValueList[index] =
                          value == '' ? '' : '${macNameList[index]}&$value';
                      setState(() {});
                    },
                  )),
                ],
              ),
            );
          },
        ))
      ]),
    );
  }
}

class MacAssociateInfo {
  String? macName;
  String? macId;
  MacAssociateInfo({this.macName, this.macId});

  get isNotEmpty => macName!.isNotEmpty && macId!.isNotEmpty;

  get associateValue => macName! + '&' + macId!;
}
