import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:kod_wallet_app/wallet/history/enum/filter_enum.dart';
import 'package:kod_wallet_app/wallet/history/repo/history_repo.dart';
import 'package:kod_wallet_app/wallet/transfer/model/transfer_model.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(InitialHistoryState());
  bool isFetching = false;

  @override
  Stream<HistoryState> mapEventToState(
    HistoryEvent event,
  ) async* {
    if (event is GetAllHistoryEvent) {
      try {
        yield LoadingHistoryState();
//        await Future.delayed(Duration(seconds: 2));
        List<TransferHistory> list = await HistoryMethods().getHistory(
          lastDoc: event.lastDoc,
          filterEnum: event.queryEnum,
          keyword: event.keyword,
        );
        yield LoadedHistoryState(historyList: list);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield ErrorHistoryState(message: e.toString());
      }
    }
  }
}
