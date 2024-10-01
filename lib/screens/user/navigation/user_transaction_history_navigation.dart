import 'package:flutter/material.dart';
import 'package:furiniture/global/global_data.dart';
import 'package:furiniture/services/format_services.dart';
import 'package:furiniture/services/order_firebase.dart';
import 'package:furiniture/view_models/order_model.dart';
import 'package:furiniture/view_models/product_model.dart';

class UserTransactionHistoryNavigation extends StatefulWidget {
  const UserTransactionHistoryNavigation({super.key});

  @override
  State<UserTransactionHistoryNavigation> createState() =>
      _UserTransactionHistoryNavigationState();
}

class _UserTransactionHistoryNavigationState
    extends State<UserTransactionHistoryNavigation> {
  var isLoading = true;
  late List<MyOrder> listOrder;

  void _fetchOrder() async {
    var response = await getOrderFromUser(userID: userID);
    if (response.isNotEmpty) {
      setState(() {
        listOrder = response;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
      ),
      body: isLoading
          ? Container()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: isLoading
                    ? Container()
                    : ListView.builder(
                        itemCount: listOrder.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${listOrder[index].orderDate.day}/${listOrder[index].orderDate.month}/${listOrder[index].orderDate.year} ${listOrder[index].orderDate.hour}:${listOrder[index].orderDate.minute} GMT${listOrder[index].orderDate.timeZoneName}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                  const Divider(
                                    thickness: 0.4,
                                  ),
                                  Column(
                                    children: listOrder[index]
                                        .productItems
                                        .map((item) {
                                      var status = "";
                                      var color = Colors.yellow;
                                      if (item.orderStatus == "waiting") {
                                        status = "waiting";
                                      } else if (item.orderStatus ==
                                          "delivering") {
                                        status = "product on delivery";
                                        color = Colors.orange;
                                      } else if (item.orderStatus ==
                                          "arrived") {
                                        color = Colors.blue;
                                        status = "product has arrived";
                                      }

                                      Product product =
                                          globalListProduct.firstWhere(
                                        (product) =>
                                            product.productId == item.productId,
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Example product info
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                product.image,
                                                width: 75,
                                                height: 75,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product
                                                      .name, // Assuming product has a 'name' field
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  "${item.quantity} items", // Assuming product has a 'name' field
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  formatToRupiah(product
                                                      .price), // Assuming product has a 'name' field
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: color),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 2),
                                                child: Text(
                                                  "${status}", // Assuming product has a 'price' field
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
    );
  }
}
