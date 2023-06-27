enum MachineType {
  CNC(value: 'CNC', systemOptions: {
    "发那科": "FANUC",
    "海德汉": "HDH",
    "哈斯": "HASS",
    "精雕": "JD",
    "三菱": "SLCNC",
    "KND": "KND",
    "广数": "GSK",
    "大隈（wei）": "OKUMA",
    "测试": "TEST"
  }),
  CMM(value: 'CMM', systemOptions: {
    "海克斯康": "HEXAGON",
    "视觉检测": "VISUALRATE",
    "蔡司检测": "ZEISS",
    "测试": "TEST"
  }),
  EDM(
      value: 'EDM',
      systemOptions: {"牧野EDM": "MAKINO", "沙迪克": "SODICK", "测试": "TEST"}),
  CLEAN(value: 'CLEAN', systemOptions: {"清洗": "CLEAN", "测试": "TEST"}),
  DRY(value: 'DRY', systemOptions: {"烘干": "DRY", "测试": "TEST"});

  const MachineType({required this.value, required this.systemOptions});
  final String value;
  final Map systemOptions;

  static MachineType? fromString(String? value) {
    if (value == null) return null;
    return MachineType.values.firstWhere((e) => e.value == value,
        orElse: () => throw ArgumentError('Unknown MachineType value: $value'));
  }
}
