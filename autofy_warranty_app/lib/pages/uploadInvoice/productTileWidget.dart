import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductTileWidget extends StatelessWidget {
  Map<String, dynamic>? product;

  ProductTileWidget({@required this.product});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: ListTile(
          onTap: () {
            Get.back(
              result: product,
            );
          },
          title: Text(product?["title"]),
          subtitle: Text("SKU: ${product?["sku"]}"),
          leading: GestureDetector(
            onTap: () {
              print("clicje");

              Get.defaultDialog(
                title: "",
                titleStyle: TextStyle(fontSize: 0),
                content: CachedNetworkImage(
                  imageUrl: product?["image"],
                  placeholder: (context, url) => CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                ),
                barrierDismissible: true,
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 25,
              child: CachedNetworkImage(
                imageUrl: product?["image"],
                placeholder: (context, url) => CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
