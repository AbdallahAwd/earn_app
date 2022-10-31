import 'package:earnlia/features/home/domain/entities/reword.dart';

class RewordModel extends RewordEntity {
  const RewordModel(
      {required super.name,
      required super.amount,
      required super.adUrl,
      required super.description,
      required super.isDone,
      required super.isRecommended});
  factory RewordModel.fromJson(Map<String, dynamic> json) {
    return RewordModel(
        name: json['name'],
        description: json['description'],
        amount: json['amount'],
        adUrl: json['ad_url'],
        isDone: json['isDone'],
        isRecommended: json['isRecommended']);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'ad_url': adUrl,
        'description': description,
        'isDone': isDone,
        'isRecommended': isRecommended,
      };
}
