import 'package:flutter/material.dart';
import 'package:furiniture/global/global_data.dart';
import 'package:furiniture/provider_models/cart_models.dart';
import 'package:furiniture/services/format_services.dart';
import 'package:furiniture/services/order_firebase.dart';
import 'package:furiniture/view_models/product_item.dart';
import 'package:furiniture/view_models/product_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserCheckoutNavigation extends StatelessWidget {
  const UserCheckoutNavigation({super.key});
  @override
  Widget build(BuildContext context) {
    late List<ProductItem> cartList;
    return Consumer<CartModel>(
      builder: (context, value, child) {
        cartList = value.cartList;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Checkout"),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await createOrder(
                  orderItems: value.cartList,
                  address: globalUserData.address,
                  totalAmount: value.totalPrice,
                  userId: userID);
              value.removeAllItem();
              GoRouter.of(context).go("/user/$userID");
            },
            icon: const Icon(
              Icons.attach_money_sharp,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
            label: const Text(
              "Confirm Purchase",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 12),
                      child: ListView.builder(
                        itemCount: cartList.length,
                        itemBuilder: (context, index) {
                          Product product = globalListProduct.firstWhere(
                            (product) =>
                                product.productId == cartList[index].productId,
                            orElse: () => Product(
                              productId: "",
                              name: "",
                              description: "",
                              price: 0,
                              categoryId: "",
                              shopId: "",
                              stock: 0,
                              image: "",
                              augmentedObject: "",
                              createdAt: DateTime(2024),
                              updatedAt: DateTime(2024),
                            ),
                          );
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: InkWell(
                              onTap: () {
                                GoRouter.of(context).push(
                                    "/user/$userID/product-details",
                                    extra: product);
                              },
                              child: Card(
                                elevation: 5,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image Section
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Image.network(
                                        product.image,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Product Info Section
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Product Name
                                            Text(
                                              product.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              maxLines: 1,
                                            ),
                                            // Product Price
                                            Text(
                                              formatToRupiah(product.price *
                                                  cartList[index].quantity),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Quantity Section
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12, bottom: 12, right: 12),
                                          child: Row(
                                            children: [
                                              const Text("Quantity: "),
                                              Text(cartList[index]
                                                  .quantity
                                                  .toString()), // Display the quantity
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Divider(),
                  SizedBox(
                    height: 130,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Price: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            ),
                            Text(
                              formatToRupiah(value.totalPrice),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Address: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            ),
                            Text(
                              globalUserData.address,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
