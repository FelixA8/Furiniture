import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:furiniture/provider_models/cart_models.dart';
import 'package:furiniture/screens/login_screen.dart';
import 'package:furiniture/screens/register_screen.dart';
import 'package:furiniture/screens/seller/navigation/seller_add_item_screen.dart';
import 'package:furiniture/screens/seller/navigation/seller_layout_navbar.dart';
import 'package:furiniture/screens/seller/navigation/seller_product_detail_screen.dart';
import 'package:furiniture/screens/user/navigation/seller_registration_navigation.dart';
import 'package:furiniture/screens/user/navigation/user_checkout_navigation.dart';
import 'package:furiniture/screens/user/navigation/user_layout_navbar.dart';
import 'package:furiniture/screens/user/navigation/user_product_details.dart';
import 'package:furiniture/screens/user/navigation/user_transaction_history_navigation.dart';
import 'package:furiniture/view_models/product_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(initialLocation: "/", routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/register',
    builder: (context, state) => const RegisterScreen(),
  ),
  GoRoute(
      path: '/user/:uid',
      builder: (context, state) {
        final String uid = state.pathParameters['uid']!;
        return UserLayoutNavBar(state: state, uid: uid);
      },
      routes: [
        
        GoRoute(
          path: "product-details",
          builder: (context, state) {
            final Product product = state.extra as Product;
            return UserProductDetails(
              product: product,
            );
          },
        ),
        GoRoute(
          path: "transaction-history",
          builder: (context, state) {
            return UserTransactionHistoryNavigation();
          },
        ),
        GoRoute(
          path: "checkout",
          builder: (context, state) {
            return const UserCheckoutNavigation();
          },
        ),
        GoRoute(
          path: "seller-registration",
          builder: (context, state) {
            final String uid = state.pathParameters['uid']!;
            return SellerRegistrationNavigation(
              uid: uid,
            );
          },
        )
      ]),
  GoRoute(
      path: '/seller/:uid',
      builder: (context, state) {
        final String uid = state.pathParameters['uid']!;
        return SellerLayoutNavBar(state: state, uid: uid);
      },
      routes: [
        GoRoute(
          path: 'add-item',
          builder: (context, state) {
            final String uid = state.pathParameters['uid']!;
            return SellerAddItemScreen(
              uid: uid,
            );
          },
        ),
        GoRoute(
          path: 'product-details',
          builder: (context, state) {
            final Product product = state.extra as Product;
            return SellerProductDetailScreen(
              product: product,
            );
          },
        ),
      ])
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
