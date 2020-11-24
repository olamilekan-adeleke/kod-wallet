import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kod_wallet_app/wallet/history/bloc/history_bloc.dart';
import 'package:kod_wallet_app/wallet/history/enum/filter_enum.dart';
import 'package:kod_wallet_app/wallet/profile/update_user_bloc/update_user_details_bloc.dart';
import 'package:kod_wallet_app/wallet/stat/bloc/stat_bloc.dart';
import 'package:kod_wallet_app/wallet/transfer/bloc/get_receiver_bloc/get_receiver_details_bloc.dart';

List<BlocProvider> blocList({@required BuildContext context}) {
  return <BlocProvider>[
    BlocProvider<UpdateUserDetailsBloc>(
      create: (BuildContext context) => UpdateUserDetailsBloc(),
    ),
    BlocProvider<HistoryBloc>(
      create: (BuildContext context) => HistoryBloc()
        ..add(GetAllHistoryEvent(
          queryEnum: FilterEnum.All,
          lastDoc: null,
        )),
    ),
    BlocProvider<TransferBloc>(
      create: (BuildContext context) => TransferBloc(),
    ),
    BlocProvider<StatBloc>(
      create: (BuildContext context) => StatBloc()
        ..add(
          GetStatEvent(
            month: DateTime.now().month,
          ),
        ),
    ),
  ];
}
