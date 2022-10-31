import 'package:equatable/equatable.dart';

class GameEntity extends Equatable {
  final String gameName;
  final String description;
  final String gameImage;
  final String gameUrl;
  final bool isDone;
  final bool isRecommended;
  final int amount;

  const GameEntity(
      {required this.gameName,
      required this.description,
      required this.gameImage,
      required this.gameUrl,
      required this.isDone,
      required this.isRecommended,
      required this.amount});

  @override
  List<Object?> get props => [
        gameName,
        description,
        gameUrl,
        amount,
        isDone,
        isRecommended,
      ];
}
