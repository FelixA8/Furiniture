import 'package:flutter/material.dart';
import 'package:furiniture/global/global_data.dart';
import 'package:furiniture/services/format_services.dart';
import 'package:furiniture/view_models/product_model.dart';
import 'package:furiniture/view_models/seller_model.dart';
import 'package:go_router/go_router.dart';

class SellerHomeMenu extends StatefulWidget {
  final Seller sellerData;
  final List<Product> listProduct;
  const SellerHomeMenu(
      {super.key, required this.sellerData, required this.listProduct});

  @override
  State<SellerHomeMenu> createState() => _SellerHomeMenuState();
}

class _SellerHomeMenuState extends State<SellerHomeMenu> {
  late List<Product> listProduct = widget.listProduct;
  final SearchController controller = SearchController();
  late Seller sellerData = widget.sellerData;

  Future<void> _handleRefresh() async {
    // Fetch new data and update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 12),
                child: SearchAnchor(
                    searchController: controller,
                    builder:
                        (BuildContext context, SearchController controller) {
                      return InkWell(
                        onTap: () {
                          controller.openView();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.search),
                            Padding(padding: EdgeInsets.only(right: 12)),
                            Text(
                              'Search Item',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      );
                    },
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                      return List<ListTile>.generate(5, (int index) {
                        final String item = 'item $index';
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            setState(() {
                              controller.closeView(item);
                            });
                          },
                        );
                      });
                    }),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        GoRouter.of(context)
                            .push("/seller/${sellerData.sellerId}/add-item");
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add Item")),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 24, bottom: 12),
                child: Text(
                  'Your Products',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 12),
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: ListView.builder(
                      itemCount: listProduct.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          GoRouter.of(context).push(
                              '/seller/$sellerID/product-details',
                              extra: listProduct[index]);
                        },
                        child: Card(
                          elevation: 2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                listProduct[index].image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 12),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: Text(
                                        listProduct[index].name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    Text(
                                      formatToRupiah(listProduct[index].price),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text:
                                            listProduct[index].stock.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                        children: const [
                                          TextSpan(
                                            text: ' stocks left.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
