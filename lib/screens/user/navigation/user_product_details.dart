import 'package:flutter/material.dart';
import 'package:furiniture/provider_models/cart_models.dart';
import 'package:furiniture/services/person_firebase.dart';
import 'package:furiniture/view_models/product_item.dart';
import 'package:furiniture/view_models/product_model.dart';
import 'package:furiniture/services/format_services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserProductDetails extends StatelessWidget {
  final Product product;
  const UserProductDetails({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop(true);
          },
          icon: const Icon(Icons.chevron_left),
        ),
        actions: const [],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: () async {
          // Add your onPressed code here!
          var result = await addProductToCart(
              productID: product.productId, amount: 1, orderStatus: "waiting");

          if (result) {
            final cartModel = Provider.of<CartModel>(context, listen: false);
            cartModel.addItem(ProductItem(
                productId: product.productId,
                quantity: 1,
                orderStatus: "waiting"));
            showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                title: Text("Nice"),
                content: Text("item already in cart"),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                title: Text("Oops"),
                content: Text("item already in cart"),
              ),
            );
          }
        },
        label: const Text(
          'Add to Cart',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
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
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue),
                    child: Text(
                      product.categoryId,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
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
                ],
              )),

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
                    const SizedBox(
                      width: 10,
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
