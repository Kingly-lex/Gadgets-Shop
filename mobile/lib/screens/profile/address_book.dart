import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/user_details.dart';
import 'package:mobile/screens/profile/add_address.dart';

class AddressBook extends ConsumerStatefulWidget {
  const AddressBook({super.key, this.isCheckOut = false});

  final bool isCheckOut;

  @override
  ConsumerState<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends ConsumerState<AddressBook> {
  bool isSelected = false;
  String? selectedAddress;
  bool cardIsSelected = false;
  int? selectedCard;

  @override
  Widget build(BuildContext context) {
    final userDetails = ref.watch(userDetail);

    final List addresses = userDetails!['delivery_addresses'];
    final int addressCount = addresses.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'More Addresses ( $addressCount )',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 18),
          child: Column(
            children: [
              if (addressCount > 0)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: addressCount,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    final apt = address['apt_no'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCard = index;
                          });
                        },
                        child: Card(
                          elevation: 5,
                          color: selectedCard == index
                              ? Colors.lightBlue.shade100
                              : Colors.grey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${apt ?? ''} ${address['address']}'),
                                const SizedBox(height: 10),
                                if (address['additional_info'] != null)
                                  Text('${address['additional_info']}'),
                                const SizedBox(height: 10),
                                Text('${address['city']}'),
                                const SizedBox(height: 5),
                                Text('${address['region']}'),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => AddAdressPage(
                                            isEditing: true,
                                            address: address,
                                          ),
                                        ));
                                      },
                                      child: const Chip(
                                        label: Text('edit'),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: const Chip(
                                        label: Text('delete'),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              if (addressCount < 3)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed('add_address');
                    },
                    icon: const Icon(Icons.add),
                    style: TextButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      shape: const BeveledRectangleBorder(),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    label: const Text(
                      'Add new delivery address',
                      style: TextStyle(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      )),
    );
  }
}
