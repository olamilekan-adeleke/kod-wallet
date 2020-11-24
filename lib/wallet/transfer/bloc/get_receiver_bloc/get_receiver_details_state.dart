part of 'get_receiver_details_bloc.dart';

abstract class TransferState extends Equatable {
  const TransferState();
}

class InitialGetReceiverDetailsState extends TransferState {
  @override
  List<Object> get props => [];
}

class LoadingGetReceiverDetailsState extends TransferState {
  @override
  List<Object> get props => [];
}

class LoadedGetReceiverDetailsState extends TransferState {
  final UserModel userDetails;

  LoadedGetReceiverDetailsState({@required this.userDetails});

  @override
  List<Object> get props => [userDetails];
}

class ErrorGetReceiverDetailsState extends TransferState {
  final String message;

  ErrorGetReceiverDetailsState({@required this.message});

  @override
  List<Object> get props => [];
}


class InitialTransferFundState extends TransferState {
  @override
  List<Object> get props => [];
}

class LoadingTransferFundState extends TransferState {
  @override
  List<Object> get props => [];
}

class LoadedTransferFundState extends TransferState {
  @override
  List<Object> get props => [];
}

class ErrorTransferFundState extends TransferState {
  final String message;

  ErrorTransferFundState({@required this.message});

  @override
  List<Object> get props => [];
}
