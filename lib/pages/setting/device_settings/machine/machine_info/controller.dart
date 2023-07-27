/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-20 13:38:43
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-21 14:16:29
 * @FilePath: /eatm_ini_config/lib/pages/setting/device_settings/machine/machine_info/controller.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iniConfig/common/api/machine.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../../common/api/common.dart';
import '../../../../../common/components/index.dart';
import '../../../../../common/utils/http.dart';
import '../../../../../common/utils/popup_message.dart';
import 'widgets/add_mac_form.dart';
import 'subComponents/machine_association_setting.dart';

class MachineInfoController extends GetxController {
  MachineInfoController();
  MachineGlobelConfig machineGlobelConfig = MachineGlobelConfig();
  List sectionList = [];
  var currentSection = ''.obs;
  GlobalKey addFormKey = GlobalKey();
  List<RenderField> menuList = [
    // RenderFieldGroup(groupName: "全局配置", children: [
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
        renderType: RenderType.customMultipleChoice,
        splitKey: '-'),
    RenderFieldInfo(
        field: "MachineOnlineSync",
        section: "SysInfo",
        name: "机床关联设置",
        renderType: RenderType.custom,
        documentationList: [
          DocumentationData(
              type: DocumentationType.text,
              value: '1和2关联， 3和4号机床关联，效果是上下线默认是同步的，操作一台，另一台也等同操作了。')
        ]),
    // ])
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
            title: Text('新增机床').fontSize(20.sp),
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
                  var res = await MachineApi.addMachine({
                    "params": [
                      {
                        "list_node": addForm.addMacForm.system,
                        "parent_node": "NULL",
                        // "bind_field": "MachineName"
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
    var lastSection = sectionList.last;
    print(lastSection);
    var res = await CommonApi.deleteLastSection({
      "params": [
        {
          "list_node": 'MachineInfo',
          "parent_node": "NULL",
          "node_name": lastSection,
        }
      ],
    });
    if (res.success == true) {
      // 删除成功
      // getSectionList();
      sectionList.remove(lastSection);
      if (currentSection.value == lastSection) {
        currentSection.value = sectionList.isNotEmpty ? sectionList.first : "";
      }
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

  initMenu() {
    for (var element in menuList) {
      if (element is RenderFieldGroup) {
        for (var item in element.children) {
          if (item is RenderFieldInfo) {
            if (item.fieldKey == 'SysInfo/MachineOnlineSync') {
              item.builder = (BuildContext context) {
                return FilledButton(
                    child: const Text('编辑'),
                    onPressed: () {
                      var _key = GlobalKey();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ContentDialog(
                              constraints: const BoxConstraints(maxWidth: 1000),
                              title: Text('${item.name}').fontSize(20.sp),
                              content: SizedBox(
                                height: 300,
                                child: MachineAssociationSetting(
                                  key: _key,
                                  showValue: getFieldValue(item.fieldKey) ?? '',
                                  macSectionList: sectionList,
                                ),
                              ),
                              actions: [
                                Button(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('取消')),
                                FilledButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      var state = _key.currentState!
                                          as MachineAssociationSettingState;
                                      var value = state.currentValue;
                                      onFieldChange(item.fieldKey, value);
                                    },
                                    child: const Text('确定'))
                              ],
                            );
                          });
                    });
              };
            }
          }
        }
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    initMenu();
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
  String? sysInfoMachineOnlineSync;

  MachineGlobelConfig(
      {this.machineGlobelConfigAbnormalairIsOffLineMac,
      this.machineGlobelConfigMacToolManage,
      this.sysInfoMachineOnlineSync});

  MachineGlobelConfig.fromJson(Map<String, dynamic> json) {
    machineGlobelConfigAbnormalairIsOffLineMac =
        json['MachineGlobelConfig/AbnormalairIsOffLineMac'];
    machineGlobelConfigMacToolManage =
        json['MachineGlobelConfig/MacToolManage'];
    sysInfoMachineOnlineSync = json['SysInfo/MachineOnlineSync'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MachineGlobelConfig/AbnormalairIsOffLineMac'] =
        this.machineGlobelConfigAbnormalairIsOffLineMac;
    data['MachineGlobelConfig/MacToolManage'] =
        this.machineGlobelConfigMacToolManage;
    data['SysInfo/MachineOnlineSync'] = this.sysInfoMachineOnlineSync;
    return data;
  }
}
