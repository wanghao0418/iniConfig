/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-05 15:28:18
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-14 18:06:36
 * @FilePath: /iniConfig/lib/pages/setting/device_settings/shelf_management/shelf_info/widgets/select_shelf_component.dart
 * @Description: 选择现有货架组件
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:iniConfig/common/utils/trans_field.dart';

import '../../../../../../common/api/common.dart';
import '../../../../../../common/utils/http.dart';
import '../../../../../../common/utils/popup_message.dart';

class SelectShelfComponent extends StatefulWidget {
  const SelectShelfComponent(
      {Key? key, required this.shelfSectionList, required this.showValue})
      : super(key: key);
  final String showValue;
  final List<String> shelfSectionList;

  @override
  SelectShelfComponentState createState() => SelectShelfComponentState();
}

class SelectShelfComponentState extends State<SelectShelfComponent> {
  final List<ShelfSection> sectionList = [];
  final List<ShelfSection> selectedSections = [];

  init() async {
    var params = [];
    for (var i = 0; i < widget.shelfSectionList.length; i++) {
      sectionList.add(ShelfSection(
        queryKey: '${widget.shelfSectionList[i]}/ShelfNum',
        section: widget.shelfSectionList[i],
      ));
      params.add('${widget.shelfSectionList[i]}/ShelfNum');
    }

    ResponseApiBody res = await CommonApi.fieldQuery({
      "params": params,
    });
    if (res.success == true) {
      // 查询成功
      var result = res.data as Map<String, dynamic>;
      for (var element in result.entries) {
        var index = sectionList
            .indexWhere((element2) => element2.queryKey == element.key);
        sectionList[index].number = element.value;
      }
      // TODO: 处理已选项(因为可能多个机床机床号相同)
      var selectedList = widget.showValue.split('-');
      for (var i = 0; i < sectionList.length; i++) {
        var temp = sectionList[i];
        if (selectedList.contains(temp.number)) {
          selectedSections.add(temp);
        }
      }
      setState(() {});
    } else {
      // 保存失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SizedBox(
      child: ListView.builder(
          itemCount: widget.shelfSectionList.length,
          itemBuilder: (context, index) {
            final ShelfSection contact = sectionList[index];
            return ListTile.selectable(
              title: Text(TransUtils.getTransField(contact.section!, '货架')),
              subtitle: Text('货架号：${contact.number ?? ''}'),
              selected: selectedSections.contains(contact),
              selectionMode: ListTileSelectionMode.multiple,
              onSelectionChange: (selected) {
                if (selected) {
                  selectedSections.add(contact);
                } else {
                  var index = selectedSections.indexOf(contact);
                  selectedSections.removeAt(index);
                }
                setState(() {});
              },
            );
          }),
    ));
  }
}

class ShelfSection {
  String? queryKey;
  String? section;
  String? number;
  ShelfSection({this.queryKey, this.section, this.number});
}
