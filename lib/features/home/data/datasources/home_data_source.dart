import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earnlia/core/error/failuer.dart';
import 'package:earnlia/core/services/cache.dart';
import 'package:earnlia/core/utils/conponents.dart';
import 'package:earnlia/features/login/data/models/login_model.dart';
import 'package:earnlia/features/login/data/models/usage.dart';

abstract class BaseUserDataSource {
  Future<LoginModel> getUser();
  Future<void> updateUsageOfToday({required Usage usage});
  Future<void> updateBalance({required int balance, required int amount});
}

class UserDataSource extends BaseUserDataSource {
  @override
  Future<LoginModel> getUser() async {
    try {
      var userValues = await FirebaseFirestore.instance
          .collection('users')
          .doc(Cache.getData(key: 'uId'))
          .get();
      if (userValues.data() == null) {
        throw const DataBaseFailure('No user found');
      }
      LoginModel user = LoginModel.fromJson(userValues.data()!);
      return user;
    } on DataBaseFailure catch (e) {
      throw DataBaseFailure(e.message);
    }
  }

  @override
  Future<void> updateUsageOfToday({required Usage usage}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Cache.getData(key: 'uId'))
        .update({'usage': usage.toJson()});
  }

  @override
  Future<void> updateBalance(
      {required int balance, required int amount}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Cache.getData(key: 'uId'))
        .update({
      'balance': balance + amount,
      'last_update': C.formattedDate,
    });
  }
}
