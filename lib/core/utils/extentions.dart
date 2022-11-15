import 'package:appcheck/appcheck.dart';
import 'package:earnlia/features/home/domain/entities/game.dart';

extension Formate on int {
  double fromCtoUSD() {
    return this / 10000;
  }

  String daysOfTheWeek() {
    switch (this) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return (this - 7).daysOfTheWeek();
    }
  }
}

extension FormateDate on String {
  int formateDateToNum() {
    int dateToNum = int.parse(split('-').join(''));
    return dateToNum;
  }

  int formateDate() {
    List<String> list = split('-');
    int dateToNum = int.parse(list[2]);
    return dateToNum;
  }
}

extension Avilablitiy on GameEntity {
  Future<bool> available() async {
    bool? isAvailable = await AppCheck.isAppEnabled(package);
    return isAvailable;
  }
}
