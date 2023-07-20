/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-25 14:12:50
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-18 09:39:54
 * @FilePath: /eatm_ini_config/lib/common/api/common.dart
 * @Description: 公共api
 */
import 'package:iniConfig/common/utils/http.dart';

class CommonApi {
  // 字段查询
  static Future<ResponseApiBody> fieldQuery(data) async {
    ResponseApiBody responseBodyApi =
        await HttpUtil.post('/Eatm/iniConfig/userConfig/query', data: data);
    return responseBodyApi;
  }

  // 字段修改
  static Future<ResponseApiBody> fieldUpdate(data) async {
    ResponseApiBody responseBodyApi =
        await HttpUtil.post('/Eatm/iniConfig/userConfig/update', data: data);
    return responseBodyApi;
  }

  // 获取设备列表
  static Future<ResponseApiBody> getSectionList(data) async {
    ResponseApiBody responseBodyApi = await HttpUtil.post(
        '/Eatm/iniConfig/userConfig/getSectionList',
        data: data);
    return responseBodyApi;
  }

  // 获取节点详情
  static Future<ResponseApiBody> getSectionDetail(data) async {
    ResponseApiBody responseBodyApi = await HttpUtil.post(
        '/Eatm/iniConfig/userConfig/getSectionDetail',
        data: data);
    return responseBodyApi;
  }

  // 新增节点
  static Future<ResponseApiBody> addSection(data) async {
    ResponseApiBody responseBodyApi =
        await HttpUtil.post('/Eatm/iniConfig/userConfig/addNode', data: data);
    return responseBodyApi;
  }

  // 删除节点
  static Future<ResponseApiBody> deleteSection(data) async {
    ResponseApiBody responseBodyApi =
        await HttpUtil.post('/Eatm/iniConfig/userConfig/delNode', data: data);
    return responseBodyApi;
  }

  // 新增绑定节点
  static Future<ResponseApiBody> addBindSection(data) async {
    ResponseApiBody responseBodyApi = await HttpUtil.post(
        '/Eatm/iniConfig/userConfig/addBindNode',
        data: data);
    return responseBodyApi;
  }

  // 删除末尾节点
  static Future<ResponseApiBody> deleteLastSection(data) async {
    ResponseApiBody responseBodyApi = await HttpUtil.post(
        '/Eatm/iniConfig/userConfig/delLastNode',
        data: data);
    return responseBodyApi;
  }
}
