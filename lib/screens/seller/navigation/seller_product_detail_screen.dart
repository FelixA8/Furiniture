import 'package:flutter/material.dart';
import 'package:furiniture/services/format_services.dart';
import 'package:furiniture/view_models/product_model.dart';

class SellerProductDetailScreen extends StatelessWidget {
  final Product product;
  const SellerProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: const [],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: const Text('Customize Product'),
        icon: const Icon(Icons.edit),
      ),
      body: ListView(
        children: [
          // Product image
          Image.network(
            product.image,
            height: MediaQuery.of(context).size.height / 1.8,
            fit: BoxFit.fill,
          ),

          // Product title
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Text(
              product.name,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),

          // Product description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(product.description),
          ),

          // Product category
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.blue),
              child: Text(
                product.categoryId,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),

          // Product price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              formatToRupiah(product.price),
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
          ),
          //Augmented Feature Put Here!
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3),
                        color: Colors.blue.shade500,
                        child: RichText(
                          text: TextSpan(
                            text: product.stock.toString(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                            children: const [
                              TextSpan(
                                text: ' stocks left.',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3),
                        color: Colors.blue.shade500,
                        child: RichText(
                          text: const TextSpan(
                            text: "0",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                            children: [
                              TextSpan(
                                text: ' sold.',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3),
                        color: Colors.blue.shade500,
                        child: RichText(
                          text: TextSpan(
                            text: "created at:",
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                            children: [
                              TextSpan(
                                text:
                                    ' ${product.createdAt.day}/${product.createdAt.month}/${product.createdAt.year}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3),
                        color: Colors.blue.shade500,
                        child: RichText(
                          text: TextSpan(
                            text: "updated at:",
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                            children: [
                              TextSpan(
                                text:
                                    ' ${product.updatedAt.day}/${product.updatedAt.month}/${product.updatedAt.year}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}
