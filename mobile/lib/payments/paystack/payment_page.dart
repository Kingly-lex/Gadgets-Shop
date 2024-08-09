import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/data/paystack.dart';
import 'package:mobile/payments/paystack/paystack_auth_response.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayStackPaymentPage extends StatefulWidget {
  const PayStackPaymentPage({
    super.key,
    required this.email,
    required this.amount,
    required this.reference,
  });

  final String email;
  final String amount;
  final String reference;

  @override
  State<PayStackPaymentPage> createState() => _PayStackPaymentPageState();
}

class _PayStackPaymentPageState extends State<PayStackPaymentPage> {
  Future<PayStackAuthResponse> initializePayment() async {
    // Paystack host url
    const String url = 'https://api.paystack.co/transaction/initialize';

    final Map data = {
      'email': widget.email,
      'amount': widget.amount,
      'reference': widget.reference,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          'Authorization': 'Bearer ${PayStackApiKey.apiKey}',
          'Content-Type': 'application/json',
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        // successfully initilized
        final responseData = jsonDecode(response.body);
        // return response
        return PayStackAuthResponse.fromJson(responseData['data']);
      } else {
        throw 'Payment unsuccesful';
      }
    } catch (e) {
      throw 'Payment unsuccesful: ${e.toString()}';
    }
  }

  Future<String> startPaymentTransaction() async {
    final authResponse = await initializePayment();
    return authResponse.authorizationUrl;
  }

  // build context
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: FutureBuilder(
          future: startPaymentTransaction(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  softWrap: true,
                ),
              );
            }

            return WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadRequest(Uri.parse(snapshot.data!)),
            );
          },
        ),
      ),
    );
  }
}
