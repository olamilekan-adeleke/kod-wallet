part of 'update_user_details_bloc.dart';

abstract class UpdateUserDetailsEvent extends Equatable {
  const UpdateUserDetailsEvent();
}

class UpdateDetailsEvent extends UpdateUserDetailsEvent {
  final UserModel userData;

  UpdateDetailsEvent({@required this.userData});

  @override
  List<Object> get props => [];
}
