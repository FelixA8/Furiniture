import 'package:flutter/material.dart';
import 'package:furiniture/global/global_data.dart';
import 'package:furiniture/screens/seller/menu/seller_account_menu.dart';
import 'package:furiniture/screens/seller/menu/seller_home_menu.dart';
import 'package:furiniture/services/product_firebase.dart';
import 'package:furiniture/services/seller_firebase.dart';
import 'package:furiniture/view_models/product_model.dart';
import 'package:furiniture/view_models/seller_model.dart';
import 'package:go_router/go_router.dart';

class SellerLayoutNavBar extends StatefulWidget {
  final GoRouterState state;
  final String uid;
  const SellerLayoutNavBar({super.key, required this.state, required this.uid});

  @override
  State<SellerLayoutNavBar> createState() => _SellerLayoutNavBarState();
}

class _SellerLayoutNavBarState extends State<SellerLayoutNavBar> {
  bool isLoading = true;
  Seller? sellerData;
  List<Product>? listProduct;
  String errorMessage = '';
  late String uid = widget.uid;
  late String currentPath;
  int _currentIndex = 0;
  late List<Widget> _children;

  Future<void> _fetchSellerData() async {
    try {
      // Fetch data and store it in the userData variable
      Seller data = await getSellerDataFromId(uid);
      List<Product>? products = await getSellerProduct(sellerID: uid);
      setState(() {
        sellerData = data;
        listProduct = products;
        _children = [
          SellerHomeMenu(
            sellerData: sellerData!,
            listProduct: listProduct!,
          ),
          SellerAccountMenu(
            sellerData: sellerData!,
          ),
        ];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load user data: $e';
        isLoading = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Set the current path on initialization
    currentPath = widget.state.fullPath!;
    _fetchSellerData();
  }

  void onBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    sellerID = uid;
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Container()
            : IndexedStack(
                index: _currentIndex, // Display the current page
                children: _children, // Keep all children alive
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onBarTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
              icon: new Icon(Icons.store), label: 'Account'),
        ],
      ),
    );
  }
}
