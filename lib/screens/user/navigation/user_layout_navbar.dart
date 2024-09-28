import 'package:flutter/material.dart';
import 'package:furiniture/global/global_data.dart';
import 'package:furiniture/provider_models/cart_models.dart';
import 'package:furiniture/screens/user/menu/user_account_menu.dart';
import 'package:furiniture/screens/user/menu/user_cart_menu.dart';
import 'package:furiniture/screens/user/menu/user_home_menu.dart';
import 'package:furiniture/services/person_firebase.dart';
import 'package:furiniture/services/product_firebase.dart';
import 'package:furiniture/view_models/person_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserLayoutNavBar extends StatefulWidget {
  final GoRouterState state;
  final String uid;
  const UserLayoutNavBar({super.key, required this.state, required this.uid});

  @override
  State<UserLayoutNavBar> createState() => _UserLayoutNavBarState();
}

class _UserLayoutNavBarState extends State<UserLayoutNavBar> {
  late String currentPath;
  late String uid = widget.uid;
  int _currentIndex = 0;
  bool isLoading = true;
  late Person userData;
  String errorMessage = '';
  late List<Widget> _children;

  Future<void> _fetchUserData() async {
    try {
      // Fetch data and store it in the userData variable
      Person data = await getUserDataFromId(uid);
      
      final cartModel = Provider.of<CartModel>(context, listen: false);
      data.cart.forEach(
        (element) => cartModel.addItem(element),
      );
      userID = uid;
      setState(() {
        userData = data;
        _children = [
          const UserHomeMenu(),
          const UserCartMenu(),
          UserAccountMenu(
            userData: userData,
          ),
        ];
        isLoading = false;
      });
    } catch (e) {
      errorMessage = 'Failed to load user data: $e';
      print(e);
      setState(() {
        isLoading = true;
      });
    }
  }

  Future<void> _fetchAllProducts() async {
    try {
      var allProducts = await fetchAllProduct();
      globalListProduct = allProducts;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // Set the current path on initialization
    currentPath = widget.state.fullPath!;
    _fetchUserData();
    _fetchAllProducts();
  }

  void onBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Account'),
        ],
      ),
    );
  }
}
