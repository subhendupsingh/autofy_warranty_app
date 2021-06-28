import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductTileWidget extends StatelessWidget {
  // VoidCallback? callback;
  Map<String, dynamic>? product;

  ProductTileWidget({@required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: ListTile(
          onTap: () {
            Get.defaultDialog(
              title: "",
              titleStyle: TextStyle(fontSize: 0),
              content: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: product?["image"],
                    placeholder: (context, url) => CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                  ),
                  emptyVerticalBox(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("SKU: ${product!['sku']}"),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8),
                      child: Text(
                        "Note: Please match SKU code with the SKU code mentioned on MRP sticker on the box of the product",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  emptyVerticalBox(),
                  FlatButton(
                    onPressed: () {
                      Get.back();
                      Get.back(result: product);
                    },
                    child: Text(
                      "Select this product",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: AppColors.primaryColor,
                  )
                ],
              ),
              barrierDismissible: true,
            );
          },
          title: Text(product?["title"]),
          subtitle: Text("SKU: ${product?["sku"]}"),
          leading: CircleAvatar(
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
              )),
        ),
      ),
    );
  }
}

// IconButton(
//               icon: Icon(
//                 Icons.zoom_out_map_outlined,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 Get.defaultDialog(
//                   title: "",
//                   titleStyle: TextStyle(fontSize: 0),
//                   content: CachedNetworkImage(
//                     imageUrl: product?["image"],
//                     placeholder: (context, url) =>
//                         CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation(Colors.white),
//                     ),
//                     errorWidget: (context, url, error) => Icon(
//                       Icons.error_outline,
//                       color: Colors.red,
//                     ),
//                   ),
//                   barrierDismissible: true,
//                 );
//               })
