import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kod_wallet_app/auth/model/user_model.dart';
import 'package:kod_wallet_app/wallet/transfer/repo/transfer_repo.dart';

part 'get_receiver_details_event.dart';
part 'get_receiver_details_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  TransferBloc() : super(InitialGetReceiverDetailsState());

  @override
  Stream<TransferState> mapEventToState(
    TransferEvent event,
  ) async* {
    if (event is GetReceiverUserDetailsEvent) {
      try {
        yield LoadingGetReceiverDetailsState();
        UserModel userDetails = await TransferRepo()
            .getUserDetailsByAccountNumber(event.accountNumber);
        yield LoadedGetReceiverDetailsState(userDetails: userDetails);
      } catch (e) {
        yield ErrorGetReceiverDetailsState(message: e.message.toString());
      }
    } else if (event is MakeTransferFundEvent) {
      try {
        yield LoadingTransferFundState();
        await TransferRepo().initTransfer(
          accountNumber: event.accountNumber,
          amount: event.amount,
        );
        yield LoadedTransferFundState();
      } catch (e) {
        yield ErrorTransferFundState(message: e.message.toString());
      }
    }
  }
}
