import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;
import 'package:kod_wallet_app/constant.dart';
import 'package:kod_wallet_app/wallet/home/repo/wallet_methods.dart';
import 'package:kod_wallet_app/wallet/transfer/model/transfer_model.dart';

import '../../../helper.dart';

class FundWallet {
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().microsecondsSinceEpoch}';
  }

  Future<String> createAccessCode(skTest, _getReference) async {
    // skTest -> Secret key
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $skTest'
    };

    Map data = {
      "amount": 600,
      "email": "johnsonoye34@gmail.com",
      "reference": _getReference
    };

    String payload = json.encode(data);
    http.Response response = await http.post(
      'https://api.paystack.co/transaction/initialize',
      headers: headers,
      body: payload,
    );

    final Map _data = jsonDecode(response.body);
    String accessCode = _data['data']['access_code'];

    return accessCode;
  }

  Future<void> _verifyOnServer(String reference,
      {@required BuildContext context}) async {
    String skTest = secretKey;

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $skTest',
      };

      http.Response response = await http.get(
        'https://api.paystack.co/transaction/verify/' + reference,
        headers: headers,
      );

      final Map body = json.decode(response.body);

      if (body['data']['status'] == 'success') {
        showBasicsFlash(
          message: 'Payment SucessFull',
          context: context,
          color: Colors.green,
        );
      } else {
        showBasicsFlash(message: 'Error Occured', context: context);
      }
    } catch (e) {
      print(e);
      showBasicsFlash(message: 'Error: ${e.message}', context: context);
    }
  }

  Future chargeCard({
    @required int price,
    @required BuildContext context,
    @required String userEmail,
    @required TransferHistory history,
  }) async {
    Charge charge = Charge()
      ..amount = (price * 100).toInt()
      ..reference = _getReference()
//..accessCode = _createAcessCode(skTest, _getReference())
      ..email = userEmail;
    CheckoutResponse response = await PaystackPlugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    if (response.status == true) {
      await _verifyOnServer(response.reference, context: context);
      WalletMethods().updateWallet(
        amount: price,
        history: history,
      );
    } else {
      print('error');
    }
  }
}
