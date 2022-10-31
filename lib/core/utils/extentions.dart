extension Formate on int {
  String formateZero() {
    String sNumber = toString();
    int index = 0;
    List<String> lNumber = [];
    if (!sNumber.contains('0')) throw 'No zero values';
    for (var i = 0; i < sNumber.length; i++) {
      index++;
      lNumber.add(sNumber[i]);
    }

    if (index <= 4) return sNumber;

    if (index.isOdd) {
      lNumber.insert((index / 2).floor(), ',');
    } else {
      lNumber.insert((index / 2).ceil(), ',');
    }
    return lNumber.join('');
  }

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
  int formateDate() {
    int dateToNum = int.parse(split('-').join(''));
    return dateToNum;
  }
}
