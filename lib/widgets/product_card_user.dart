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
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: width,
          child: const LikeListTile(
            title: "Andre Hirata",
            likes: "130",
            subtitle: "103 Reviews",
            color: Colors.white,
          ),
        ),
        const Divider(
          height: 30,
        ),
      ],
    );
  }
}

class LikeListTile extends StatelessWidget {
  const LikeListTile(
      {Key? key,
      required this.title,
      required this.likes,
      required this.subtitle,
      this.color = Colors.grey})
      : super(key: key);
  final String title;
  final String likes;
  final String subtitle;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Container(
        width: 50,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                        "https://profilemagazine.com/wp-content/uploads/2020/04/Ajmere-Dale-Square-thumbnail.jpg"))),
          ),
        ),
      ),
      title: Text(title),
      subtitle: Row(
        children: [
          Icon(Icons.favorite, color: Colors.orange, size: 15),
          SizedBox(width: 2),
          Text(likes),
          Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(width: 4, height: 4),
              )),
          Text(subtitle)
        ],
      ),
      trailing: LikeButton(onPressed: () {}, color: Colors.orange),
    );
  }
}

class LikeButton extends StatefulWidget {
  const LikeButton(
      {Key? key, required this.onPressed, this.color = Colors.black12})
      : super(key: key);
  final Function onPressed;
  final Color color;
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: IconButton(
      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
          color: widget.color),
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });
        widget.onPressed();
      },
    ));
  }
}
