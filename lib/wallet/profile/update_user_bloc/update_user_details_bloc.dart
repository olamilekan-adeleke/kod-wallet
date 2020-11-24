import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:kod_wallet_app/auth/model/user_model.dart';
import 'package:kod_wallet_app/wallet/profile/repo/profile_methods.dart';

part 'update_user_details_event.dart';
part 'update_user_details_state.dart';

class UpdateUserDetailsBloc
    extends Bloc<UpdateUserDetailsEvent, UpdateUserDetailsState> {
  UpdateUserDetailsBloc() : super(InitialUpdateUserDetailsState());

  @override
  Stream<UpdateUserDetailsState> mapEventToState(
    UpdateUserDetailsEvent event,
  ) async* {
    if(event is UpdateDetailsEvent){
      try {
        yield LoadingUpdateUserDetailsState();
        await ProfileMethods().updateUserData(userData: event.userData);
        yield LoadedUpdateUserDetailsState();
      }on SocketException{
        ErrorUpdateUserDetailsState(message: 'No InterNet Connection!');
      }catch(e, s){
        debugPrint(e);
        debugPrint(s.toString());
        ErrorUpdateUserDetailsState(message: '${e.message}');
      }
    }
  }
}
