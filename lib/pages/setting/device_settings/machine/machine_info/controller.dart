/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-20 13:38:43
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-30 10:42:44
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/machine/machine_info/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/components/index.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';
import 'widgets/add_mac_form.dart';

class MachineInfoController extends GetxController {
  MachineInfoController();
  MachineGlobelConfig machineGlobelConfig = MachineGlobelConfig();
  List sectionList = [];
  var currentSection = ''.obs;
  GlobalKey addFormKey = GlobalKey();
  List<RenderField> menuList = [
    RenderFieldGroup(groupName: "全局配置", children: [
      RenderFieldInfo(
          field: 'AbnormalairIsOffLineMac',
          section: 'MachineGlobelConfig',
          name: "机床气密性异常是否下线",
          renderType: RenderType.radio,
          options: {"默认下线": "0", "只提示不下线": "1"}),
      RenderFieldInfo(
        field: 'MacToolManage',
        section: 'MachineGlobelConfig',
        name: "标记机床是否有刀具管理",
        renderType: RenderType.input,
      ),
    ])
  ];

  List<String> changedList = [];

  bool isChanged(String field) {
    return changedList.contains(field);
  }

  void setFieldValue(String field, String val) {
    var temp = machineGlobelConfig.toJson();
    temp[field] = val;
    machineGlobelConfig = MachineGlobelConfig.fromJson(temp);
  }

  String? getFieldValue(String field) {
    return machineGlobelConfig.toJson()[field];
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
      "params": machineGlobelConfig.toJson().keys.toList(),
    });
    if (res.success == true) {
      // 查询成功
      machineGlobelConfig = MachineGlobelConfig.fromJson(res.data);
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

  onSectionChange(String section) {
    currentSection.value = section;
    _initData();
  }

  _initData() {
    update(["machine_info"]);
  }

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
      sectionList = result.isEmpty ? [] : result.split('-');
      currentSection.value = sectionList.isNotEmpty ? sectionList.first : "";
      _initData();
    } else {
      // 查询失败
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  void add(context) {
    showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: Text('新增机床'),
            content: AddMacForm(
              key: addFormKey,
            ),
            actions: [
              Button(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FilledButton(
                child: Text('确定'),
                onPressed: () async {
                  var addForm = (addFormKey.currentState! as AddMacFormState);
                  if (!(addForm.formKey.currentState as FormState).validate()) {
                    return;
                  }
                  print(addForm.addMacForm.toJson());
                  var res = await CommonApi.addSection({
                    "params": [
                      {
                        "list_node": addForm.addMacForm.system,
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
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  // 删除
  void delete() async {
    var res = await CommonApi.deleteSection({
      "params": [
        {
          "list_node": 'MachineInfo',
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

class MachineGlobelConfig {
  String? machineGlobelConfigAbnormalairIsOffLineMac;
  String? machineGlobelConfigMacToolManage;

  MachineGlobelConfig(
      {this.machineGlobelConfigAbnormalairIsOffLineMac,
      this.machineGlobelConfigMacToolManage});

  MachineGlobelConfig.fromJson(Map<String, dynamic> json) {
    machineGlobelConfigAbnormalairIsOffLineMac =
        json['MachineGlobelConfig/AbnormalairIsOffLineMac'];
    machineGlobelConfigMacToolManage =
        json['MachineGlobelConfig/MacToolManage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MachineGlobelConfig/AbnormalairIsOffLineMac'] =
        this.machineGlobelConfigAbnormalairIsOffLineMac;
    data['MachineGlobelConfig/MacToolManage'] =
        this.machineGlobelConfigMacToolManage;
    return data;
  }
}
