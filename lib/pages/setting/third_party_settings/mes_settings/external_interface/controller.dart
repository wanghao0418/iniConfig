import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/components/index.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';

class ExternalInterfaceController extends GetxController {
  ExternalInterfaceController();
  ExternalInterface externalInterface = ExternalInterface();
  List<RenderFieldInfo> menuList = [
    RenderFieldInfo(
      field: "StartServerMark",
      section: "LocalServerConfig",
      name: "开启服务标识，大于0，开启服务端，IP为软件所在电脑IP",
      renderType: RenderType.select,
      options: {"不启用": "0", "武汉工程": "1", "精英放电": "2", "一汽线体": "3"},
    ),
    RenderFieldInfo(
      field: "ServerPort",
      section: "LocalServerConfig",
      name: "AGV和半自动一键上传启动",
      renderType: RenderType.input,
    ),
  ];

  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = externalInterface.toJson();
    temp[field] = val;
    externalInterface = ExternalInterface.fromJson(temp);
  }

  String? getFieldValue(String field) {
    return externalInterface.toJson()[field];
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
      "params": externalInterface.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      externalInterface = ExternalInterface.fromJson(res.data);
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

  _initData() {
    update(["external_interface"]);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    query();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

class ExternalInterface {
  String? localServerConfigStartServerMark;
  String? localServerConfigServerPort;

  ExternalInterface(
      {this.localServerConfigStartServerMark,
      this.localServerConfigServerPort});

  ExternalInterface.fromJson(Map<String, dynamic> json) {
    localServerConfigStartServerMark =
        json['LocalServerConfig/StartServerMark'];
    localServerConfigServerPort = json['LocalServerConfig/ServerPort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LocalServerConfig/StartServerMark'] =
        this.localServerConfigStartServerMark;
    data['LocalServerConfig/ServerPort'] = this.localServerConfigServerPort;
    return data;
  }
}
