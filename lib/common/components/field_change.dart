import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

enum RenderType { input, numberInput, select, toggleSwitch, radio }

class RenderFieldInfo {
  String field;
  String section;
  String? name;
  RenderType? renderType;
  Map<String, String>? options;
  RenderFieldInfo({
    required this.field,
    required this.section,
    this.name,
    this.renderType,
    this.options,
  });

  String get fieldKey => '$section/$field';
}

class FieldChange extends StatefulWidget {
  const FieldChange(
      {Key? key,
      required this.renderFieldInfo,
      this.showValue,
      required this.onChanged,
      this.isChanged = false})
      : super(key: key);
  // final BuildContext context;
  final RenderFieldInfo renderFieldInfo;
  final String? showValue;
  final Function(String key, String value)? onChanged;
  final bool? isChanged;

  @override
  _FieldChangeState createState() => _FieldChangeState();
}

class _FieldChangeState extends State<FieldChange> {
  // 渲染组件
  Widget renderComponent(
      BuildContext context, RenderFieldInfo renderFieldInfo) {
    var renderType = renderFieldInfo.renderType;
    // var componentType = getComponentType(field);
    Widget currentComponent = Container();
    switch (renderType) {
      case RenderType.input:
        currentComponent = renderInput(context, renderFieldInfo);
        break;
      case RenderType.numberInput:
        currentComponent = renderNumberInput(context, renderFieldInfo);
        break;
      case RenderType.select:
        currentComponent = renderSelect(context, renderFieldInfo);
        break;
      case RenderType.toggleSwitch:
        currentComponent = renderToggleSwitch(context, renderFieldInfo);
        break;
      case RenderType.radio:
        currentComponent = renderRadio(context, renderFieldInfo);
        break;
      default:
        currentComponent = Container();
    }
    return Container(
      margin: EdgeInsets.only(bottom: 5.r),
      child: Card(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 40.r),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 10.r,
                  height: 10.r,
                  decoration: BoxDecoration(
                    color: widget.isChanged!
                        ? Colors.blue.normal
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5.r),
                  )),
              20.horizontalSpaceRadius,
              GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ContentDialog(
                            title: Text('${renderFieldInfo.name}'),
                            content: SizedBox(
                              height: 300.r,
                              child: SingleChildScrollView(
                                child: Text(
                                  '测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试',
                                  softWrap: true,
                                  maxLines: null,
                                ).fontSize(22.sp),
                              ),
                            ),
                            actions: [
                              FilledButton(
                                  child: Text('确认'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })
                            ],
                          );
                        });
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: SizedBox(
                      width: 500.r,
                      child: Text(
                        renderFieldInfo.name ?? '',
                        softWrap: true,
                        maxLines: null,
                      ).fontSize(22.sp).fontWeight(FontWeight.bold),
                    ),
                  )),
              10.horizontalSpaceRadius,
              (renderType == RenderType.input ||
                      renderType == RenderType.numberInput)
                  ? Expanded(
                      child: Text(widget.showValue ?? '').fontSize(20.sp))
                  : Expanded(
                      child: Container(),
                    ),
              10.horizontalSpaceRadius,
              currentComponent
            ],
          ),
        ),
      ),
    );
  }

  // 渲染输入组件
  Widget renderInput(BuildContext context, RenderFieldInfo fieldInfo) {
    var controller = TextEditingController(text: widget.showValue ?? '');
    return FilledButton(
        child: const Text('编辑'),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  title: Text('${fieldInfo.name}').fontSize(24.sp),
                  content: TextBox(
                    controller: controller,
                    autofocus: true,
                  ),
                  actions: [
                    Button(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消')),
                    FilledButton(
                        onPressed: () {
                          widget.onChanged!(
                              "${widget.renderFieldInfo.section}/${widget.renderFieldInfo.field}",
                              controller.text);
                          Navigator.of(context).pop();
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  // 渲染数字输入组件
  Widget renderNumberInput(BuildContext context, RenderFieldInfo fieldInfo) {
    int? value = int.tryParse(widget.showValue ?? '') ?? 0;
    return FilledButton(
        child: const Text('编辑'),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  title: Text('${fieldInfo.name}').fontSize(24.sp),
                  content: NumberBox<int>(
                    value: value,
                    mode: SpinButtonPlacementMode.inline,
                    onChanged: (val) {
                      value = val != null ? val.toInt() : 0;
                    },
                    autofocus: true,
                  ),
                  actions: [
                    Button(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消')),
                    FilledButton(
                        onPressed: () {
                          widget.onChanged!(
                              "${widget.renderFieldInfo.section}/${widget.renderFieldInfo.field}",
                              value.toString());
                          Navigator.of(context).pop();
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  // 渲染下拉组件
  Widget renderSelect(BuildContext context, RenderFieldInfo fieldInfo) {
    return SizedBox(
      width: 500.r,
      child: ComboBox<String>(
        isExpanded: true,
        value: widget.showValue,
        items: fieldInfo.options!.entries.map((e) {
          return ComboBoxItem(
            value: e.value,
            child: Text(e.key),
          );
        }).toList(),
        onChanged: (val) {
          widget.onChanged!(
              "${widget.renderFieldInfo.section}/${widget.renderFieldInfo.field}",
              val!);
        },
      ),
    );
  }

  // 渲染开关组件
  Widget renderToggleSwitch(BuildContext context, RenderFieldInfo fieldInfo) {
    return SizedBox(
      child: Row(
        children: [
          ToggleSwitch(
              checked: widget.showValue == '1' ? true : false,
              onChanged: (v) {
                widget.onChanged!(
                    "${widget.renderFieldInfo.section}/${widget.renderFieldInfo.field}",
                    v ? '1' : '0');
              }),
          10.horizontalSpaceRadius,
          Text(widget.showValue == '1' ? '是' : '否')
        ],
      ),
    );
  }

  // 渲染单选组件
  Widget renderRadio(BuildContext context, RenderFieldInfo fieldInfo) {
    return Container(
      child: Row(
        children: fieldInfo.options!.entries
            .map((e) => Container(
                margin: const EdgeInsets.only(left: 20),
                child: RadioButton(
                    content: Text(e.key),
                    checked: e.value == widget.showValue,
                    onChanged: (value) {
                      widget.onChanged!(
                          "${widget.renderFieldInfo.section}/${widget.renderFieldInfo.field}",
                          e.value);
                    })))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return renderComponent(context, widget.renderFieldInfo);
  }
}
