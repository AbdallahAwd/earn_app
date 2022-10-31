part of 'home_cubit.dart';

class HomeState extends Equatable {
  final LogInEntity? user;
  final RewordEntity? reword;
  final String error;
  final States states;
  const HomeState(
      {this.reword, this.states = States.loading, this.error = '', this.user});

  @override
  List<Object> get props => [error, states];
}

class HomeInitial extends HomeState {}

class DeletedDone extends HomeState {}

// class Loading extends HomeState {}

// class GetUserSuccess extends HomeState {}

// class GetUserError extends HomeErrorState {
//   const GetUserError(super.error);
// }

enum States { loading, success, error }
