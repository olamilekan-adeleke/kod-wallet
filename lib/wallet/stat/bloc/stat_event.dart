part of 'stat_bloc.dart';

abstract class StatEvent extends Equatable {
  const StatEvent();
}

class GetStatEvent extends StatEvent {
  final int month;

  GetStatEvent({@required this.month});

  @override
  List<Object> get props => [month];
}
