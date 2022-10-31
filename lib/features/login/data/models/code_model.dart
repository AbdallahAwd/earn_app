import 'package:equatable/equatable.dart';

class CodeModel extends Equatable {
  final String uId;

  const CodeModel(this.uId);

  factory CodeModel.fromJson(Map<String, dynamic> json) =>
      CodeModel(json['uid']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    data['uid'] = uId;
    return data;
  }

  @override
  List<Object?> get props => [uId];
}
