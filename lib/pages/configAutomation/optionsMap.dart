/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-04-25 11:21:53
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-05-17 14:40:28
 * @FilePath: /mesui/lib/pages/configAutomation/optionsMap.dart
 * @Description: 下拉选项映射
 */

import 'package:flutter/material.dart';

// 获取下拉选项
List<DropdownMenuItem<String>> getOptions(
    String field, String section, String configName) {
  return optionsMap['$configName-$section-$field'] ??
      getScalableOptions(field, section, configName);
}

List<DropdownMenuItem<String>> getScalableOptions(
    String field, String section, String configName) {
  var reg = RegExp(r'^[a-zA-Z]+\d+$');
  var normalSection;
  if (reg.hasMatch(section)) {
    var reg2 = RegExp(r'[a-zA-Z]+');
    // 将首部英文提取出来
    var match = reg2.firstMatch(section);
    normalSection = match?.group(0);
  } else {
    normalSection = section;
  }
  return optionsMap['$configName-$normalSection-$field'] ?? [];
}

const Map<String, List<DropdownMenuItem<String>>> optionsMap = {
  'plcAddress-PlcDefinition-OkLight': [
    DropdownMenuItem(
      child: Text('亮绿灯'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('亮红灯'),
      value: '2',
    ),
    DropdownMenuItem(
      child: Text('亮黄灯'),
      value: '3',
    ),
  ],
  'plcAddress-PlcDefinition-NgLight': [
    DropdownMenuItem(
      child: Text('亮绿灯'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('亮红灯'),
      value: '2',
    ),
    DropdownMenuItem(
      child: Text('亮黄灯'),
      value: '3',
    ),
  ],
  'plcAddress-PlcDefinition-WarnLight': [
    DropdownMenuItem(
      child: Text('亮绿灯'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('亮红灯'),
      value: '2',
    ),
    DropdownMenuItem(
      child: Text('亮黄灯'),
      value: '3',
    ),
  ],
  'userConfig-MachineInfo-MacDefaultConnect': [
    DropdownMenuItem(
      child: Text('无'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('自动触发上线'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('上线后校验钢件是否开料'),
      value: '2',
    ),
  ],
  'userConfig-MachineInfo-ExtServerConnectMak': [
    DropdownMenuItem(
      child: Text('不需要连接'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('需要连接'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-MachineType': [
    DropdownMenuItem(
      child: Text('CNC'),
      value: 'CNC',
    ),
    DropdownMenuItem(
      child: Text('CMM'),
      value: 'CMM',
    ),
    DropdownMenuItem(
      child: Text('EDM'),
      value: 'EDM',
    ),
    DropdownMenuItem(
      child: Text('CLEAN'),
      value: 'CLEAN',
    ),
    DropdownMenuItem(
      child: Text('DRY'),
      value: 'DRY',
    ),
  ],
  'userConfig-MachineInfo-MacSystemType': [
    DropdownMenuItem(
      child: Text('测试'),
      value: 'TEST',
    ),
    DropdownMenuItem(
      child: Text('发那科'),
      value: 'FANUC',
    ),
    DropdownMenuItem(
      child: Text('海德汉'),
      value: 'HDH',
    ),
    DropdownMenuItem(
      child: Text('海克斯康'),
      value: 'HEXAGON',
    ),
    DropdownMenuItem(
      child: Text('哈斯'),
      value: 'HASS',
    ),
    DropdownMenuItem(
      child: Text('精雕'),
      value: 'JD',
    ),
    DropdownMenuItem(
      child: Text('牧野EDM'),
      value: 'MAKINO',
    ),
    DropdownMenuItem(
      child: Text('沙迪克'),
      value: 'SODICK',
    ),
    DropdownMenuItem(
      child: Text('视觉检测'),
      value: 'VISUALRATE',
    ),
    DropdownMenuItem(
      child: Text('蔡司检测'),
      value: 'ZEISS',
    ),
    DropdownMenuItem(
      child: Text('烘干'),
      value: 'DRY',
    ),
    DropdownMenuItem(
      child: Text('清洗'),
      value: 'CLEAN',
    ),
    DropdownMenuItem(
      child: Text('三菱'),
      value: 'SLCNC',
    ),
    DropdownMenuItem(
      child: Text('KND'),
      value: 'KND',
    ),
    DropdownMenuItem(
      child: Text('广数'),
      value: 'GSK',
    ),
    DropdownMenuItem(
      child: Text('大隈（wei）'),
      value: 'OKUMA',
    ),
  ],
  'userConfig-MachineInfo-EactUnitePrg': [
    DropdownMenuItem(
      child: Text('不合并'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('Eact合并'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-CncPrgCallMode': [
    DropdownMenuItem(
      child: Text('MAIN'),
      value: 'MAIN',
    ),
    DropdownMenuItem(
      child: Text('M198'),
      value: 'M198',
    ),
    DropdownMenuItem(
      child: Text('M98'),
      value: 'M98',
    ),
  ],
  'userConfig-MachineInfo-ModifyInfoAddPositionMode': [
    DropdownMenuItem(
      child: SizedBox(
        width: 250.0,
        child: Text(
          '主程序',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      value: '0',
    ),
    DropdownMenuItem(
      child: SizedBox(
        width: 250.0,
        child: Text(
          '子程序',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-MainPrgGoOrginAddMode': [
    DropdownMenuItem(
      child: Text('不修改'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('插入至MainPrgFinishMark上方'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-SubPrgGoOrginAddMode': [
    DropdownMenuItem(
      child: Text('不修改'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('插入至SubPrgCallFinishMark上方'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-SubInsertDoorCtrlMode': [
    DropdownMenuItem(
      child: Text('不添加'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('添加'),
      value: '1',
    )
  ],
  'userConfig-MachineInfo-ElecHeightAddMode': [
    DropdownMenuItem(
      child: Text('不添加'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('插入至标识文本上方'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('插入至标识文本下方'),
      value: '2',
    )
  ],
  'userConfig-MachineInfo-SteelSetOffAddMode': [
    DropdownMenuItem(
      child: Text('不添加'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('必须添加(无数据则报错)'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('自动添加(有数据则添加，无数据则不添加)'),
      value: '2',
    )
  ],
  'userConfig-MachineInfo-SteelSetOffAddPos': [
    DropdownMenuItem(
      child: Text('插入至标识文本上方'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('插入至标识文本下方'),
      value: '2',
    ),
  ],
  'userConfig-MachineInfo-RepSpecifiedContentMode': [
    DropdownMenuItem(
      child: Text('不替换'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('替换'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-RepSpecifiedContentNum': [
    DropdownMenuItem(
      child: Text('替换一次'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('全部替换'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-RotatCoordinateAddMode': [
    DropdownMenuItem(
      child: Text('添加标识之前'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('添加标识之后'),
      value: '2',
    ),
  ],
  'userConfig-MachineInfo-RotatCoordinateAddNum': [
    DropdownMenuItem(
      child: Text('添加一次'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('所有标识出全部添加'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-ReturnRotatCoordinateMode': [
    DropdownMenuItem(
      child: Text('取消标识之前'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('取消标识之后'),
      value: '2',
    ),
  ],
  'userConfig-MachineInfo-ReturnRotatCoordinateNum': [
    DropdownMenuItem(
      child: Text('取消一次'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('所有标识出全部取消'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-ToolReplaceMode': [
    DropdownMenuItem(
      child: Text('不替换'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('替换'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-Tool_H_ReplaceMode': [
    DropdownMenuItem(
      child: Text('不替换'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('替换'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-DelTopAddMode': [
    DropdownMenuItem(
      child: Text('不添加'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('添加'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-CoordinatePeplaceMode': [
    DropdownMenuItem(
      child: Text('不替换'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('替换为配置 ChuckNum 里面的坐标系名称（对于单卡盘）'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-CoordinatePeplaceNum': [
    DropdownMenuItem(
      child: Text('替换一次'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('全部替换'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-AddPrgLineNumNode': [
    DropdownMenuItem(
      child: Text('不添加'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('添加'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-DeleteSpecifiedContentMode': [
    DropdownMenuItem(
      child: Text('不删除'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('删除'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-DeleteSpecifiedContentNum': [
    DropdownMenuItem(
      child: Text('删除一次'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('删除多次'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-AddProgramNameMode': [
    DropdownMenuItem(
      child: Text('不添加'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('添加之前'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('添加标志之后'),
      value: '2',
    ),
  ],
  'userConfig-MachineInfo-IsRemoveSpacesMode': [
    DropdownMenuItem(
      child: Text('不去掉'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('去掉'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-MainPrgUpMode': [
    DropdownMenuItem(
      child: Text('无需上传(机床主动调用PC上的程序或机床内部固定某一个)'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('FTP上传'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('机床共享目录拷贝'),
      value: '2',
    ),
    DropdownMenuItem(
      child: Text('API上传'),
      value: '3',
    ),
  ],
  'userConfig-MachineInfo-SubPrgUpMode': [
    DropdownMenuItem(
      child: Text('无子程序调用'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('FTP上传'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('机床共享目录拷贝'),
      value: '2',
    ),
    DropdownMenuItem(
      child: Text('API上传'),
      value: '3',
    ),
  ],
  'userConfig-MachineInfo-SubUpPrgNumbarMode': [
    DropdownMenuItem(
      child: Text('默认按照顺序全部上传'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('加工完成一个上传一个'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('加工中上传'),
      value: '2',
    ),
  ],
  'userConfig-MachineInfo-CopyMacCheckResultFileMark': [
    DropdownMenuItem(
      child: Text('不拷贝'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('拷贝'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-AutoDoor': [
    DropdownMenuItem(
      child: Text('机床自带自动门'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('EATM PLC控制'),
      value: '2',
    ),
  ],
  'userConfig-MachineInfo-OrginAbsoluteType': [
    DropdownMenuItem(
      child: Text('机械坐标'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('绝对坐标'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-MachineAheadTask': [
    DropdownMenuItem(
      child: Text('不提前上料'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('提前上料'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-MacBlowMode': [
    DropdownMenuItem(
      child: Text('不吹气'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('电气(PLC)控制吹气(机床加工完成软件控制开始吹气)'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('按照指定行(程序倒数指定行)开始吹气'),
      value: '2',
    ),
  ],
  'userConfig-MachineInfo-AutoOfflineType': [
    DropdownMenuItem(
      child: Text('不下线'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('下料后下线'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-MacFenceDoorExistMark': [
    DropdownMenuItem(
      child: Text('其他项目'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('联塑项目'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-MacReadAxesMacroMark': [
    DropdownMenuItem(
      child: Text('不读取'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('读取'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-IsWriteAxesMacroToSqlDB': [
    DropdownMenuItem(
      child: Text('不写入'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('写入'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-MacReadRotateMacroMark': [
    DropdownMenuItem(
      child: Text('不读取'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('读取'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-IsWriteRotateMacroToSqlDB': [
    DropdownMenuItem(
      child: Text('不写入'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('写入'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-RotateOffsetAddMode': [
    DropdownMenuItem(
      child: Text('不添加'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('必须添加(无数据则报错)'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('自动添加(有数据则添加，无数据则不添加)'),
      value: '2',
    ),
  ],
  'userConfig-MachineInfo-RotateOffsetAddPos': [
    DropdownMenuItem(
      child: Text('不插入'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('插入至标识文本上方'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('插入至标识文本下方'),
      value: '2',
    ),
  ],
  'userConfig-MachineInfo-MacMergerProgramMark': [
    DropdownMenuItem(
      child: Text('不合并'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('合并'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-ToolLifeOverflowOffineMark': [
    DropdownMenuItem(
      child: Text('不离线'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('离线'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-CopyCmmResultMark': [
    DropdownMenuItem(
      child: Text('不拷贝'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('拷贝至服务器'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-CmmResultFilePathPos': [
    DropdownMenuItem(
      child: Text('机床主程序路径（一汽，EAct生成）'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('机床本地Src路径（铸造，EAtm生成）'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-MacExistToolManagement': [
    DropdownMenuItem(
      child: Text('不存在'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('存在'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-ToolOpenPermissionMark': [
    DropdownMenuItem(
      child: Text('不开放'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('开放'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-MacExceptionHandle': [
    DropdownMenuItem(
      child: Text('异常后暂停'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('异常后下线,并清空卡盘'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-MacFinishNotToCleanMac': [
    DropdownMenuItem(
      child: Text('上清洗机'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('不上清洗机'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-ZeissConnectMode': [
    DropdownMenuItem(
      child: Text('IO模式'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('TCP模式'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-CmmDriveMode': [
    DropdownMenuItem(
      child: Text('仅驱动(zeiss)'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('编程+驱动(hexagon)'),
      value: '2',
    ),
    DropdownMenuItem(
      child: Text('EATM仅驱动（展会）'),
      value: '3',
    ),
    DropdownMenuItem(
      child: Text('EATM编程+驱动'),
      value: '4',
    ),
  ],
  'userConfig-MachineInfo-OilGrooveCtrlType': [
    DropdownMenuItem(
      child: Text('机床自身驱动'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('PLC来驱动'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-IsAutoMachineOnline': [
    DropdownMenuItem(
      child: Text('不关联'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('关联'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-EAtmMacDataCollectRange': [
    DropdownMenuItem(
      child: Text('只采集自动化用到的数据'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('采集全部机床信息（目前江苏信息用到1）'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-ChuckScanJustAnyone': [
    DropdownMenuItem(
      child: Text('默认全部扫描'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('只扫描一个'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-WorkSteelAbalmIsPutDown': [
    DropdownMenuItem(
      child: Text('不下料'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('下料'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-UseQieXyAndTieXcRecordMark': [
    DropdownMenuItem(
      child: Text('不启用'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('启用'),
      value: '1',
    ),
  ],
  'userConfig-MachineInfo-SteelPosBallMark': [
    DropdownMenuItem(
      child: Text('不需要分中'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('需要分中但不需要生成分中程序'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('需要分中同时需要生成分中程序'),
      value: '2',
    ),
  ],
  'FileServerType': [
    DropdownMenuItem(
      child: Text('ftp'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('共享目录或本地'),
      value: '2',
    ),
  ],
  'userConfig-EACTClientTcpInfo-FancMode': [
    DropdownMenuItem(
      child: Text('合并NC加工程式'),
      value: '1',
    ),
  ],
  'userConfig-DataBaseInfo-DBType': [
    DropdownMenuItem(
      child: Text('SQLSERVER'),
      value: 'SQLSERVER',
    ),
    DropdownMenuItem(
      child: Text('MYSQL'),
      value: 'MYSQL',
    ),
    DropdownMenuItem(
      child: Text('QSQLITE'),
      value: 'QSQLITE',
    ),
  ],
  'userConfig-DataBaseInfo-UseDbXml': [
    DropdownMenuItem(
      child: Text('查询数据库表'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('查询xml文件'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-RunMode': [
    DropdownMenuItem(
      child: Text('项目运行模式'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('模拟运行模式(连接虚拟设备)'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-CycleRun': [
    DropdownMenuItem(
      child: Text('不循环'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('循环运行(不记录数据-展会模式)'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('循环运行(记录数据)'),
      value: '2',
    ),
  ],
  'userConfig-SysInfo-ShelfIsOffLine': [
    DropdownMenuItem(
      child: Text('下线'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('不下线'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-PrgDownMode': [
    DropdownMenuItem(
      child: Text('自动'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('手选'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-CheckElecCncToolMark': [
    DropdownMenuItem(
      child: Text('不检查'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('检查'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-CheckFenceDoorMark': [
    DropdownMenuItem(
      child: Text('检查'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('不检查（威迪亚）'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-CmmSPsync': [
    DropdownMenuItem(
      child: Text('否'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('是'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-CopyMode': [
    DropdownMenuItem(
      child: Text('否'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('是'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-WorkpieceHeightSrc': [
    DropdownMenuItem(
      child: Text('数据库测高值'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('电极夹具高度+数据库电极尺寸高度'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-ReportSwitch': [
    DropdownMenuItem(
      child: Text('不报工'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('eman'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('eact'),
      value: '2',
    ),
  ],
  'userConfig-SysInfo-EdmMoreSteelTask': [
    DropdownMenuItem(
      child: Text('单钢件放完下线'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('多钢件连续放电'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-ShelfOfflineMode': [
    DropdownMenuItem(
      child: Text('下线所有货架'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('只下线当前货架'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-ThreeDimensionalElectrodeMark': [
    DropdownMenuItem(
      child: Text('不校验'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('校验'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-IsProcessQuadrantAngle': [
    DropdownMenuItem(
      child: Text('不调用'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('调用'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-SteelCCNCFinishUpClean': [
    DropdownMenuItem(
      child: Text('上'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('不上'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-CheckProcessStepSwitch': [
    DropdownMenuItem(
      child: Text('不分工步'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('分工步'),
      value: '1',
    ),
  ],
  'userConfig-SysInfo-GetServerPrgWorkOrderMark': [
    DropdownMenuItem(
      child: Text('不去查找'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('ftp'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('共享'),
      value: '2',
    ),
  ],
  'userConfig-SysInfo-RobotCarryWorkpieceTaskType': [
    DropdownMenuItem(
      child: Text('默认普通的任务8'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('任务9，搬运任务自带扫描芯片属性'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('8+1(搬运任务+扫描任务)'),
      value: '3',
    ),
  ],
  'userConfig-SysInfo-ToolLifeCollectMode': [
    DropdownMenuItem(
      child: Text('不采集'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('EAtm'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('EMdc'),
      value: '2',
    ),
  ],
  'userConfig-SysInfo-AbnormalairIsOffLineMac': [
    DropdownMenuItem(
      child: Text('默认下线'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('只提示不下线'),
      value: '1',
    ),
  ],
  'userConfig-FixtureInfo-AddFixtureType': [
    DropdownMenuItem(
      child: Text('不添加托盘类型'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('添加托盘类型'),
      value: '1',
    ),
  ],
  'userConfig-MachineScanTask-ScanType': [
    DropdownMenuItem(
      child: Text('默认扫描方式，只要不下线，就只扫描一次'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('只要初始上料 就扫描'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('不扫描'),
      value: '2',
    ),
  ],
  'userConfig-MachineScanTask-ScanClean': [
    DropdownMenuItem(
      child: Text('扫描清洗烘干'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('不扫描清洗烘干,开悟配置1'),
      value: '1',
    ),
  ],
  'userConfig-RobotInfo-RobotType': [
    DropdownMenuItem(
      child: Text('接口'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('dp'),
      value: '1',
    ),
  ],
  'userConfig-RobotInfo-RobotClampType': [
    DropdownMenuItem(
      child: Text('单卡爪'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('双卡爪'),
      value: '2',
    ),
  ],
  'userConfig-DataSourceType-nType': [
    DropdownMenuItem(
      child: Text('表数据直接在EATM表中'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('表数据来源于外部视图或者其他表结构'),
      value: '2',
    ),
  ],
  'userConfig-DataSourceType-ImportTable': [
    DropdownMenuItem(
      child: Text('工艺表-车床表'),
      value: '2',
    ),
    DropdownMenuItem(
      child: Text('工艺表-加工(CNC)表'),
      value: '3',
    ),
    DropdownMenuItem(
      child: Text('工艺表-检测表'),
      value: '4',
    ),
    DropdownMenuItem(
      child: Text('工艺表-放电表'),
      value: '5',
    ),
  ],
  'userConfig-DataBaseWorkReport-WorkReport': [
    DropdownMenuItem(
      child: Text('不需要'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('放电报工'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('加工检测报工'),
      value: '2',
    ),
  ],
  'userConfig-DataBaseWorkReport-EDMReportHandleMark': [
    DropdownMenuItem(
      child: Text('自动模式'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('手动模式'),
      value: '1',
    ),
  ],
  'userConfig-TcpScanDriverInfo-ServiceType': [
    DropdownMenuItem(
      child: Text('条码枪'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('巴鲁夫读头'),
      value: '2',
    ),
    DropdownMenuItem(
      child: Text('倍加福读头'),
      value: '3',
    ),
    DropdownMenuItem(
      child: Text('欧姆龙读头'),
      value: '4',
    ),
    DropdownMenuItem(
      child: Text('plc读头'),
      value: '5',
    ),
  ],
  'userConfig-EmanWorkReport-EmanReportMode': [
    DropdownMenuItem(
      child: Text('新框架报工'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('老框架报工'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('一汽'),
      value: '2',
    ),
    DropdownMenuItem(
      child: Text('标准接口'),
      value: '3',
    ),
    DropdownMenuItem(
      child: Text('威戈尔'),
      value: '4',
    ),
  ],
  'userConfig-EmanWorkReport-AgvStart': [
    DropdownMenuItem(
      child: Text('不开启'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('开启'),
      value: '1',
    ),
  ],
  'userConfig-EmanWorkReport-UseEmancraftRoute': [
    DropdownMenuItem(
      child: Text('否'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('是'),
      value: '1',
    ),
  ],
  'userConfig-TestCMMInfo-MacSystemType': [
    DropdownMenuItem(
      child: Text('测试'),
      value: 'TEST',
    ),
    DropdownMenuItem(
      child: Text('发那科'),
      value: 'FANUC',
    ),
    DropdownMenuItem(
      child: Text('海德汉'),
      value: 'HDH',
    ),
    DropdownMenuItem(
      child: Text('海克斯康'),
      value: 'HEXAGON',
    ),
    DropdownMenuItem(
      child: Text('哈斯'),
      value: 'HASS',
    ),
    DropdownMenuItem(
      child: Text('精雕'),
      value: 'JD',
    ),
    DropdownMenuItem(
      child: Text('牧野EDM'),
      value: 'MAKINO',
    ),
    DropdownMenuItem(
      child: Text('沙迪克'),
      value: 'SODICK',
    ),
    DropdownMenuItem(
      child: Text('视觉检测'),
      value: 'VISUALRATE',
    ),
    DropdownMenuItem(
      child: Text('蔡司检测'),
      value: 'ZEISS',
    ),
    DropdownMenuItem(
      child: Text('烘干'),
      value: 'DRY',
    ),
    DropdownMenuItem(
      child: Text('清洗'),
      value: 'CLEAN',
    ),
    DropdownMenuItem(
      child: Text('三菱'),
      value: 'SLCNC',
    ),
    DropdownMenuItem(
      child: Text('KND'),
      value: 'KND',
    ),
    DropdownMenuItem(
      child: Text('广数'),
      value: 'GSK',
    ),
    DropdownMenuItem(
      child: Text('大隈（wei）'),
      value: 'OKUMA',
    ),
  ],
  'ui-Shelf-ShelfSensorType': [
    DropdownMenuItem(
      child: Text('无传感器'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('平板'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('旋转'),
      value: '2',
    ),
    DropdownMenuItem(
      child: Text('对射'),
      value: '3',
    ),
  ],
  'ui-Shelf-ShelfFuncType': [
    DropdownMenuItem(
      child: Text('加工'),
      value: 'work',
    ),
    DropdownMenuItem(
      child: Text('装载'),
      value: 'transfer',
    ),
    DropdownMenuItem(
      child: Text('接驳'),
      value: 'connection',
    ),
    DropdownMenuItem(
      child: Text('预调'),
      value: 'preset',
    ),
  ],
  'ui-Shelf-CraftPriority': [
    DropdownMenuItem(
      child: Text('工艺来自数据库'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('工艺来自配置文件，不更新工艺表'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('工艺来自配置文件，会更新工艺表'),
      value: '2',
    ),
  ],
  'ui-Shelf-isNoScan': [
    DropdownMenuItem(
      child: Text('扫描'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('不扫描'),
      value: '1',
    ),
  ],
  'ui-Shelf-IOlimit': [
    DropdownMenuItem(
      child: Text('出+入'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('只入'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('只出'),
      value: '2',
    ),
  ],
  'ui-Shelf-MoreWorkpieceMark': [
    DropdownMenuItem(
      child: Text('不查托盘表'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('查托盘表，匹配监控编号'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('查托盘表匹配barcode'),
      value: '2',
    ),
    DropdownMenuItem(
      child: Text('匹配sn'),
      value: '3',
    ),
  ],
  'ui-Shelf-Locationfunction': [
    DropdownMenuItem(
      child: Text('通用'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('入库货位'),
      value: '1',
    ),
    DropdownMenuItem(
      child: Text('出库货位'),
      value: '2',
    ),
  ],
  'ui-GlobelInfo-CheckStrorageExist': [
    DropdownMenuItem(
      child: Text('否'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('是'),
      value: '1',
    ),
  ],
  'ui-GlobelInfo-AgvOperBtnShowMark': [
    DropdownMenuItem(
      child: Text('不显示'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('显示'),
      value: '1',
    ),
  ],
  'ui-GlobelInfo-ShowTipInfoMark': [
    DropdownMenuItem(
      child: Text('不显示'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('显示'),
      value: '1',
    ),
  ],
  'ui-GlobelInfo-BtnStartUpMachineMark': [
    DropdownMenuItem(
      child: Text('不显示'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('显示'),
      value: '1',
    ),
  ],
  'ui-GlobelInfo-BtnSetUpMachineMark': [
    DropdownMenuItem(
      child: Text('不显示'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('显示'),
      value: '1',
    ),
  ],
  'ui-RobotManualUI-TransferUIShow': [
    DropdownMenuItem(
      child: Text('不显示'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('显示'),
      value: '1',
    ),
  ],
  'ui-HideProgressBar-ProgressBarMode': [
    DropdownMenuItem(
      child: Text('不显示'),
      value: '0',
    ),
    DropdownMenuItem(
      child: Text('显示'),
      value: '1',
    ),
  ],
  // 'ui-HideQWidgetPage-MacUiWidgetePage': [
  //   DropdownMenuItem(
  //     child: Text('隐藏自动化机床界面'),
  //     value: '1',
  //   ),
  //   DropdownMenuItem(
  //     child: Text('隐藏刀具管理界面'),
  //     value: '2',
  //   ),
  // ],
};
