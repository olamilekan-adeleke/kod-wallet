import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:kod_wallet_app/wallet/stat/model/stat_modle.dart';
import 'package:kod_wallet_app/wallet/stat/repo/stat_repo.dart';

part 'stat_event.dart';
part 'stat_state.dart';

class StatBloc extends Bloc<StatEvent, StatState> {
  StatBloc() : super(InitialStatState());

  @override
  Stream<StatState> mapEventToState(
    StatEvent event,
  ) async* {
    if (event is GetStatEvent) {
      try {
        yield LoadingStatState();
        StatModel stat = await StatRepo().getUserStat(month: event.month);
        yield LoadedStatState(statModel: stat);
      } catch (e) {
        yield ErrorStatState(message: e);
      }
    }
  }
}
