import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/extensions.dart';
import 'package:mobile/interceptors/dio.dart';
import 'package:mobile/screens/shop/product_details.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GridWidget extends StatefulWidget {
  const GridWidget({
    super.key,
    required this.isMobile,
    required this.snapshot,
  });

  final bool isMobile;
  final AsyncSnapshot snapshot;

  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  void addToCart(Map product) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8000',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(DioInterceptor());

    try {
      final Response response =
          await dio.post('/api/cart/add/', data: {'product_id': product['id']});

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              dismissDirection: DismissDirection.horizontal,
              showCloseIcon: true,
              backgroundColor: Colors.grey.shade800,
              content: const Text(
                'Added product to Cart',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'An error occurred, try again later',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }
    } on DioException catch (e) {
      e.message;
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'An error occurred, try again later',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      itemCount: widget.snapshot.data!.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        childAspectRatio: widget.isMobile ? 1 / 1.6 : 1 / 2,
        maxCrossAxisExtent: 250,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 300,
      ),
      itemBuilder: (context, index) {
        final Map product = widget.snapshot.data![index];
        final price = double.parse(product['price']);
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductDetail(item: product),
              ),
            );
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Hero(
                    tag: product['id'],
                    child: Image.network(
                      product['display_image'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          product['title'],
                          maxLines: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              price.addComma(),
                            ),
                            IconButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_outline,
                                color: Colors.deepOrangeAccent,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              displayRating(product['average_rating']),
                              Text('( ${product['rating_count']} )'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              onPressed: () {
                                addToCart(product);
                              },
                              label: const Text(
                                'Add to Cart',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor:
                                    Colors.deepOrangeAccent.shade200,
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              icon: const Icon(
                                Icons.add_shopping_cart_sharp,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget displayRating(double? rating) {
    if (rating == null) {
      return const Text('No ratings yet ');
    }
    return RatingBarIndicator(
      itemCount: 5,
      itemSize: 20,
      rating: rating,
      unratedColor: Colors.grey.shade300,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.deepOrangeAccent.shade100,
      ),
    );
  }
}
