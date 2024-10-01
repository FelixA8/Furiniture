import 'dart:async';

import 'package:flutter/material.dart';
import 'package:furiniture/services/product_firebase.dart';
import 'package:furiniture/view_models/product_model.dart';
import 'package:furiniture/widgets/product_card_user.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class UserHomeMenu extends StatefulWidget {
  const UserHomeMenu({super.key});

  @override
  State<UserHomeMenu> createState() => _UserHomeMenuState();
}

class _UserHomeMenuState extends State<UserHomeMenu> {
  final TextEditingController controller = TextEditingController();
  static const _pageSize = 4;
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 0);
  late List<Product> listTop5Product;
  var isLoading = true;
  List<Product> allProducts = [];

  Future<void> _fetchProduct(int pageKey) async {
    try {
      if (isLoading == true) {
        allProducts = await fetchAllProduct();
      }
      var newItems = await getRandomTop5Products(allProducts);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future _handleRefresh() async {
    fetchAllProduct();
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchProduct(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 12),
                  child: SearchInput(
                    hintText: "Search",
                    textController: controller,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 12),
                    child: PagedListView<int, Product>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<Product>(
                        itemBuilder: (context, item, index) =>
                            ProductCardUser(product: item),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchInput extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  const SearchInput(
      {required this.textController, required this.hintText, Key? key})
      : super(key: key);

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  Timer? _debounce;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _debounce?.cancel();
  }

  void _onSearchChanged(String query) {
    // Cancel any previous timers to prevent multiple triggers
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Start a new timer that waits for 1 seconds before showing the list
    _debounce = Timer(const Duration(seconds: 1), () {
      // After the timer ends, proceed to display the list of items
      print("Display items for: $query");
      // Call your method to fetch and display items based on the query
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1)),
      ]),
      child: TextField(
        controller: widget.textController,
        onChanged: (value) {
          _onSearchChanged(value);
        },
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xff4338CA),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}
