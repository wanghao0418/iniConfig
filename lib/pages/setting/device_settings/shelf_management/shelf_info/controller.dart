import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/components/field_change.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class ShelfInfoController extends GetxController {
  ShelfInfoController();
  List shelfList = [];
  var currentShelf = "".obs;
  GlobalKey shelfInfoSettingKey = GlobalKey();
  ShelfInfo shelfInfo = ShelfInfo();
  List<RenderFieldInfo> menuList = [
    RenderFieldInfo(
        section: "ShelfInfo",
        field: "rightBtnPutShelf",
        name: "右键下料指定的货架号",
        renderType: RenderType.numberInput),
  ];
  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = shelfInfo.toJson();
    temp[field] = val;
    shelfInfo = ShelfInfo.fromJson(temp);
  }

  String? getFieldValue(String field) {
    return shelfInfo.toJson()[field];
  }

  void onFieldChange(String field, String value) {
    if (value == getFieldValue(field)) {
      return;
    }
    if (!changedList.contains(field)) {
      changedList.add(field);
    }
    setFieldValue(field, value);
    _initData();
  }

  query() async {
    ResponseApiBody res = await CommonApi.fieldQuery({
      "params": shelfInfo.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      shelfInfo = ShelfInfo.fromJson(res.data);
      _initData();
    } else {
      // 保存失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  _makeParams() {
    List<Map<String, dynamic>> params = [];
    for (var element in changedList) {
      params.add({"key": element, "value": getFieldValue(element)});
    }
    return params;
  }

  // 保存
  save() async {
    // 组装传参
    List<Map<String, dynamic>> params = _makeParams();
    print(params);
    ResponseApiBody res = await CommonApi.fieldUpdate({"params": params});
    if (res.success == true) {
      // 保存成功
      changedList.clear();
      PopupMessage.showSuccessInfoBar('保存成功');
      _initData();
    } else {
      // 保存失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  _initData() {
    update(["shelf_info"]);
  }

  onShelfChange(String shelf) {
    currentShelf.value = shelf;
    _initData();
  }

  void getSectionList() async {
    ResponseApiBody res = await CommonApi.getSectionList({
      "params": ['Shelf'],
    });
    if (res.success == true) {
      // 查询成功
      var data = res.data;
      shelfList = ((data as List).first as String).split('-');
      currentShelf.value = shelfList.isNotEmpty ? shelfList.first : "";
      _initData();
    } else {
      // 查询失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 新增
  void add() async {
    var res = await CommonApi.addSection({
      "params": [
        {
          "list_node": "Shelf",
          "parent_node": null,
        }
      ],
    });
    if (res.success == true) {
      // 新增成功
      // getSectionList();
      shelfList.add((res.data as List).first as String);
      _initData();
    } else {
      // 新增失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 删除
  void delete() async {
    var res = await CommonApi.deleteSection({
      "params": [
        {
          "list_node": currentShelf.value,
          "parent_node": null,
        }
      ],
    });
    if (res.success == true) {
      // 删除成功
      // getSectionList();
      shelfList.remove(currentShelf.value);
      currentShelf.value = shelfList.isNotEmpty ? shelfList.first : "";
      _initData();
    } else {
      // 删除失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    query();
    getSectionList();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

class ShelfInfo {
  String? shelfInfoRightBtnPutShelf;

  ShelfInfo({this.shelfInfoRightBtnPutShelf});

  ShelfInfo.fromJson(Map<String, dynamic> json) {
    shelfInfoRightBtnPutShelf = json['ShelfInfo/rightBtnPutShelf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShelfInfo/rightBtnPutShelf'] = this.shelfInfoRightBtnPutShelf;
    return data;
  }
}
