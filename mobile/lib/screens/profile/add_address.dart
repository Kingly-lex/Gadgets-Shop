import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/user_details.dart';

class AddAdressPage extends ConsumerStatefulWidget {
  const AddAdressPage({
    super.key,
    this.isEditing = false,
    this.address,
  });

  final bool isEditing;
  final Map? address;

  @override
  ConsumerState<AddAdressPage> createState() => _AddAdressPageState();
}

class _AddAdressPageState extends ConsumerState<AddAdressPage> {
  String? address;
  String? aptNo;
  String? additionalInfo;
  String? city;
  String? region;
  bool isSending = false;
  String updatechild = 'Add Address';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final Map data = {
        'delivery_addresses': [
          {
            'apt_no': aptNo,
            'additional_info': additionalInfo,
            'address': address,
            'city': city,
            'region': region,
          }
        ]
      };

      final response = await ref.read(userDetail.notifier).updateProfile(data);

      if (!response) {
        // do something
      }

      if (mounted) {
        setState(() {
          isSending = false;
          updatechild = "Updated";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: true,
            duration: const Duration(milliseconds: 1000),
            backgroundColor: Colors.grey[800],
            content: const Text(
              'Address Added',
              textAlign: TextAlign.center,
            ),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          widget.isEditing ? 'Update Address' : 'Add address',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 18),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue:
                        widget.isEditing ? widget.address!['apt_no'] : '',
                    decoration: const InputDecoration(
                        labelText: "Apartment number (optional)",
                        border: OutlineInputBorder()),
                    onSaved: (value) {
                      aptNo = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue:
                        widget.isEditing ? widget.address!['address'] : '',
                    decoration: const InputDecoration(
                        labelText: "Address", border: OutlineInputBorder()),
                    validator: (value) {
                      if (value != null &&
                          value.trim().isNotEmpty &&
                          value.length > 1 &&
                          value.length <= 80) {
                        return null;
                      }
                      return "Invalid input, Must be between 1 and 80 characters";
                    },
                    onSaved: (value) {
                      address = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: widget.isEditing
                        ? widget.address!['additional_info']
                        : '',
                    decoration: const InputDecoration(
                      labelText: "Additional info (optional)",
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      additionalInfo = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue:
                        widget.isEditing ? widget.address!['city'] : '',
                    decoration: const InputDecoration(
                        labelText: "City", border: OutlineInputBorder()),
                    validator: (value) {
                      if (value != null &&
                          value.trim().isNotEmpty &&
                          value.length > 1 &&
                          value.length <= 50) {
                        return null;
                      }
                      return "Invalid input, Must be between 1 and 50 characters";
                    },
                    onSaved: (value) {
                      city = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue:
                        widget.isEditing ? widget.address!['region'] : '',
                    decoration: const InputDecoration(
                        labelText: "Region/ State",
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value != null &&
                          value.trim().isNotEmpty &&
                          value.length > 1 &&
                          value.length <= 50) {
                        return null;
                      }
                      return "Invalid input, Must be between 1 and 50 characters";
                    },
                    onSaved: (value) {
                      region = value;
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: isSending
                            ? null
                            : () {
                                Navigator.of(context).pop();
                              },
                        child: const Text('cancel'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: onSubmit,
                        style: ElevatedButton.styleFrom(
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor: Colors.deepOrangeAccent),
                        child: isSending
                            ? const CupertinoActivityIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                widget.isEditing
                                    ? 'Update Address'
                                    : updatechild,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      )
                    ],
                  ),
                ],
              ),
            )),
      )),
    );
  }
}
