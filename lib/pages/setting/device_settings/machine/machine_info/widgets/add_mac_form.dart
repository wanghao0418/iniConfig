import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'enum.dart';

class AddMacForm extends StatefulWidget {
  const AddMacForm({Key? key}) : super(key: key);

  @override
  AddMacFormState createState() => AddMacFormState();
}

class AddMacFormState extends State<AddMacForm> {
  final AddMac addMacForm = AddMac();
  Map currentSystemMap = {};
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Form(
          key: formKey,
          child: SizedBox(
            child: Column(children: [
              InfoLabel(
                label: '机床类型',
                child: ComboboxFormField(
                  isExpanded: true,
                  placeholder: Text('请选择'),
                  value: addMacForm.type,
                  items: MachineType.values
                      .map((e) => ComboBoxItem(
                            child: Text(e.value),
                            value: e.value,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      addMacForm.type = value.toString();
                      var type = MachineType.fromString(addMacForm.type!);
                      currentSystemMap = type!.systemOptions;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return '请选择机床类型';
                    }
                    return null;
                  },
                ),
              ),
              10.verticalSpacingRadius,
              if (addMacForm.type != null)
                InfoLabel(
                    label: '机床系统',
                    child: ComboboxFormField(
                      isExpanded: true,
                      value: addMacForm.system,
                      items: currentSystemMap.entries
                          .map((e) => ComboBoxItem(
                                child: Text(e.key),
                                value: e.value,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          addMacForm.system = value.toString();
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return '请选择机床系统';
                        }
                        return null;
                      },
                    )),
            ]),
          )),
    );
  }
}

class AddMac {
  String? type;
  String? system;

  AddMac({this.type, this.system});

  AddMac.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    system = json['system'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['system'] = system;
    return data;
  }
}
