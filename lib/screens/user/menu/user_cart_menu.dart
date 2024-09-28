import 'package:flutter/material.dart';
import 'package:furiniture/global/global_data.dart';
import 'package:furiniture/provider_models/cart_models.dart';
import 'package:furiniture/services/format_services.dart';
import 'package:furiniture/services/person_firebase.dart';
import 'package:furiniture/view_models/product_item.dart';
import 'package:furiniture/view_models/product_model.dart';
import 'package:provider/provider.dart';

class UserCartMenu extends StatefulWidget {
  const UserCartMenu({super.key});

  @override
  State<UserCartMenu> createState() => _UserCartMenuState();
}

class _UserCartMenuState extends State<UserCartMenu> {
  late List<ProductItem> cartList;
  var isLoading = true;

  void _removeItem(int index) {
    // Remove the item from the data list
    setState(() {
      cartList.removeAt(index);
    });
  }

  void _addItem(int index) {
    setState(() {
      // Create a new ProductItem with the updated quantity
      ProductItem updatedItem = cartList[index].copyWith(
        quantity: cartList[index].quantity + 1,
      );

      // Replace the old item with the new one in the list
      cartList[index] = updatedItem;
    });
  }

  void _subItem(int index) {
    setState(() {
      if (cartList[index].quantity > 1) {
        // Create a new ProductItem with the updated quantity
        ProductItem updatedItem = cartList[index].copyWith(
          quantity: cartList[index].quantity - 1,
        );

        // Replace the old item with the new one in the list
        cartList[index] = updatedItem;
      }
    });
  }

  Widget buildItem(ProductItem item, int index) {
    Product product = globalListProduct.firstWhere(
      (product) => product.productId == item.productId,
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
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      formatToRupiah(product.price * cartList[index].quantity),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _subItem(cartList.indexOf(item)); // Decrease quantity
                          changeCartProductItemValue(
                              operation: "sub",
                              prevAmount: item.quantity,
                              productID: item.productId);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text('-'),
                        ),
                      ),
                      Text(item.quantity.toString()), // Display the quantity
                      InkWell(
                        onTap: () {
                          _addItem(cartList.indexOf(item));
                          changeCartProductItemValue(
                              operation: "add",
                              prevAmount: item.quantity,
                              productID: item.productId);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text('+'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () {
                      _removeItem(cartList.indexOf(item));
                    },
                    child: const Icon(Icons.delete),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String getTotalPrice() {
    int total = 0;
    cartList.map((cart) {
      globalListProduct.map((product) {
        if (product.productId == cart.productId) {
          total = product.price * cart.quantity;
        }
      });
    });
    return total.toString();
  }

  Future<void> _fetchUserData() async {
    var userData = await getUserDataFromId(userID);
    globalUserData = userData;
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    cartList = globalUserData.cart;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, cartModel, child) {
        cartList = cartModel.cartList;
        return Scaffold(
          floatingActionButton: cartList.isEmpty
              ? null
              : FloatingActionButton.extended(
                  backgroundColor: Colors.blue,
                  onPressed: () async {
                    // Add your onPressed code here!
                  },
                  label: Text(
                    formatToRupiah(cartModel.totalPrice),
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 24, bottom: 12),
                    child: Text("My Cart"),
                  ),
                  Expanded(
                    child: ListView.builder(
                      // key: _listKey,
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        return buildItem(cartList[index], index);
                      },
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
