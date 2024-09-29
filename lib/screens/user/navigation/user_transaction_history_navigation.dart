import 'package:flutter/material.dart';
import 'package:furiniture/global/global_data.dart';
import 'package:furiniture/services/order_firebase.dart';

class UserTransactionHistoryNavigation extends StatefulWidget {
  const UserTransactionHistoryNavigation({super.key});

  @override
  State<UserTransactionHistoryNavigation> createState() =>
      _UserTransactionHistoryNavigationState();
}

class _UserTransactionHistoryNavigationState
    extends State<UserTransactionHistoryNavigation> {
  var isLoading = true;

  void _fetchOrder() async {
    var response = await getOrderFromUser(userID: userID);
    print("res: $response");
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
                child: Container(),
              ),
            ),
    );
  }
}
