import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/extensions.dart';
import 'package:mobile/interceptors/dio.dart';
import 'package:mobile/payments/apple_google/payment_config.dart';
import 'package:mobile/payments/paystack/payment_page.dart';
import 'package:mobile/providers/cart_provider.dart';
import 'package:mobile/providers/user_details.dart';
import 'package:mobile/screens/payments/bank_transfer.dart';
import 'package:mobile/constants.dart' as host;
import 'package:pay/pay.dart';

String getPlatform() {
  if (Platform.isIOS) return 'APPLEPAY';
  return 'GOOGLEPAY';
}

List paymentMethods = [
  'BANK_TRANSFER',
  getPlatform(),
  'PAYSTACK',
];

class CheckOutPage extends ConsumerStatefulWidget {
  const CheckOutPage({super.key});

  @override
  ConsumerState<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends ConsumerState<CheckOutPage> {
  double deliveryFees = 1500;
  String? deliveryAddress;
  late int selectedPaymentMethod;
  String addyTitle = 'Choose Address to Continue';

  @override
  void initState() {
    super.initState();
    selectedPaymentMethod = 0;
  }

  double cartTotalAmount(state) {
    List items = [];
    for (var element in state) {
      items.add(
        double.parse(element['product']['price']) * element['quantity'],
      );
    }
    double total = items.fold<double>(0, (a, b) => a + b);
    return total;
  }

  int cartQuantity(state) {
    List count = [];
    for (var element in state) {
      count.add(
        element['quantity'],
      );
    }
    double total = count.fold<double>(0, (a, b) => a + b);
    return total.toInt();
  }

  Future<Map?> placeOrder() async {
    try {
      host.dio.interceptors.add(DioInterceptor());

      final response = await host.dio.post('/api/order/place-order/');
      if (response.statusCode == 201) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  void proceedToPay(cart) {
    // Map? placedOrder = await placeOrder();

    if (mounted) {
      showModalBottomSheet(
        useSafeArea: true,
        enableDrag: true,
        isDismissible: false,
        elevation: 20,
        backgroundColor: Colors.grey.shade200,
        context: context,
        builder: (context) => BankTransferPaymentpage(
            // placedOrder: placedOrder,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(userCart);
    final cartTotal = cartTotalAmount(cart);
    final quantity = cartQuantity(cart);
    final total = cartTotal + deliveryFees;
    final userInfo = ref.watch(userDetail);

    if (userInfo!['address'] != null && userInfo['city'] != null) {
      deliveryAddress =
          '${userInfo['apt_no'] ?? ''} ${userInfo['address']}, ${userInfo['additional_info'] ?? ''} ${userInfo['city']}, ${userInfo['region']}';
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              width: double.infinity,
              color: Colors.grey.shade300,
              child: const Text('ORDER SUMMARY'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              width: double.infinity,
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Cart Total'),
                      Text(cartTotal.addComma()),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Item Quantity'),
                      Text(quantity.toString()),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Delivery fees'),
                      Text(deliveryFees.addComma()),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Total'), Text(total.addComma())],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              width: double.infinity,
              color: Colors.grey.shade300,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('DELIVERY ADDRESS'),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('profile');
                          },
                          child: const Text('Update Your profile')),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    color: Colors.grey.shade200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userInfo['full_name']),
                        const SizedBox(height: 5),
                        Text(userInfo['email']),
                        const SizedBox(height: 5),
                        if (deliveryAddress != null)
                          Chip(
                            label: Text(userInfo['phone_number']),
                            elevation: 5,
                            shadowColor: Colors.black,
                            surfaceTintColor: Colors.grey,
                          ),
                        const SizedBox(height: 10),
                        if (deliveryAddress != null)
                          Chip(
                            padding: const EdgeInsets.all(15),
                            label: Text(
                              deliveryAddress!,
                              maxLines: 2,
                              softWrap: true,
                            ),
                            elevation: 5,
                            shadowColor: Colors.black,
                            surfaceTintColor: Colors.grey,
                          ),
                        const SizedBox(height: 15),
                        if (deliveryAddress == null)
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('profile');
                            },
                            child:
                                const Text('Update your profile to continue'),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('SELECT PAYMENT METHOD'),
                        const SizedBox(height: 10),
                        Container(
                            width: double.infinity,
                            height: 80,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: paymentMethods.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedPaymentMethod = index;
                                      });
                                    },
                                    child: Chip(
                                      backgroundColor:
                                          selectedPaymentMethod == index
                                              ? Colors.lightBlue.shade100
                                              : Colors.white,
                                      label: Text(paymentMethods[index]),
                                    ),
                                  ),
                                );
                              },
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: payButton(cart, userInfo),
            ),
            const SizedBox(height: 10),
            if (deliveryAddress == null)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: null,
                  child: Text(
                    'You have not set a delivery address, Choose one or update your profile to continue with your order',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.deepOrangeAccent),
                  ),
                ),
              ),
          ],
        ),
      )),
    );
  }

  Widget payButton(cart, userInfo) {
    if (selectedPaymentMethod == 0) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: TextButton.icon(
          onPressed: deliveryAddress == null
              ? null
              : () {
                  proceedToPay(cart);
                },
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey.shade900,
            padding: const EdgeInsets.all(10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            disabledBackgroundColor: Colors.deepOrangeAccent.shade100,
          ),
          label: const Text(
            'Checkout with Local Transfer',
            style: TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          icon: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ),
      );
    }

    if (selectedPaymentMethod == 1) {
      if (Platform.isAndroid) {
        return GooglePayButton(
            height: 50,
            width: double.infinity,
            // onPressed: () {},
            type: GooglePayButtonType.checkout,
            loadingIndicator: const CupertinoActivityIndicator(),
            paymentConfiguration:
                PaymentConfiguration.fromJsonString(defaultGooglePay),
            onPaymentResult: ((result) {
              // send info to backend
              print(result);
            }),
            paymentItems: const []);
      }
      if (Platform.isIOS) {
        return ApplePayButton(
          style: ApplePayButtonStyle.white,
          height: 50,
          width: double.infinity,
          type: ApplePayButtonType.checkout,
          loadingIndicator: const CupertinoActivityIndicator(),
          paymentConfiguration:
              PaymentConfiguration.fromJsonString(defaultApplePay),
          onPaymentResult: ((result) {
            print(result);
          }),
          paymentItems: const [
            PaymentItem(
                amount: '2',
                label: 'total',
                status: PaymentItemStatus.final_price),
          ],
        );
      }
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton.icon(
        onPressed: deliveryAddress == null
            ? null
            : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PayStackPaymentPage(
                      amount: cartTotalAmount(cart).toString(),
                      email: userInfo['email'],
                      reference: userInfo['id'],
                    ),
                  ),
                );
              },
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey.shade900,
          padding: const EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          disabledBackgroundColor: Colors.deepOrangeAccent.shade100,
        ),
        label: const Text(
          'Checkout with PayStack',
          style: TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        icon: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
    );
  }
}
