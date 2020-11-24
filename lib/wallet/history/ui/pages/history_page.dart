import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kod_wallet_app/helper.dart';
import 'package:kod_wallet_app/wallet/history/bloc/history_bloc.dart';
import 'package:kod_wallet_app/wallet/history/enum/filter_enum.dart';
import 'package:kod_wallet_app/wallet/history/ui/views/history_views.dart';
import 'package:kod_wallet_app/wallet/transfer/model/transfer_model.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchKeyController = TextEditingController();
  FilterEnum _filterEnum = FilterEnum.All;
  List<TransferHistory> historyList = [];
  String keyword;
  TransferHistory lastDoc;
  bool showLoading = true;

  void search() {
    String query = searchKeyController.text.trim();
    if (query.length > 2) {
      keyword = query;
      _filterEnum = FilterEnum.Search;
      historyList.clear();
      BlocProvider.of<HistoryBloc>(context).add(GetAllHistoryEvent(
        queryEnum: FilterEnum.Search,
        lastDoc: null,
        keyword: query,
      ));
    } else {
      print('Too Short');
    }
  }

  void filterSearch(FilterEnum filterEnum) {
    debugPrint(filterEnum.toString());
    _filterEnum = filterEnum;
    historyList.clear();
    BlocProvider.of<HistoryBloc>(context).add(GetAllHistoryEvent(
      queryEnum: filterEnum,
      lastDoc: null,
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: bodyList(),
      ),
    );
  }

  Widget blocBuilder() {
    return BlocConsumer<HistoryBloc, HistoryState>(
      listener: (context, HistoryState state) {
        print(state.toString());
        if (state is LoadingHistoryState) {
          BlocProvider.of<HistoryBloc>(context).isFetching = true;
        } else if (state is LoadedHistoryState) {
          BlocProvider.of<HistoryBloc>(context).isFetching = false;
          if (state.historyList.isEmpty) {
            showLoading = false;
            showBasicsFlash(
              context: context,
              message: 'No More Histroy!',
              duration: Duration(seconds: 1),
            );
          } else {
            print('adding ${state.historyList.length} to list ');
            historyList.addAll(state.historyList);
            lastDoc = historyList != null && historyList.isNotEmpty
                ? historyList[historyList.length - 1]
                : null;
            showLoading = false;
          }
        }
      },
      builder: (context, HistoryState state) {
        if (state is InitialHistoryState) {
          return Center(child: Text('Search'));
        } else if (state is LoadingHistoryState) {
          showLoading = true;
          if (historyList.isEmpty) {
            return Container(child: CircularProgressIndicator());
          }
        } else if (state is ErrorHistoryState) {
          if (historyList.isEmpty) {
            return Center(child: Text('${state.message}'));
          }
        }
        print('len: ${historyList.length}');
        return resultList(
          historyList: historyList,
          scrollController: _scrollController
            ..addListener(() {
              if (_scrollController.offset ==
                  _scrollController.position.maxScrollExtent) {
                print('end of list');
                print(context.bloc<HistoryBloc>().isFetching);
                if (context.bloc<HistoryBloc>().isFetching == false) {
                  print('got here');
                  context.bloc<HistoryBloc>()
                    ..isFetching = true
                    ..add(GetAllHistoryEvent(
                      queryEnum: _filterEnum,
                      lastDoc: lastDoc,
                      keyword: keyword,
                    ));
                }
              }
            }),
          showLoading: showLoading,
        );
      },
    );
  }

  Widget bodyList() {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            searchBar(controller: searchKeyController, function: search),
            filterOption(function: (_enum) => filterSearch(_enum)),
          ],
        ),
        SizedBox(height: 10),
        blocBuilder(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
