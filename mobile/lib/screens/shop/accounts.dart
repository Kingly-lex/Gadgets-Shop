import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/user_details.dart';
import 'package:iconsax/iconsax.dart';

class AccountsPage extends ConsumerStatefulWidget {
  const AccountsPage({super.key});

  @override
  ConsumerState<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends ConsumerState<AccountsPage> {
  late final Future<Map?> details;

  @override
  void initState() {
    super.initState();
    details = ref.read(userDetail.notifier).getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = ref.watch(userDetail);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Page',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('cart');
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.grey.shade900,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
          child: FutureBuilder(
        future: details,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CupertinoActivityIndicator(
              radius: 17,
              color: Colors.deepOrangeAccent,
            ));
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('An error occured'),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.grey.shade900,
                floating: true,
                snap: true,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey.shade900),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    userDetails!['profile_photo'],
                    fit: BoxFit.cover,
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userDetails['full_name'],
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      userDetails['email'],
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('profile');
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.lightBlueAccent),
                      ))
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  color: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  alignment: Alignment.centerLeft,
                  height: 45,
                  child: Text(
                    'My Gadgets-Shop Account',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey.shade100,
                      width: double.infinity,
                      child: TextButton.icon(
                        style:
                            const ButtonStyle(alignment: Alignment.centerLeft),
                        onPressed: () {},
                        label: Text('Orders',
                            style: TextStyle(color: Colors.grey.shade900)),
                        icon: const Icon(Iconsax.medal),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      color: Colors.grey.shade100,
                      width: double.infinity,
                      child: TextButton.icon(
                        style:
                            const ButtonStyle(alignment: Alignment.centerLeft),
                        onPressed: () {},
                        label: Text('Saved Favourites',
                            style: TextStyle(color: Colors.grey.shade900)),
                        icon: const Icon(Icons.favorite_outline),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      color: Colors.grey.shade100,
                      width: double.infinity,
                      child: TextButton.icon(
                        style:
                            const ButtonStyle(alignment: Alignment.centerLeft),
                        onPressed: () {},
                        label: Text('Inbox',
                            style: TextStyle(color: Colors.grey.shade900)),
                        icon: const Icon(Iconsax.direct_inbox),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      color: Colors.grey.shade100,
                      width: double.infinity,
                      child: TextButton.icon(
                        style:
                            const ButtonStyle(alignment: Alignment.centerLeft),
                        onPressed: () {},
                        label: Text('Recent searches',
                            style: TextStyle(color: Colors.grey.shade900)),
                        icon: const Icon(Iconsax.medal),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  color: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  alignment: Alignment.centerLeft,
                  height: 45,
                  child: Text(
                    'Settings and TOS',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey.shade100,
                      width: double.infinity,
                      child: TextButton.icon(
                        style:
                            const ButtonStyle(alignment: Alignment.centerLeft),
                        onPressed: () {
                          Navigator.of(context).pushNamed('address_book');
                        },
                        label: Text('Extra Delivery Addresses',
                            style: TextStyle(color: Colors.grey.shade900)),
                        icon: const Icon(Iconsax.medal),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      color: Colors.grey.shade100,
                      width: double.infinity,
                      child: TextButton.icon(
                        style:
                            const ButtonStyle(alignment: Alignment.centerLeft),
                        onPressed: () {},
                        label: Text('Change password',
                            style: TextStyle(color: Colors.grey.shade900)),
                        icon: const Icon(Icons.favorite_outline),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      color: Colors.grey.shade100,
                      width: double.infinity,
                      child: TextButton.icon(
                        style:
                            const ButtonStyle(alignment: Alignment.centerLeft),
                        onPressed: () {},
                        label: Text('Delete Your Account',
                            style: TextStyle(color: Colors.grey.shade900)),
                        icon: const Icon(Iconsax.direct_inbox),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      color: Colors.grey.shade100,
                      width: double.infinity,
                      child: TextButton.icon(
                        style:
                            const ButtonStyle(alignment: Alignment.centerLeft),
                        onPressed: () {},
                        label: Text('Terms of service',
                            style: TextStyle(color: Colors.grey.shade900)),
                        icon: const Icon(Iconsax.medal),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  color: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  alignment: Alignment.center,
                  height: 45,
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.deepOrangeAccent,
                    ),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 10,
                      ),
                      backgroundColor: Colors.grey.shade300,
                      shape: const BeveledRectangleBorder(),
                      surfaceTintColor: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      )),
    );
  }
}
