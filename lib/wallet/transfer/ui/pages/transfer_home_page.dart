import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kod_wallet_app/helper.dart';
import 'package:kod_wallet_app/wallet/transfer/bloc/get_receiver_bloc/get_receiver_details_bloc.dart';
import 'package:kod_wallet_app/wallet/transfer/ui/views/transfer_views.dart';

class TransferHomePage extends StatefulWidget {
  @override
  _TransferHomePageState createState() => _TransferHomePageState();
}

class _TransferHomePageState extends State<TransferHomePage> {
  final accountNumberFormKey = GlobalKey<FormState>();
  final amountAndDesFormKey = GlobalKey<FormState>();
  StreamController<bool> loadingReceiverDataStream =
      StreamController<bool>.broadcast()..add(false);
  TextEditingController receiverAccountNumController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void getReceiverDetails() {
    String _receiverAccountNumber = receiverAccountNumController.text.trim();
    if (_receiverAccountNumber.length >= 10) {
      int _accountNumber = int.parse(_receiverAccountNumber);
      BlocProvider.of<TransferBloc>(context)
          .add(GetReceiverUserDetailsEvent(accountNumber: _accountNumber));
    } else {
      loadingReceiverDataStream.add(false);
    }
  }

  Future<void> makeTransfer() async {
    final accountFrom = accountNumberFormKey.currentState;
    final amountAndDesFrom = amountAndDesFormKey.currentState;
    if (accountFrom.validate() && amountAndDesFrom.validate()) {
      String _accountNumber = receiverAccountNumController.text.trim();
      String _amount = amountController.text.trim();

      BlocProvider.of<TransferBloc>(context).add(
        MakeTransferFundEvent(
          accountNumber: int.parse(_accountNumber),
          amount: int.parse(_amount),
        ),
      );

      loadingReceiverDataStream.add(false);
    } else {
      showBasicsFlash(context: context, message: 'Please Provide Vaild Inputs');
    }
  }

  @override
  void dispose() {
    loadingReceiverDataStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customTransferAppBar(title: 'Transfers'),
      body: bodyList(),
    );
  }

  Widget bodyList() {
    return ListView(
      children: [
        SizedBox(height: 40),
        headerImage(),
        SizedBox(height: 40),
        accountNumberForm(),
        amountAndDesForm(),
        SizedBox(height: 60),
        buttonBlocStream(),
      ],
    );
  }

  Widget headerImage() {
    return Container(
      child: Image.asset(
        'asset/images/transfer_money.png',
        fit: BoxFit.contain,
        height: 150,
      ),
    );
  }

  Widget buttonBlocStream() {
    return BlocConsumer<TransferBloc, TransferState>(
      listener: (context, state) {
        if (state is ErrorTransferFundState) {
          showBasicsFlash(
            context: context,
            message: state.message,
            color: Colors.red,
            duration: Duration(seconds: 4),
          );
        } else if (state is LoadedTransferFundState) {
          showBasicsFlash(
            context: context,
            message: 'Fund Has Being Sucessfully Transfered!!',
            color: Colors.green,
            duration: Duration(seconds: 4),
          );

          amountAndDesFormKey.currentState.reset();
          accountNumberFormKey.currentState.reset();
        }
      },
      builder: (context, state) {
        if (state is LoadingTransferFundState) {
          return Center(child: CircularProgressIndicator());
        }

        return button(
          loadingStream: loadingReceiverDataStream.stream
              .where((event) => event == true || event == false),
          function: () => makeTransfer(),
        );
      },
    );
  }

  Widget receiverDetailsWidget() {
    return BlocConsumer<TransferBloc, TransferState>(
      listener: (context, state) {
        debugPrint(state.toString());
        if (state is ErrorGetReceiverDetailsState) {
          showBasicsFlash(
            context: context,
            message: '${state.message}',
            color: Colors.red,
            duration: Duration(seconds: 4),
          );
        } else if (state is LoadedGetReceiverDetailsState) {
          print('1');
          if (state.userDetails == null) {
            showBasicsFlash(
              context: context,
              message: 'No User Was Found!!',
              color: Colors.red,
            );
          } else {
            loadingReceiverDataStream.add(true);
            print('2');
          }
          print('3');
        } else if (state is LoadingGetReceiverDetailsState) {
          loadingReceiverDataStream.add(false);
        }
      },
      builder: (context, state) {
        if (state is InitialGetReceiverDetailsState) {
          return receiverDataWidget(message: 'Enter Account Number....');
        } else if (state is LoadingGetReceiverDetailsState) {
          return receiverDataWidget(
            message: 'Loading....',
            color: Colors.green,
          );
        } else if (state is LoadedGetReceiverDetailsState) {
          if (state.userDetails == null) {
            return receiverDataWidget(
              message: 'No User Was Found!!',
              color: Colors.red,
            );
          }
          return receiverDataWidget(
              message: '${state.userDetails.fullName}', color: Colors.green);
        } else if (state is ErrorGetReceiverDetailsState) {
          return receiverDataWidget(
              message: 'Opps Error: No User Found...', color: Colors.red);
        } else {
          return receiverDataWidget(message: 'Enter Account Number....');
        }
      },
    );
  }

  Widget accountNumberForm() {
    return Form(
      onChanged: () {
        getReceiverDetails();
      },
      key: accountNumberFormKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            formTitle('Enter Receiver Account Number'),
            customTransferTextField(
              keyboardAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              padding: EdgeInsets.symmetric(horizontal: 15),
              title: 'Receiver Account Number',
              controller: receiverAccountNumController,
              itemLengthCheck: 10,
              maxLength: 10,
            ),
            receiverDetailsWidget(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget amountAndDesForm() {
    return Form(
      key: amountAndDesFormKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            formTitle('Enter Amount'),
            customTransferTextField(
              keyboardType: TextInputType.number,
              padding: EdgeInsets.symmetric(horizontal: 15),
              title: 'Amount',
              controller: amountController,
              itemLengthCheck: 1,
            ),
            SizedBox(height: 20),
            formTitle('Transaction Description'),
            customTransferTextField(
              padding: EdgeInsets.symmetric(horizontal: 15),
              title: 'Description',
              controller: descriptionController,
              itemLengthCheck: 3,
            ),
          ],
        ),
      ),
    );
  }

//  @override
//  bool get wantKeepAlive => true;
}
