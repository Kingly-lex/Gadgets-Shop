import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/extensions.dart';
import 'package:mobile/interceptors/dio.dart';
import 'package:mobile/providers/cart_provider.dart';
import 'package:mobile/screens/checkout/checkout_page.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'http://10.0.2.2:8000',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

class Cart extends ConsumerStatefulWidget {
  const Cart({super.key});

  @override
  ConsumerState<Cart> createState() => _CartState();
}

// state
class _CartState extends ConsumerState<Cart> {
  late Future<List?> cart;
  double cartTotal = 0;
  double cartCount = 0;

  @override
  void initState() {
    super.initState();
    cart = ref.read(userCart.notifier).getCart();
  }

  void subTotal(List<dynamic> data) async {
    List items = [];
    List count = [];
    for (var element in data) {
      items.add(
        double.parse(element['product']['price']) * element['quantity'],
      );

      count.add(
        element['quantity'],
      );
    }

    double total = items.fold<double>(0, (a, b) => a + b);
    double countNum = count.fold<double>(0, (c, d) => c + d);

    cartTotal = total;
    cartCount = countNum;
  }

  void clearCart() async {
    dio.interceptors.add(DioInterceptor());
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        titlePadding: const EdgeInsets.all(18).copyWith(bottom: 0),
        contentPadding: const EdgeInsets.all(18),
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: Colors.grey.shade200,
        surfaceTintColor: Colors.transparent,
        title: const Text('Clear cart'),
        content: const Text('Do you really want to clear your cart?'),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    elevation: 20,
                    backgroundColor: Colors.white,
                    shape: BeveledRectangleBorder(
                        side: BorderSide(
                            color: Colors.deepOrangeAccent.shade100)),
                  ),
                  icon: Icon(
                    Icons.cancel_rounded,
                    color: Colors.deepOrangeAccent.shade100,
                  ),
                  label: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    shape: const BeveledRectangleBorder(),
                    shadowColor: Colors.black,
                    elevation: 20,
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final bool clear =
                        await ref.read(userCart.notifier).clearCart();
                    if (clear) {
                      // do something
                      // setState(() {});
                    } else {
                      // do something
                    }
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Clear Cart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void removeItemFromCart(Map product, int index) async {
    dio.interceptors.add(DioInterceptor());
    final data = {'product_id': product['product']['id']};

    try {
      final response = await dio.post('/api/cart/remove/', data: data);
      if (response.statusCode == 200) {
        ref.read(userCart.notifier).removeFromCart(product);
      }
    } on DioException catch (e) {
      e.error.toString();
    }
  }

  void increaseCart(String id) async {
    dio.interceptors.add(DioInterceptor());
    final data = {'product_id': id};

    try {
      final response = await dio.post('/api/cart/increase/', data: data);
      if (response.statusCode == 200) {
        // do something
        ref.read(userCart.notifier).increaseQuantity(id);
      }
    } on DioException catch (e) {
      e.error.toString();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something Went Wrong')));
      }
    }
  }

  void decreaseCart(String id) async {
    dio.interceptors.add(DioInterceptor());
    final data = {'product_id': id};

    try {
      final response = await dio.post('/api/cart/decrease/', data: data);
      if (response.statusCode == 200) {
        // do something
        ref.read(userCart.notifier).decreaseQuantity(id);
      }
    } on DioException catch (e) {
      e.error.toString();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something Went Wrong')));
      }
    }
  }

  void checkOut() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const CheckOutPage()));
  }

  @override
  Widget build(BuildContext context) {
    final cartItem = ref.watch(userCart);
    subTotal(cartItem);
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isMobile = deviceWidth < 500 ? true : false;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Colors.grey.shade900,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey.shade100,
      body: FutureBuilder(
        future: cart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CupertinoActivityIndicator(
              radius: 17,
              color: Colors.deepOrangeAccent,
            ));
          }

          if (snapshot.hasError) {
            return const Text("An error occurred");
          }

          return cartItem.isEmpty
              ? emptyCart(isMobile, deviceWidth)
              : SafeArea(
                  child: Container(
                    color: Colors.grey.shade200,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: const Text('CART SUMMARY'),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          width: double.infinity,
                          color: Colors.grey.shade100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('SUB TOTAL'),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Delivery fees not included',
                                    style: TextStyle(color: Colors.grey[600]),
                                  )
                                ],
                              ),
                              Text(
                                cartTotal.addComma(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Cart (${cartCount.toInt()})'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: FadeIn(
                            duration: const Duration(milliseconds: 900),
                            child: ListView.builder(
                              itemCount: cartItem.length,
                              itemBuilder: (context, index) {
                                final Map product = cartItem[index];
                                final quantity = product['quantity'];
                                final stock =
                                    product['product']['stock_available'];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Card(
                                    key: ValueKey(product['product']['id']),
                                    color: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    shape: const BeveledRectangleBorder(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Image.network(
                                                  product['product']
                                                      ['display_image'],
                                                  fit: BoxFit.contain,
                                                  height: 100,
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product['product']
                                                          ['title'],
                                                      maxLines: 1,
                                                    ),
                                                    Text(
                                                      double.parse(
                                                        product['product']
                                                            ['price'],
                                                      ).addComma(),
                                                    ),
                                                    Text(
                                                      'Units left: $stock',
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  showRemoveDialog(
                                                      context, product, index);
                                                },
                                                child: const Text('Remove'),
                                              ),
                                              Row(
                                                children: [
                                                  // decrease cart
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      disabledBackgroundColor:
                                                          Colors
                                                              .deepOrangeAccent
                                                              .shade100,
                                                      backgroundColor: Colors
                                                          .deepOrangeAccent,
                                                      shape: const StarBorder
                                                          .polygon(
                                                          sides: 4,
                                                          rotation: 45),
                                                    ),
                                                    onPressed: quantity > 1
                                                        ? () {
                                                            decreaseCart(product[
                                                                    'product']
                                                                ['id']);
                                                          }
                                                        : null,
                                                    child: const Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    quantity.toString(),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  // increase cart
                                                  TextButton(
                                                    onPressed: quantity < stock
                                                        ? () {
                                                            increaseCart(product[
                                                                    'product']
                                                                ['id']);
                                                          }
                                                        : null,
                                                    style: TextButton.styleFrom(
                                                      disabledBackgroundColor:
                                                          Colors
                                                              .deepOrangeAccent
                                                              .shade100,
                                                      backgroundColor: Colors
                                                          .deepOrangeAccent,
                                                      shape: const StarBorder
                                                          .polygon(
                                                        sides: 4,
                                                        rotation: 45,
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
      persistentFooterButtons: cartItem.isEmpty
          ? null
          : [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      style: IconButton.styleFrom(
                          elevation: 10,
                          shadowColor: Colors.black,
                          alignment: Alignment.center,
                          side: BorderSide(
                              color: Colors.deepOrangeAccent.shade100),
                          backgroundColor: Colors.white,
                          shape: const BeveledRectangleBorder(),
                          padding: const EdgeInsets.all(10)),
                      icon: const Icon(Icons.remove),
                      onPressed: clearCart,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 8,
                    child: TextButton(
                      onPressed: checkOut,
                      style: TextButton.styleFrom(
                        elevation: 15,
                        shadowColor: Colors.blueGrey.shade100,
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 15),
                        backgroundColor: Colors.orangeAccent.shade700,
                        shape: const BeveledRectangleBorder(),
                      ),
                      child: Text(
                        'Checkout (${cartTotal.addComma()})',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
    );
  }

  Widget emptyCart(bool isMobile, double deviceWidth) {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.remove_shopping_cart,
              size: 50,
            ),
            const SizedBox(height: 20),
            const Text('Cart is Empty!'),
            const SizedBox(height: 20),
            const Text('Browse our categories and discover our best deals!'),
            const SizedBox(height: 20),
            Container(
              width: isMobile ? deviceWidth * 0.9 : deviceWidth * 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('main');
                },
                style: ElevatedButton.styleFrom(
                    shape: const BeveledRectangleBorder(),
                    backgroundColor: Colors.deepOrangeAccent),
                child: const Text(
                  'START SHOPPING',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showRemoveDialog(BuildContext context, product, int index) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        titlePadding: const EdgeInsets.all(18).copyWith(bottom: 0),
        contentPadding: const EdgeInsets.all(18),
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: Colors.grey.shade200,
        surfaceTintColor: Colors.transparent,
        title: const Text('Remove from cart'),
        content: const Text(
            'Do you really want to remove this item from your cart?'),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    elevation: 20,
                    backgroundColor: Colors.white,
                    shape: BeveledRectangleBorder(
                        side: BorderSide(
                            color: Colors.deepOrangeAccent.shade100)),
                  ),
                  icon: Icon(
                    Icons.cancel_rounded,
                    color: Colors.deepOrangeAccent.shade100,
                  ),
                  label: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    shape: const BeveledRectangleBorder(),
                    shadowColor: Colors.black,
                    elevation: 20,
                  ),
                  onPressed: () {
                    removeItemFromCart(product, index);

                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Remove item',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
