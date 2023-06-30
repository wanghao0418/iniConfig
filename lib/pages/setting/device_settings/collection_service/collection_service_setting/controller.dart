/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-26 20:09:04
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-30 11:20:55
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/collection_service/collection_service_setting/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/components/index.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class CollectionServiceSettingController extends GetxController {
  CollectionServiceSettingController();
  CollectionServiceSetting collectionServiceSetting =
      CollectionServiceSetting();
  List<RenderField> menuList = [
    RenderFieldInfo(
        field: "ToolLifeCollectMode",
        section: "CollectServer",
        name: "刀具寿命采集模式",
        renderType: RenderType.select,
        options: {
          "不采集": "0",
          "EAtm": "1",
          "EMdc": "2",
        }),
    RenderFieldInfo(
      field: "ToolLifeCollectTime",
      section: "CollectServer",
      name: "刀具寿命采集循环时间，单位：分钟",
      renderType: RenderType.numberInput,
    ),
  ];
  List sectionList = [];
  var currentSection = ''.obs;

  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = collectionServiceSetting.toJson();
    temp[field] = val;
    collectionServiceSetting = CollectionServiceSetting.fromJson(temp);
  }

  String? getFieldValue(String field) {
    return collectionServiceSetting.toJson()[field];
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
      "params": collectionServiceSetting.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      collectionServiceSetting = CollectionServiceSetting.fromJson(res.data);
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
    if (changedList.isEmpty) return;
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

  onSectionChange(String section) {
    currentSection.value = section;
    _initData();
  }

  void getSectionList() async {
    ResponseApiBody res = await CommonApi.getSectionList({
      "params": [
        {
          "list_node": "RomoteDataBaseInfo",
          "parent_node": "NULL",
        }
      ],
    });
    if (res.success == true) {
      // 查询成功
      var data = res.data;
      var result = (data as List).first as String;
      sectionList = result.isEmpty ? [] : result.split('-');
      currentSection.value = sectionList.isNotEmpty ? sectionList.first : "";
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
          "list_node": "RomoteDataBaseInfo",
          "parent_node": "NULL",
        }
      ],
    });
    if (res.success == true) {
      // 新增成功
      // getSectionList();
      sectionList.add((res.data as List).first as String);
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
          "list_node": 'RomoteDataBaseInfo',
          "parent_node": "NULL",
          "node_name": currentSection.value,
        }
      ],
    });
    if (res.success == true) {
      // 删除成功
      // getSectionList();
      sectionList.remove(currentSection.value);
      currentSection.value = sectionList.isNotEmpty ? sectionList.first : "";
      _initData();
    } else {
      // 删除失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  _initData() {
    update(["collection_service_setting"]);
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

class CollectionServiceSetting {
  String? collectServerToolLifeCollectMode;
  String? collectServerToolLifeCollectTime;

  CollectionServiceSetting(
      {this.collectServerToolLifeCollectMode,
      this.collectServerToolLifeCollectTime});

  CollectionServiceSetting.fromJson(Map<String, dynamic> json) {
    collectServerToolLifeCollectMode =
        json['CollectServer/ToolLifeCollectMode'];
    collectServerToolLifeCollectTime =
        json['CollectServer/ToolLifeCollectTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CollectServer/ToolLifeCollectMode'] =
        this.collectServerToolLifeCollectMode;
    data['CollectServer/ToolLifeCollectTime'] =
        this.collectServerToolLifeCollectTime;
    return data;
  }
}
