import 'package:flutter/material.dart';
import '../common/data_color_custom_setting.dart';

class CustomCard extends StatefulWidget {
  final Widget containChild;
  final String? title;
  final Color? cardBackgroundColor;
  final Color? headBorderColor;
  final Widget? titleRight;
  final Color? headTextColor;
  final EdgeInsets? padding;
  final BuildContext? currentContext;

  const CustomCard(
      {Key? key,
      required this.containChild,
      this.title,
      this.cardBackgroundColor,
      this.headBorderColor,
      this.titleRight,
      this.headTextColor,
      this.padding,
      this.currentContext})
      : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  final DataColorCustomSetting _colorCustomSetting =
      DataColorCustomSetting.init();
  late bool _isDark = false;

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Widget renderContainer(
      BuildContext context,
      Widget containChild,
      String? title,
      Color? headBorderColor,
      Widget? titleRight,
      Color? headTextColor) {
    return title == null
        ? SizedBox(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: containChild,
                  ),
                )
              ],
            ),
          )
        : SizedBox(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: headBorderColor ?? Colors.grey.shade300))),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: headTextColor ??
                                  Theme.of(widget.currentContext ?? context)
                                      .textTheme
                                      .bodyText1
                                      ?.color),
                        ),
                        Container(
                          child: titleRight,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: containChild,
                  ),
                )
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    _isDark = isDarkMode(widget.currentContext ?? context);
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: widget.padding,
      decoration: BoxDecoration(
          color: widget.cardBackgroundColor ??
              (_isDark
                  ? _colorCustomSetting.ColorWidget
                  : _colorCustomSetting.ColorWidgetLight),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(20, 0, 0, 0),
                offset: Offset(2, 2),
                blurRadius: 5),
          ]),
      child: renderContainer(context, widget.containChild, widget.title,
          widget.headBorderColor, widget.titleRight, widget.headTextColor),
    );
  }
}
