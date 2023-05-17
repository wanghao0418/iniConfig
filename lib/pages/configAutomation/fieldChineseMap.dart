/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-04-23 18:03:52
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-05-17 13:38:12
 * @FilePath: /mesui/lib/pages/configAutomation/fieldChineseMap.dart
 * @Description: 字段中文映射
 */
String getFieldChinese(String field,
    {bool isOption = false, String section = ''}) {
  if (isOption && section.isNotEmpty) {
    return fieldChineseMap['$section-$field'] ?? field;
  }
  return fieldChineseMap[field] ?? getChineseByReg(field);
}

// 根据正则匹配返回中文
String getChineseByReg(String field) {
  var reg = RegExp(r'^[a-zA-Z]+\d+$');
  if (reg.hasMatch(field)) {
    var reg2 = RegExp(r'[a-zA-Z]+');
    // 将首部英文提取出来
    var match = reg2.firstMatch(field);
    var key = match?.group(0);
    // 从可迭代字段集合中查询首部英文
    var value = scalableFieldMap[key];
    if (value != null) {
      // 替换首部英文
      return field.replaceAll(key!, value);
    } else {
      return field;
    }
  }
  return field;
}

// 可迭代字段集合
Map<String, String> scalableFieldMap = {
  'MachineInfo': '机床信息',
  'ScanDevice': '扫码设备',
  'TestCMMInfo': '线外机床',
  'Shelf': '货架',
};

Map<String, String> fieldChineseMap = {
  'Plc_M_Block': 'PLC的M区地址',
  'PlcDefinition': '货位灯颜色',
  'PlcDbBlock': '功能定义与其PLC的DB区地址的对应关系',
  'RobotTaskPosition': '功能定义与机器人R寄存器的对应关系',
  'JumpRobotTaskNode': '需要跳过的机器人任务',
  'PrgLocalInfo': '本地程序服务器',
  'PrgServerInfo': '程序服务器设置',
  'EACTClientTcpInfo': 'EACT合并程序TCP服务',
  'DataBaseInfo': '数据库',
  'SysInfo': '系统相关设置',
  'FixtureInfo': '托盘设置',
  'MachineScanTask': '机床卡盘扫描模式',
  'SensorInfo': 'PLC地址',
  'RobotInfo': '机器人',
  'plcAdressFileName': 'plc协议版本',
  'DataSourceType': '导入外部表设置',
  'DataBaseWorkReport': 'EACT报工设置',
  'WorkpriceInfo': '工件密度设置',
  'ScanDevice': '不同类型的扫描设备配置',
  'TcpScanDriverInfo': '扫描设备服务设置',
  'ScanDeviceInfo': '多扫描配置，海泰科项目旋转货架多个同类型的条码枪',
  'MacInfo': '自动化机床索引设置',
  'EmanWorkReport': 'Eman报工信息',
  'RomoteDataBaseInfo': '采集远程数据设置',
  'MacCollectionInfo': '采集机床索引设置',
  'WorkOrderInfo': '工单读取相关配置',
  'FixtureTypeInfo': '夹具类型信息设置',
  'ShelfInfo': '货架配置',
  'GlobelInfo': '全局信息设置',
  'RobotManualUI': '机器人UI设置',
  'HideProgressBar': '隐藏进度条',
  'HideQWidgetPage': '隐藏QWidgetPage',
};
