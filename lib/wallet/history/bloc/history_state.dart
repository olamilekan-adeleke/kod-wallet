part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
}

class InitialHistoryState extends HistoryState {
  @override
  List<Object> get props => [];
}

class LoadingHistoryState extends HistoryState {
  @override
  List<Object> get props => [];
}

class LoadedHistoryState extends HistoryState {
  final List<TransferHistory> historyList;

  LoadedHistoryState({@required this.historyList});

  @override
  List<Object> get props => [];
}

class ErrorHistoryState extends HistoryState {
  final String message;

  ErrorHistoryState({@required this.message});

  @override
  List<Object> get props => [];
}
