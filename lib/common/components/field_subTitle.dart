/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-25 09:29:20
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-06-25 09:46:42
 * @FilePath: /eatm_ini_config/lib/common/components/field_subTitle.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'field_group.dart';

class RenderFieldSubTitle implements RenderField {
  String title;
  RenderFieldSubTitle({
    required this.title,
  });
}

class FieldSubTitle extends StatefulWidget {
  const FieldSubTitle({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _FieldSubTitleState createState() => _FieldSubTitleState();
}

class _FieldSubTitleState extends State<FieldSubTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.r),
              child: Text(
                widget.title,
                style: FluentTheme.of(context).typography.subtitle,
              ),
            ),
            10.verticalSpacingRadius,
            Divider()
          ],
        ));
  }
}
