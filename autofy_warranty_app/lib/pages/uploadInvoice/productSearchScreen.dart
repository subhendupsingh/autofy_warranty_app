import 'package:autofy_warranty_app/services/apiService.dart';
import 'package:autofy_warranty_app/pages/uploadInvoice/productTileWidget.dart';
import 'package:autofy_warranty_app/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSearchScreen extends StatefulWidget {
  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> allProducts = [];
  List filteredProducts = [];
  Map<String, dynamic>? selectedBank;
  bool isSearching = false;

  @override
  void initState() {
    fetchProductsFromServer();
    super.initState();
  }

  fetchProductsFromServer() async {
    ApiService apiController = Get.find<ApiService>();
    allProducts = await apiController.fetchProducts() ?? [];
    if (mounted) setState(() {});
    print(allProducts);
  }

  buildSearchBar() {
    return Card(
      child: TextField(
        controller: searchController,
        onChanged: (query) {
          isSearching = true;
          filteredProducts = [];
          if (query == "") {
            isSearching = false;
            setState(() {});
            return;
          }
          allProducts.forEach((element) {
            if (element["title"].toLowerCase().contains(query.toLowerCase()))
              filteredProducts.add(element);
          });
          setState(() {});
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: "Search For Products",
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Select Product"),
          backgroundColor: Colors.red,
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSearchBar(),
                emptyVerticalBox(),
                Text(
                  isSearching
                      ? "Results for \"${searchController.text}\""
                      : "All Products",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                emptyVerticalBox(height: 10),
                Expanded(
                  child: Container(
                    child: allProducts.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.red),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: isSearching
                                ? filteredProducts.length
                                : allProducts.length,
                            itemBuilder: (ctxt, index) {
                              var item = isSearching
                                  ? filteredProducts[index]
                                  : allProducts[index];

                              return ProductTileWidget(
                                product: item,
                                callback: () {
                                  Get.back(
                                    result: item,
                                  );
                                },
                              );
                            }),
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
