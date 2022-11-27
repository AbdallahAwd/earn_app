import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earnlia/features/home/data/models/game_model.dart';
import 'package:earnlia/features/home/data/models/invited.dart';
import 'package:earnlia/features/home/domain/entities/game.dart';
import 'package:earnlia/features/home/domain/usecases/home_usercase.dart';
import 'package:earnlia/features/login/domain/entities/login_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usage_stats/usage_stats.dart';

import '../../../../core/services/cache.dart';
import '../../../../core/services/locator.dart';
import '../../../login/data/models/usage.dart';
import '../../data/models/rewords_model.dart';
import '../../domain/entities/reword.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);
  int usageTime = 0;
  getUsage() async {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(hours: 12));

    // grant usage permission - opens Usage Settings
    UsageStats.grantUsagePermission();

    // check if permission is granted
    await UsageStats.checkUsagePermission();

    // query aggregated usage statistics
    Map<String, UsageInfo> queryAndAggregateUsageStats =
        await UsageStats.queryAndAggregateUsageStats(startDate, endDate);

    int time = int.parse(queryAndAggregateUsageStats['com.amaa.earnlia']!
        .totalTimeInForeground!);
    usageTime = (time / 60 / 60 / 24).ceil() + 3;
  }

  late LogInEntity model;
  late int balance;
  Future<void> getUser() async {
    var user = await HomeUseCase(sl()).getUser();
    user.fold((l) => emit(HomeState(error: l.message, states: States.error)),
        (r) {
      model = r;
      balance = r.balance;
      emit(HomeState(user: r, states: States.success));
    });
  }

  List<String> id = [];
  Stream<List<RewordEntity>> getRewords() {
    id = [];
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Cache.getData(key: 'uId'))
        .collection('rewords')
        .snapshots()
        .asyncMap((event) => event.docs.map((e) {
              id.add(e.id);
              return RewordModel.fromJson(e.data());
            }).toList());
  }

  List<String> gameId = [];
  Stream<List<GameEntity>> getGames() {
    gameId = [];
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Cache.getData(key: 'uId'))
        .collection('games')
        .snapshots()
        .asyncMap((event) => event.docs.map((e) {
              gameId.add(e.id);
              return GameModel.fromJson(e.data());
            }).toList());
  }

  void deleteReword(int index, bool isDone) async {
    if (isDone) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Cache.getData(key: 'uId'))
          .collection('rewords')
          .doc(id[index])
          .delete();
    }
  }

  void usageOfToday({
    required Usage usage,
  }) async {
    var usageTime = await HomeUseCase(sl()).usageOfToday(usage: usage);
    usageTime.fold((l) => HomeState(states: States.error, error: l.message),
        (r) => emit(const HomeState(states: States.success)));
  }

  void updateBalance({
    required int amount,
  }) async {
    var updateBalance = await HomeUseCase(sl())
        .updateBalance(amount: amount, balance: state.user!.balance);

    updateBalance.fold(
        (l) => emit(HomeState(states: States.error, error: l.message)),
        (r) => emit(const HomeState(states: States.success)));
  }

  void sendPaypalAccount(String email) {
    FirebaseFirestore.instance
        .collection('Paypal')
        .doc(Cache.getData(key: 'uId'))
        .set({'paypalEmail': email});

    FirebaseFirestore.instance
        .collection('users')
        .doc(Cache.getData(key: 'uId'))
        .update({'balance': 0});
  }

  String _invitedUid = '';
  Future<bool> searchCode(String code) async {
    try {
      var getCode = await FirebaseFirestore.instance
          .collection('codes')
          .where('uid', isGreaterThanOrEqualTo: code)
          .get();
      _invitedUid = getCode.docs[0].get('uid');

      return _invitedUid.contains(code);
    } catch (e) {
      return false;
    }
  }

  void applyInvitation(String code) async {
    if (await searchCode(code)) {
      var invitedUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(_invitedUid)
          .get();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_invitedUid)
          .update({
        'balance': invitedUser.data()!['balance'] + 4500,
      });

      FirebaseFirestore.instance
          .collection('users')
          .doc(_invitedUid)
          .collection('invitedPeople')
          .add({'avatar': state.user!.avatar, 'name': state.user!.name});

      FirebaseFirestore.instance
          .collection('users')
          .doc(Cache.getData(key: 'uId'))
          .update({'isInvited': true});
      balance += 2000;
      FirebaseFirestore.instance
          .collection('users')
          .doc(Cache.getData(key: 'uId'))
          .update({'balance': state.user!.balance + 2000});
    }
  }

  List<InvitedPeople> invitedPeople = [];
  getInvitedPeople() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(Cache.getData(key: 'uId'))
        .collection('invitedPeople')
        .snapshots()
        .listen((event) {
      invitedPeople = [];
      for (var element in event.docs) {
        invitedPeople.add(InvitedPeople.fromJson(element.data()));
      }
    });
  }

  void updateAvatar(String newAvatar) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(Cache.getData(key: 'uId'))
        .update({'avatar': newAvatar});
  }

  void logOut() {
    Cache.removeData('uId');
    FirebaseAuth.instance.signOut();
  }
}
