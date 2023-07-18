import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import 'choose_list.dart';
import 'field_group.dart';
import 'multiple_choice.dart';
import 'path_edit.dart';

enum RenderType {
  input,
  numberInput,
  select,
  toggleSwitch,
  radio,
  path,
  choose,
  custom,
  customMultipleChoice
}

class RenderFieldInfo implements RenderField {
  String field;
  String section;
  String? name;
  RenderType? renderType;
  Map<String, String>? options;
  ChooseType? chooseType;
  String? associatedField;
  String? associatedValue;
  bool? readOnly;
  Function(BuildContext)? builder;
  String? splitKey;
  List<DocumentationData>? documentationList;
  RenderFieldInfo(
      {required this.field,
      required this.section,
      this.name,
      this.renderType,
      this.options,
      this.chooseType,
      this.associatedField,
      this.associatedValue,
      this.readOnly,
      this.builder,
      this.splitKey,
      this.documentationList});

  String get fieldKey => '$section/$field';
}

class FieldChange extends StatefulWidget {
  const FieldChange({
    Key? key,
    required this.renderFieldInfo,
    this.showValue,
    required this.onChanged,
    this.isChanged = false,
    this.visible = true,
    this.builder,
    this.readOnly = false,
  }) : super(key: key);
  // final BuildContext context;
  final RenderFieldInfo renderFieldInfo;
  final String? showValue;
  final Function(String key, String value)? onChanged;
  final bool? isChanged;
  final bool? visible;
  final Function(BuildContext context)? builder;
  final bool? readOnly;

  @override
  _FieldChangeState createState() => _FieldChangeState();
}

class _FieldChangeState extends State<FieldChange> {
  // 渲染组件
  Widget renderComponent(
      BuildContext context, RenderFieldInfo renderFieldInfo) {
    if (!widget.visible!) return Container();
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
      case RenderType.path:
        currentComponent = renderPath(context, renderFieldInfo);
        break;
      case RenderType.choose:
        currentComponent = renderChooseList(context, renderFieldInfo);
        break;
      case RenderType.custom:
        currentComponent =
            widget.builder != null ? widget.builder!(context) : Container();
        break;
      case RenderType.customMultipleChoice:
        currentComponent = renderCustomMultipleChoice(context, renderFieldInfo);
        break;
      default:
        currentComponent = Container();
    }
    return Container(
      margin: EdgeInsets.only(bottom: 5.r),
      child: Card(
        padding: const EdgeInsets.all(0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40.r),
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
              IconButton(
                  icon: Icon(
                    FluentIcons.info_solid,
                    color: Colors.blue,
                    size: 18,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ContentDialog(
                            constraints: BoxConstraints(maxWidth: 600),
                            title:
                                Text('${renderFieldInfo.name}').fontSize(20.sp),
                            content: SizedBox(
                              height: 300.r,
                              child: SingleChildScrollView(
                                child: renderFieldInfo.documentationList != null
                                    ? Column(
                                        children: [
                                          for (var element in renderFieldInfo
                                              .documentationList!)
                                            if (element.type ==
                                                DocumentationType.text)
                                              Text(element.value).fontSize(14)
                                            else if (element.type ==
                                                DocumentationType.image)
                                              Image.asset(element.value),
                                        ],
                                      )
                                    : Text(
                                        '敬请期待',
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
                  }),
              5.horizontalSpaceRadius,
              GestureDetector(
                  onTap: () {},
                  child: MouseRegion(
                    // cursor: SystemMouseCursors.click,
                    child: SizedBox(
                        width: 300.r,
                        child: Tooltip(
                          message: renderFieldInfo.name ?? '',
                          child: Text(
                            renderFieldInfo.name ?? '',
                            softWrap: true,
                            maxLines: null,
                            // overflow: TextOverflow.ellipsis,
                          ).fontSize(14).fontWeight(FontWeight.bold),
                        )),
                  )),
              30.horizontalSpaceRadius,
              (renderType != RenderType.select &&
                      renderType != RenderType.toggleSwitch &&
                      renderType != RenderType.radio)
                  ? Expanded(
                      child: Text(
                      replaceEscape(widget.showValue ?? ''),
                      overflow: TextOverflow.ellipsis,
                    ).fontSize(14))
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
    return fieldInfo.readOnly == true
        ? Container()
        : FilledButton(
            child: const Text('编辑'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ContentDialog(
                      title: Text('${fieldInfo.name}').fontSize(20.sp),
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
                                  controller.text.trim());
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
    return fieldInfo.readOnly == true
        ? Container()
        : FilledButton(
            child: const Text('编辑'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ContentDialog(
                      title: Text('${fieldInfo.name}').fontSize(20.sp),
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
    return fieldInfo.readOnly == true
        ? Container(
            width: 400.r,
            padding: EdgeInsets.only(right: 10),
            child: Text(
              (widget.showValue != null && widget.showValue!.isNotEmpty)
                  ? fieldInfo.options!.entries
                      .singleWhere(
                          (element) => element.value == widget.showValue)
                      .key
                  : '',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          )
        : SizedBox(
            width: 400.r,
            child: ComboBox<String>(
              isExpanded: true,
              value: widget.showValue,
              placeholder: Text('请选择'),
              items: fieldInfo.options!.entries.map((e) {
                return ComboBoxItem(
                    value: e.value,
                    child: Tooltip(
                      message: e.key,
                      child: Text(
                        e.key,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ));
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
                if (fieldInfo.readOnly == true) return;
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
                      if (fieldInfo.readOnly == true) return;
                      widget.onChanged!(
                          "${widget.renderFieldInfo.section}/${widget.renderFieldInfo.field}",
                          e.value);
                    })))
            .toList(),
      ),
    );
  }

  // 渲染编辑路径组件
  Widget renderPath(BuildContext context, RenderFieldInfo fieldInfo) {
    var pathKey = GlobalKey();
    return FilledButton(
        child: const Text('编辑'),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  constraints: const BoxConstraints(maxWidth: 600),
                  title: Text('${fieldInfo.name}').fontSize(20.sp),
                  content: SizedBox(
                    width: 600,
                    height: 250,
                    child: PathEdit(
                      showValue: widget.showValue ?? '',
                      key: pathKey,
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
                          var pathEditState =
                              pathKey.currentState as PathEditState;
                          var value = pathEditState.currentValue.trim();
                          widget.onChanged!(
                              "${widget.renderFieldInfo.section}/${widget.renderFieldInfo.field}",
                              value);
                          Navigator.of(context).pop();
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  // 渲染选择查询列表组件
  Widget renderChooseList(BuildContext context, RenderFieldInfo fieldInfo) {
    var chooseListKey = GlobalKey();
    return FilledButton(
        child: const Text('选择'),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  title: Text('${fieldInfo.name}').fontSize(20.sp),
                  content: SizedBox(
                    height: 40,
                    child: ChooseList(
                      showValue: widget.showValue ?? '',
                      chooseType:
                          fieldInfo.chooseType ?? ChooseType.macProgramSource,
                      key: chooseListKey,
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
                          var chooseListState =
                              chooseListKey.currentState as ChooseListState;
                          var value = chooseListState.currentValue.trim();
                          widget.onChanged!(
                              "${widget.renderFieldInfo.section}/${widget.renderFieldInfo.field}",
                              value);
                          Navigator.of(context).pop();
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  // 渲染自定义多选组件
  Widget renderCustomMultipleChoice(
      BuildContext context, RenderFieldInfo fieldInfo) {
    var _key = GlobalKey();

    return FilledButton(
        child: const Text('编辑'),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  title: Text('${fieldInfo.name}').fontSize(20.sp),
                  content: SizedBox(
                    height: 250,
                    child: MultipleChoice(
                      key: _key,
                      showValue: widget.showValue ?? '',
                      splitKey: fieldInfo.splitKey ?? '-',
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
                          var chooseListState =
                              _key.currentState as MultipleChoiceState;
                          var value = chooseListState.currentValue.trim();
                          widget.onChanged!(
                              "${widget.renderFieldInfo.section}/${widget.renderFieldInfo.field}",
                              value);
                          Navigator.of(context).pop();
                        },
                        child: const Text('确定'))
                  ],
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return renderComponent(context, widget.renderFieldInfo);
  }
}

// 替换展示转义字符
String replaceEscape(String str) {
  escapeMap.forEach((key, value) {
    str = str.replaceAll(key, value);
  });
  return str;
}

class DocumentationData {
  DocumentationData({
    required this.type,
    required this.value,
  });
  DocumentationType type;
  String value;
}

// 文档类型
enum DocumentationType {
  text,
  image,
}
