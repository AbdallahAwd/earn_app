import 'package:earnlia/features/home/domain/entities/game.dart';

class GameModel extends GameEntity {
  const GameModel(
      {required super.gameName,
      required super.description,
      required super.package,
      required super.gameImage,
      required super.gameUrl,
      required super.isDone,
      required super.isRecommended,
      required super.amount});

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
        gameImage: json['game_img'],
        description: json['description'],
        gameUrl: json['game_url'],
        package: json['package'],
        gameName: json['game_name'],
        isDone: json['isDone'],
        isRecommended: json['isRecommended'],
        amount: json['amount']);
  }

  Map<String, dynamic> toJson() => {
        'game_name': gameName,
        'description': description,
        'game_url': gameUrl,
        'isDone': isDone,
        'isRecommended': isRecommended,
        'amount': amount,
        'game_img': gameImage,
      };
}
