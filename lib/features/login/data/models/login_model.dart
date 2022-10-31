import 'package:earnlia/features/login/data/models/usage.dart';
import 'package:earnlia/features/login/domain/entities/login_entity.dart';

class LoginModel extends LogInEntity {
  const LoginModel(
      {required super.name,
      required super.email,
      required super.lastBalanceUpdate,
      required super.usage,
      required super.uId,
      required super.refferalCode,
      required super.balance,
      required super.isInvited,
      required super.avatar,
      required super.location});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
        name: json['name'],
        email: json['email'],
        lastBalanceUpdate: json['last_update'],
        uId: json['uId'],
        refferalCode: json['refferal_code'],
        balance: json['balance'],
        usage: Usage.fromJson(json['usage']),
        isInvited: json['isInvited'],
        avatar: json['avatar'],
        location: json['location']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['uId'] = uId;
    data['refferal_code'] = refferalCode;
    data['balance'] = balance;
    data['last_update'] = lastBalanceUpdate;
    data['isInvited'] = isInvited;
    data['usage'] = usage.toJson();
    data['avatar'] = avatar;
    data['location'] = location;
    return data;
  }
}
