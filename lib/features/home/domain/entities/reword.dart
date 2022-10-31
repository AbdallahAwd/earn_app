import 'package:equatable/equatable.dart';

class RewordEntity extends Equatable {
  final String adUrl;
  final String name;
  final String description;
  final int amount;
  final bool isDone;
  final bool isRecommended;

  const RewordEntity({
    required this.description,
    required this.name,
    required this.amount,
    required this.adUrl,
    required this.isDone,
    required this.isRecommended,
  });

  @override
  List<Object?> get props => [
        name,
        adUrl,
        amount,
        isDone,
        isRecommended,
      ];
}
