import 'package:flutter/material.dart';
import 'package:furiniture/services/person_firebase.dart';
import 'package:furiniture/view_models/person_model.dart';
import 'package:go_router/go_router.dart';

class UserAccountMenu extends StatefulWidget {
  final Person userData;
  const UserAccountMenu({super.key, required this.userData});

  @override
  State<UserAccountMenu> createState() => _UserAccountMenuState();
}

class _UserAccountMenuState extends State<UserAccountMenu> {
  late Person? userData = widget.userData;

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
                          child: Icon(
                            Icons.person_2,
                            color: Colors.grey.shade200,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 12)),
                        Text(
                          userData!.name,
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
                        userData!.email,
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
                        userData!.phone,
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
                        userData!.address,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    ),
                    const Divider(
                      thickness: 0.75,
                    ),
                    InkWell(
                      onTap: () => logout(context),
                      child: const Row(
                        children: [
                          Text(
                            "Log Out",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.red),
                          ),
                          Spacer(),
                          Icon(
                            Icons.logout,
                            color: Colors.red,
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
                "Transaction",
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
                            "Transaction Status",
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
                            "See Transaction Histoy",
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
                "Seller",
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
                        if (userData?.sellerId == "") {
                          context.push(
                              "/user/${userData?.uid}/seller-registration");
                        } else {
                          context.go("/seller/${userData?.sellerId}");
                        }
                      },
                      child: const Row(
                        children: [
                          Text(
                            "Be a Seller",
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
