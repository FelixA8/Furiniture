import 'package:flutter/material.dart';
import 'package:furiniture/global/global_data.dart';
import 'package:furiniture/services/format_services.dart';
import 'package:furiniture/view_models/product_model.dart';
import 'package:go_router/go_router.dart';

class ProductCardUser extends StatelessWidget {
  const ProductCardUser({
    super.key,
    required this.product,
    this.width = 400,
  });

  final Product product;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            await GoRouter.of(context)
                .push("/user/$userID/product-details", extra: product);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                  // color: Colors.red
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  product.image,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                product.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                formatToRupiah(product.price),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        const Divider(
          height: 30,
        ),
      ],
    );
  }
}
