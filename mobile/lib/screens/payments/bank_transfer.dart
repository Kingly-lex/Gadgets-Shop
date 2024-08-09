import 'package:flutter/material.dart';

class BankTransferPaymentpage extends StatefulWidget {
  const BankTransferPaymentpage({
    super.key,
    // required this.placedOrder,
  });

  // final Map? placedOrder;

  @override
  State<BankTransferPaymentpage> createState() =>
      _BankTransferPaymentpageState();
}

class _BankTransferPaymentpageState extends State<BankTransferPaymentpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ),
                    const Chip(
                      label: Text('Local Bank Transfer'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Complete Your Order',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please make a transfer to the account below, if possible, use the ref code in payment description.',
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: double.infinity,
                  child: Card(
                    surfaceTintColor: Colors.blueGrey,
                    elevation: 5,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: Gadgets Shop NG',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Bank: Access Bank Nigeria',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Account number: 0090008877',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: TextButton.icon(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      disabledBackgroundColor: Colors.deepOrangeAccent.shade100,
                    ),
                    label: const Text(
                      'Okay',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
