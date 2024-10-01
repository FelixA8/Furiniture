import 'package:flutter/material.dart';
import 'package:furiniture/provider_models/cart_models.dart';
import 'package:furiniture/provider_models/seller_models.dart';
import 'package:furiniture/services/person_firebase.dart';
import 'package:furiniture/services/seller_firebase.dart';
import 'package:furiniture/view_models/product_item.dart';
import 'package:furiniture/view_models/product_model.dart';
import 'package:furiniture/services/format_services.dart';
import 'package:furiniture/view_models/seller_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserProductDetails extends StatefulWidget {
  final Product product;
  const UserProductDetails({super.key, required this.product});

  @override
  State<UserProductDetails> createState() => _UserProductDetailsState();
}

class _UserProductDetailsState extends State<UserProductDetails> {
  late Seller seller;
  var isLoading = true;

  Future<void> _fetchSeller() async {
    var sellerModel = Provider.of<SellerModel>(context, listen: false);
    List<Seller> isSellerExist = sellerModel.sellerList.map((item) {
      if (item.sellerId == widget.product.shopId) {
        return item;
      }
      return item;
    }).toList();
    if (isSellerExist.isEmpty) {
      Seller response = await getSellerDataFromId(widget.product.shopId);
      sellerModel.addSeller(response);
      setState(() {
        seller = response;
        isLoading = false;
      });
    } else {
      setState(() {
        seller = isSellerExist[0];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSeller();
  }

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
      floatingActionButton: isLoading
          ? Container()
          : widget.product.stock == 0
              ? Container()
              : FloatingActionButton.extended(
                  backgroundColor: Colors.blue,
                  onPressed: () async {
                    // Add your onPressed code here!
                    var result = await addProductToCart(
                        productID: widget.product.productId,
                        amount: 1,
                        orderStatus: "waiting");

                    if (result) {
                      final cartModel =
                          Provider.of<CartModel>(context, listen: false);
                      cartModel.addItem(ProductItem(
                          productId: widget.product.productId,
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                // Product image
                Image.network(
                  widget.product.image,
                  height: MediaQuery.of(context).size.height / 1.8,
                  fit: BoxFit.fill,
                ),

                // Product title
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 12),
                  child: Text(
                    widget.product.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ),
                // Product price
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
                  child: Text(
                    formatToRupiah(widget.product.price),
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w500),
                  ),
                ),
                // Product description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(widget.product.description),
                ),
                // Product category
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue),
                        child: Text(
                          widget.product.categoryId,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3),
                        child: RichText(
                          text: TextSpan(
                            text: widget.product.stock.toString(),
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
                  ),
                ),
                LikeListTile(
                  title: seller.storeName,
                  logoUrl: seller.logoUrl,
                ),
                //Augmented Feature Put Here!
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
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

class LikeListTile extends StatelessWidget {
  const LikeListTile({
    Key? key,
    required this.title,
    required this.logoUrl,
  }) : super(key: key);
  final String title;
  final String logoUrl;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      leading: SizedBox(
        width: 50,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(logoUrl),
              ),
            ),
          ),
        ),
      ),
      title: Text(title),
    );
  }
}
