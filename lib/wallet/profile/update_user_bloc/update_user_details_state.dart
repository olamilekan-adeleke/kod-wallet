part of 'update_user_details_bloc.dart';

abstract class UpdateUserDetailsState extends Equatable {
  const UpdateUserDetailsState();
}

class InitialUpdateUserDetailsState extends UpdateUserDetailsState {
  @override
  List<Object> get props => [];
}

class LoadingUpdateUserDetailsState extends UpdateUserDetailsState {
  @override
  List<Object> get props => [];
}

class LoadedUpdateUserDetailsState extends UpdateUserDetailsState {
  @override
  List<Object> get props => [];
}

class ErrorUpdateUserDetailsState extends UpdateUserDetailsState {
  final String message;

  ErrorUpdateUserDetailsState({@required this.message});

  @override
  List<Object> get props => [];
}
