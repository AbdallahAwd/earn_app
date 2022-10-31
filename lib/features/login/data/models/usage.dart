class Usage {
  final int monday;
  final int tuesday;
  final int wednesday;
  final int thursday;
  final int friday;
  final int saturday;
  final int sunday;

  Usage(
      {required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.sunday});

  factory Usage.fromJson(Map<String, dynamic> json) => Usage(
      monday: json['Monday'],
      tuesday: json['Tuesday'],
      wednesday: json['Wednesday'],
      thursday: json['Thursday'],
      friday: json['Friday'],
      saturday: json['Saturday'],
      sunday: json['Sunday']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Monday'] = monday;
    data['Tuesday'] = tuesday;
    data['Wednesday'] = wednesday;
    data['Thursday'] = thursday;
    data['Friday'] = friday;
    data['Saturday'] = saturday;
    data['Sunday'] = sunday;

    return data;
  }
}
