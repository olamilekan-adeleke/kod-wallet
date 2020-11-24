part of 'stat_bloc.dart';

abstract class StatState extends Equatable {
  const StatState();
}

class InitialStatState extends StatState {
  @override
  List<Object> get props => [];
}

class LoadingStatState extends StatState {
  @override
  List<Object> get props => [];
}

class LoadedStatState extends StatState {
  final StatModel statModel;

  LoadedStatState({@required this.statModel});

  @override
  List<Object> get props => [];
}

class ErrorStatState extends StatState {
  final String message;

  ErrorStatState({@required this.message});

  @override
  List<Object> get props => [message];
}

