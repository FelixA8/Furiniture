import 'package:flutter/material.dart';
import 'package:furiniture/global/global_data.dart';
import 'package:furiniture/view_models/seller_model.dart';
import 'package:go_router/go_router.dart';

class SellerAccountMenu extends StatefulWidget {
  final Seller sellerData;
  const SellerAccountMenu({super.key, required this.sellerData});

  @override
  State<SellerAccountMenu> createState() => _SellerAccountMenuState();
}

class _SellerAccountMenuState extends State<SellerAccountMenu> {
  late Seller? sellerData = widget.sellerData;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 24, bottom: 12),
              child: Text(
                "Profile",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade400,
                          backgroundImage: NetworkImage(
                            sellerData!.logoUrl == ""
                                ? 'https://via.assets.so/img.jpg?w=200&h=200&tc=white&bg=#cecece'
                                : sellerData!.logoUrl,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 12)),
                        Text(
                          sellerData!.storeName,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Edit",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 0.75,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        sellerData!.email,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    ),
                    const Divider(
                      thickness: 0.75,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        sellerData!.phoneNumber,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    ),
                    const Divider(
                      thickness: 0.75,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        sellerData!.address,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    ),
                    const Divider(
                      thickness: 0.75,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 24, bottom: 12),
              child: Text(
                "Order and Sales",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text(
                            "View Ongoing Orders",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                          Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.75,
                    ),
                    InkWell(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text(
                            "See Sales History",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                          Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 24, bottom: 12),
              child: Text(
                "User",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).go("/user/$userID");
                      },
                      child: const Row(
                        children: [
                          Text(
                            "Be a User",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                          Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
