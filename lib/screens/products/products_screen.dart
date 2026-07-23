// products_screen.dart

import 'package:cartify/models/product_model.dart';
import 'package:cartify/screens/products/product_details_screen.dart';
import 'package:cartify/screens/products/product_card.dart';
import 'package:cartify/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductsScreen extends StatefulWidget {

  final String? categoryId;
  final String? categoryName;

  const ProductsScreen({
    super.key,
    this.categoryId,
    this.categoryName,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}


class _ProductsScreenState extends State<ProductsScreen> {
  final ProductService service = ProductService();
  final TextEditingController searchController = TextEditingController();
  String search='';

  @override
  Widget build(BuildContext context){

    print("Received Category ID: ${widget.categoryId}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),

        title: Text(
          widget.categoryName ?? "Products",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children:[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(15),
              ),

              child: TextField(
                controller: searchController,

                onChanged: (v) =>
                    setState(() => search = v.toLowerCase()),

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
            )
          ),
          Expanded(
            child: StreamBuilder<List<ProductModel>>(
              stream: widget.categoryId == null
                  ? service.getProducts()
                  : service.getProductsByCategory(widget.categoryId!),
              builder:(context,snapshot){
                if(!snapshot.hasData){
                  return const Center(child:CircularProgressIndicator());
                }
                var products=snapshot.data!;
                if(search.isNotEmpty){
                  products=products.where((p)=>
                  p.productName.toLowerCase().contains(search)||
                      p.brand.toLowerCase().contains(search)||
                      p.categoryName.toLowerCase().contains(search)
                  ).toList();
                }
                if(products.isEmpty){
                  return Center(child:Text('No products found',style:GoogleFonts.poppins()));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.50,
                  ),
                  itemCount: products.length,
                  itemBuilder:(context,index){
                    final product=products[index];
                    return ProductCard(
                      product: product,
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(
                          builder:(_)=>ProductDetailsScreen(product: product),
                        ));
                      },

                      onWishlist: (){
                        // TODO Wishlist
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
