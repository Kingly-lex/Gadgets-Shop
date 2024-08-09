import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/user_details.dart';

enum Gender {
  male,
  female,
  other,
}

class UpdateProfile extends ConsumerStatefulWidget {
  const UpdateProfile({super.key});

  @override
  ConsumerState<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends ConsumerState<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  Gender? gender;
  String? phone;
  String? aptNo;
  String? address;
  String? city;
  String? region;
  String? country;
  late Gender selectedGender;
  bool isSending = false;
  String updatechild = 'Update Profile';

  Gender setGender(String value) {
    if (value == 'Male') {
      return Gender.male;
    } else if (value == 'Female') {
      return Gender.female;
    }
    return Gender.other;
  }

  String returnGender(Gender gender) {
    if (gender == Gender.male) {
      return 'Male';
    } else if (gender == Gender.female) {
      return 'Female';
    }
    return "Other";
  }

  void resetForm() {
    _formKey.currentState!.reset();
  }

  @override
  void initState() {
    super.initState();
    selectedGender = Gender.other;
  }

  void submitProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isSending = true;
      });

      final Map data = {
        'first_name': firstName,
        'last_name': lastName,
        'gender': returnGender(selectedGender),
        'phone_number': phone,
        'apt_no': aptNo,
        'address': address,
        'city': city,
        'region': region,
        'country': country,
      };

      final details = await ref.read(userDetail.notifier).updateProfile(data);
      if (!details) {
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
              'Profile Updated',
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
    final userDetails = ref.watch(userDetail);
    selectedGender = userDetails!['gender'] == null
        ? Gender.other
        : setGender(userDetails['gender']);
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
        title: const Text(
          'Update your profile',
          style: TextStyle(color: Colors.white),
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
                    initialValue: userDetails['full_name'].split(' ')[0],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    decoration: const InputDecoration(
                        labelText: "First Name", border: OutlineInputBorder()),
                    validator: (value) {
                      if (value != null &&
                          value.trim().isNotEmpty &&
                          value.length > 2 &&
                          value.length <= 50) {
                        return null;
                      }
                      return "Invalid input, Must be between 2 and 50 characters";
                    },
                    onSaved: (value) {
                      firstName = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: userDetails['full_name'].split(' ')[1],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    decoration: const InputDecoration(
                        labelText: "Last Name", border: OutlineInputBorder()),
                    validator: (value) {
                      if (value != null &&
                          value.trim().isNotEmpty &&
                          value.length > 2 &&
                          value.length <= 50) {
                        return null;
                      }
                      return "Invalid input, Must be between 2 and 50 characters";
                    },
                    onSaved: (value) {
                      lastName = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField(
                          value: selectedGender,
                          onChanged: (value) {
                            selectedGender = value;
                          },
                          items: <DropdownMenuItem>[
                            for (final item in Gender.values)
                              DropdownMenuItem(
                                value: item,
                                child: Text(item.name),
                              )
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          initialValue: userDetails['phone_number'],
                          decoration: const InputDecoration(
                            labelText: "Phone number",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value != null &&
                                value.trim().isNotEmpty &&
                                value.length > 10 &&
                                value.length <= 14) {
                              return null;
                            }
                            return "Invalid input, Must be between 11 and 14 characters";
                          },
                          onSaved: (value) {
                            phone = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: userDetails['apt_no'],
                    decoration: const InputDecoration(
                        labelText: "Apartment number",
                        border: OutlineInputBorder()),
                    onSaved: (value) {
                      aptNo = value!.trim().isEmpty ? null : value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: userDetails['address'],
                    decoration: const InputDecoration(
                        labelText: "Address", border: OutlineInputBorder()),
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
                      address = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: userDetails['city'],
                          decoration: const InputDecoration(
                              labelText: "City", border: OutlineInputBorder()),
                          validator: (value) {
                            if (value != null &&
                                value.trim().isNotEmpty &&
                                value.length > 1 &&
                                value.length <= 20) {
                              return null;
                            }
                            return "Invalid input, Must be between 1 and 20 characters";
                          },
                          onSaved: (value) {
                            city = value;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          initialValue: userDetails['region'],
                          decoration: const InputDecoration(
                              labelText: "Region / State",
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value != null &&
                                value.trim().isNotEmpty &&
                                value.length > 1 &&
                                value.length <= 20) {
                              return null;
                            }
                            return "Invalid input, Must be between 1 and 20 characters";
                          },
                          onSaved: (value) {
                            region = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: userDetails['country'],
                    decoration: const InputDecoration(
                        labelText: "Country", border: OutlineInputBorder()),
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
                      country = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style:
                          TextButton.styleFrom(alignment: Alignment.centerLeft),
                      onPressed: () {
                        Navigator.of(context).pushNamed('address_book');
                      },
                      child: const Text('Extra Addresses'),
                    ),
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
                        onPressed: submitProfile,
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
                                updatechild,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      )
                    ],
                  ),
                ],
              )),
        ),
      )),
    );
  }
}
