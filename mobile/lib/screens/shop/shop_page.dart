import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/components/widgets/grid_widget.dart';
import 'package:mobile/data/data.dart';
import 'package:mobile/providers/shop_provider.dart';

const List<String> categories = [
  'All',
  'SmartPhones',
  'Laptops',
  'Desktops',
  'Video Games',
  'Tv and Monitors',
  'Accessories',
  'Others',
];

class ShopHomePage extends ConsumerStatefulWidget {
  const ShopHomePage({super.key});

  @override
  ConsumerState<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends ConsumerState<ShopHomePage> {
  late int selectedFilter;
  late Future<List> allProducts;

  @override
  void initState() {
    super.initState();
    selectedFilter = 0;
    allProducts = ref.read(allShopItems.notifier).getShop();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isMobile = deviceWidth < 500 ? true : false;

    // final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 80,
            collapsedHeight: 70,
            backgroundColor: Colors.grey.shade900,
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  Navigator.of(context).pushNamed('cart');
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: isMobile ? 24 : 30,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepOrangeAccent,
                          ),
                          child: Text(
                            '',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            title: Container(
              padding: const EdgeInsets.only(bottom: 10, top: 25),
              width: deviceWidth < 500 ? deviceWidth * 0.9 : deviceWidth * 0.75,
              child: TextField(
                onTap: () {
                  Navigator.of(context).pushNamed('search');
                },
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  suffixIcon: const Icon(
                    Icons.search,
                  ),
                  hintText: 'Search',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (context, index) => Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: isMobile ? 140 : 170,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: appInitData.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(right: 20),
                      alignment: Alignment.bottomLeft,
                      width: deviceWidth * 0.85,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            appInitData[index].imagepath,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          appInitData[index].desc,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          //
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              alignment: Alignment.centerLeft,
              color: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
              child: Text(
                'SHOP FROM OUR PREMIUMN PRODUCTS',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // list filters
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.grey.shade900,
            toolbarHeight: isMobile ? 60 : 70,
            flexibleSpace: SizedBox(
              height: isMobile ? 60 : 70,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast),
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = index;
                        });
                      },
                      child: Chip(
                        side: BorderSide(
                          color: selectedFilter == index
                              ? Colors.grey.shade800
                              : Colors.grey.shade900,
                        ),
                        backgroundColor: selectedFilter == index
                            ? Colors.grey.shade800
                            : Colors.grey.shade900,
                        labelPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: isMobile ? 0 : 5,
                        ),
                        elevation: 2,
                        label: Text(
                          categories[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Products page
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: allProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(
                      radius: 17,
                      color: Colors.deepOrangeAccent,
                    ),
                  );
                }

                if (snapshot.data == [] || snapshot.data == null) {
                  return const Center(
                    child: Text('An error occured'),
                  );
                }

                return GridWidget(
                  isMobile: isMobile,
                  snapshot: snapshot,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
