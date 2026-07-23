import 'package:cartify/models/product_model.dart';
import 'package:cartify/screens/products/product_card.dart';
import 'package:cartify/screens/products/product_details_screen.dart';
import 'package:cartify/services/product_service.dart';
import 'package:cartify/services/wishlist_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ProductService service = ProductService();

  final TextEditingController controller = TextEditingController();

  String search = "";
  bool isRandomSearch(String text) {
    text = text.toLowerCase().trim();

    if (text.length < 5) return false;

    final vowels = RegExp(r'[aeiou]').allMatches(text).length;

    return vowels <= 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),

        title: Text(
          "Search",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),

        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: controller,
              autofocus: true,

              onChanged: (value) {
                setState(() {
                  search = value.toLowerCase().trim();
                });
              },

              style: GoogleFonts.poppins(
                fontSize: 13,
              ),

              decoration: InputDecoration(

                hintText: "Search for groceries",

                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                ),

                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),

                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                suffixIcon: const Icon(
                  Icons.mic_none_outlined,
                ),

                filled: true,
                fillColor: const Color(0xFFF5F6FA),


              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<List<ProductModel>>(

                stream: service.getProducts(),

                builder: (context, snapshot) {

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }

                  List<ProductModel> products =
                  snapshot.data!;

                  if (search.isNotEmpty) {

                    products = products.where((product) {

                      return product.productName
                          .toLowerCase()
                          .contains(search) ||

                          product.brand
                              .toLowerCase()
                              .contains(search) ||

                          product.categoryName
                              .toLowerCase()
                              .contains(search) ||

                          product.subCategory
                              .toLowerCase()
                              .contains(search);

                    }).toList();
                  }

                  if (search.isEmpty) {

                    return Center(

                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [

                          Icon(
                            Icons.search,
                            size: 70,
                            color: Colors.grey.shade400,
                          ),

                          const SizedBox(height: 16),

                          Text(
                            "Search Products",

                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Search by product name,\nbrand or category.",

                            textAlign: TextAlign.center,

                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (products.isEmpty) {

                    if (isRandomSearch(search)) {

                      final kidsKeywords = [
                        "chocolate",
                        "ice cream",
                        "cookie",
                        "biscuit",
                        "chips",
                        "juice",
                        "drink",
                        "candy",
                      ];

                      final kidsProducts = snapshot.data!
                          .where((product) {

                        return kidsKeywords.any((keyword) {

                          return product.productName
                              .toLowerCase()
                              .contains(keyword) ||

                              product.categoryName
                                  .toLowerCase()
                                  .contains(keyword);

                        });

                      }).toList();

                      if (kidsProducts.isNotEmpty) {
                        products = kidsProducts;
                      } else {

                        return const Center(
                          child: Text("No products found"),
                        );

                      }

                    } else {

                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Icon(
                              Icons.search_off,
                              size: 70,
                              color: Colors.grey,
                            ),

                            SizedBox(height: 16),

                            Text(
                              "No products found",
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              "Try searching with another keyword.",
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );

                    }

                  }

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      8,
                      8,
                      8,
                      20,
                    ),

                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.45,
                    ),

                    itemCount: products.length,

                    itemBuilder: (context, index) {
                      final product = products[index];

                      return ProductCard(
                        product: product,

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(
                                product: product,
                              ),
                            ),
                          );
                        },

                        onWishlist: () async {
                          await WishlistService().toggleWishlist(product.id!);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}