part of 'get_receiver_details_bloc.dart';

abstract class TransferEvent extends Equatable {
  const TransferEvent();
}

class GetReceiverUserDetailsEvent extends TransferEvent {
  final int accountNumber;

  GetReceiverUserDetailsEvent({@required this.accountNumber});

  @override
  List<Object> get props => [];
}

class MakeTransferFundEvent extends TransferEvent {
  final int accountNumber;
  final int amount;

  MakeTransferFundEvent({@required this.accountNumber, @required this.amount});

  @override
  List<Object> get props => [];
}
