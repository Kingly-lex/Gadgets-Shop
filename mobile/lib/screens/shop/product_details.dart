import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  final Map item;

  const ProductDetail({
    super.key,
    required this.item,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    final product = widget.item;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Colors.grey.shade900,
        actions: [
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                Navigator.of(context).pushNamed('cart');
              },
              icon: const Icon(
                Icons.shopping_cart_sharp,
                color: Colors.white,
              ))
        ],
      ),
      body: Hero(
          tag: product['id'], child: Image.network(product['display_image'])),
    );
  }
}
