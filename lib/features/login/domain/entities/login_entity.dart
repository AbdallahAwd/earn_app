import 'package:equatable/equatable.dart';

import '../../data/models/usage.dart';

class LogInEntity extends Equatable {
  final String name;
  final String email;
  final String uId;
  final String refferalCode;
  final int balance;
  final String lastBalanceUpdate;
  final bool isInvited;
  final String avatar;
  final String location;
  final Usage usage;

  const LogInEntity(
      {required this.lastBalanceUpdate,
      required this.usage,
      required this.name,
      required this.email,
      required this.uId,
      required this.refferalCode,
      required this.balance,
      required this.isInvited,
      required this.avatar,
      required this.location});

  @override
  List<Object?> get props =>
      [name, email, uId, refferalCode, balance, isInvited, avatar, location];
}
