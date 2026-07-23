import 'package:cartify/screens/cart_screen.dart';
import 'package:cartify/screens/search_screen.dart';
import 'package:cartify/services/wishlist_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/category_card.dart';
import '../widgets/dynamic_banner.dart';
import 'address_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'address_list_screen.dart';
import 'profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:cartify/providers/cart_provider.dart';
import 'package:cartify/services/auto_cart_service.dart';
import 'categories_screen.dart';
import 'products/products_screen.dart';
import 'products/product_details_screen.dart';
import 'products/product_card.dart';
import 'package:cartify/models/product_model.dart';
import 'package:cartify/services/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WishlistService wishlistService = WishlistService();
  Future<void> checkAutoCart() async {
    final cartProvider =
    Provider.of<CartProvider>(context, listen: false);

    final addedProducts =
    await AutoCartService().prepareAutoCart(cartProvider);

    if (!mounted || addedProducts.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.shopping_cart,
                color: Colors.green,
              ),
              SizedBox(width: 8),
              Text("Cart Ready"),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "We've prepared your cart based on your shopping habits.",
                ),

                const SizedBox(height: 16),

                ...addedProducts.map(
                      (product) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            product.productName,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Later"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (_) => const CartScreen(),
                ),
                );
              },
              child: const Text("Review Cart"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAutoCart();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // HEADER
              Row(
                children: [

                  Expanded(
                    child: InkWell(

                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const AddressListScreen(),
                          ),
                        );
                      },

                      child: Container(

                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: StreamBuilder<QuerySnapshot>(

                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(
                            FirebaseAuth
                                .instance.currentUser?.uid,
                          )
                              .collection('addresses')
                              .where('isDefault',
                              isEqualTo: true)
                              .limit(1)
                              .snapshots(),

                          builder: (context, snapshot) {

                            String title =
                                "Deliver To";

                            String subtitle =
                                "Add Delivery Address";

                            if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {

                              final data =
                              snapshot.data!.docs.first.data()
                              as Map<String, dynamic>;

                              title =
                                  data['addressType'] ??
                                      "Home";

                              subtitle =
                              "${data['houseNumber']}, "
                                  "${data['area']}";
                            }

                            return Row(
                              children: [

                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.black87,
                                  size: 20,
                                ),

                                const SizedBox(width: 8),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                    children: [

                                      Text(
                                        title,

                                        style:
                                        GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      Text(
                                        subtitle,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  InkWell(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },

                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey.shade100,

                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // SEARCH BAR

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: GestureDetector(

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchScreen(),
                      ),
                    );

                  },

                  child: AbsorbPointer(

                    child: TextField(

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
                          size: 20,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,

                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // OFFER BANNER

              const DynamicBanner(),

              const SizedBox(height: 30),

              // CATEGORIES

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(
                    "Categories",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoriesScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "See All",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 120,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .orderBy('createdAt')
                      .limit(6)
                      .snapshots(),

                  builder: (context, snapshot) {

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {

                      return const Center(
                        child: Text("No Categories"),
                      );
                    }

                    final categories = snapshot.data!.docs;

                    return ListView.builder(

                      scrollDirection: Axis.horizontal,

                      itemCount: categories.length,

                      itemBuilder: (context, index) {

                        final data =
                        categories[index].data()
                        as Map<String, dynamic>;

                        return InkWell(

                          onTap: () {

                            print("================================");
                            print("Category Clicked");
                            print("Category ID : ${categories[index].id}");
                            print("Category Name : ${data['name']}");

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductsScreen(
                                  categoryId: categories[index].id,
                                  categoryName: data['name'],
                                ),
                              ),
                            );
                          },

                          child: Container(

                            width: 110,
                            margin: const EdgeInsets.only(right: 12),

                            decoration: BoxDecoration(
                              color: const Color(0xFFFBE6F1),

                              borderRadius:
                              BorderRadius.circular(20),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),

                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,

                              children: [

                                CircleAvatar(
                                  radius: 34,
                                  backgroundColor:
                                  Colors.white,

                                  backgroundImage:
                                  NetworkImage(
                                    data['imageUrl'],
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),

                                  child: Text(
                                    data['name'],

                                    textAlign: TextAlign.center,

                                    maxLines: 2,

                                    overflow:
                                    TextOverflow.ellipsis,

                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // PRODUCTS

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  Text(
                    "Products",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  TextButton(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductsScreen(),
                        ),
                      );
                    },

                    child: Text(
                      "See All",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              StreamBuilder<List<ProductModel>>(
                stream: ProductService().getProducts(),

                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final products = snapshot.data!.take(6).toList();

                  if (products.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          "No products found",
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,

                    physics:
                    const NeverScrollableScrollPhysics(),

                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.50,
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
                          await wishlistService.toggleWishlist(product.id!);
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}