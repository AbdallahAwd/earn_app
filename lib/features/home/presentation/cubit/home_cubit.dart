import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earnlia/features/home/data/models/game_model.dart';
import 'package:earnlia/features/home/domain/entities/game.dart';
import 'package:earnlia/features/home/domain/usecases/home_usercase.dart';
import 'package:earnlia/features/login/domain/entities/login_entity.dart';
import 'package:equatable/equatable.dart';
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

  void getUser() async {
    var user = await HomeUseCase(sl()).getUser();
    user.fold((l) => emit(HomeState(error: l.message, states: States.error)),
        (r) {
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

  void deleteReword(int index, isDone) async {
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
}
