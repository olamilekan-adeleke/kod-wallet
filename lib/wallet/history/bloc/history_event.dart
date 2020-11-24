part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
}

class GetAllHistoryEvent extends HistoryEvent {
  final FilterEnum queryEnum;
  final TransferHistory lastDoc;
  final String keyword;

  GetAllHistoryEvent(
      {@required this.queryEnum, @required this.lastDoc, this.keyword});

  @override
  List<Object> get props => [];
}
