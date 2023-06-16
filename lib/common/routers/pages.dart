import 'package:get/get.dart';
import 'package:iniConfig/pages/system/home/view.dart';

import 'names.dart';

class RoutePages {
  // 列表
  static List<GetPage> list = [
    GetPage(
      name: RouteNames.main,
      page: () => const HomePage(),
    ),
  ];
}
