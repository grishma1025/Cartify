import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'products/products_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: Text(
          "Categories",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // SEARCH BAR



            // DYNAMIC CATEGORY GRID

            Expanded(
              child: StreamBuilder<QuerySnapshot>(

                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .orderBy('createdAt')
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

                    return Center(
                      child: Text(
                        "No Categories Found",

                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(

                    itemCount:
                    snapshot.data!.docs.length,

                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.15,
                    ),

                    itemBuilder: (context, index) {

                      final category =
                      snapshot.data!.docs[index];

                      final data =
                      category.data()
                      as Map<String, dynamic>;

                      return InkWell(

                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductsScreen(
                                categoryId: category.id,
                                categoryName: data['name'],
                              ),
                            ),
                          );
                        },

                        borderRadius:
                        BorderRadius.circular(20),

                        child: Container(

                          decoration: BoxDecoration(
                            color: const Color(0xFFFBE6F1),

                            borderRadius:
                            BorderRadius.circular(20),

                            boxShadow: [
                              BoxShadow(
                                color:
                                Colors.grey.withOpacity(0.08),
                                blurRadius: 8,
                              ),
                            ],
                          ),

                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,

                            children: [

                              Container(
                                height: 70,
                                width: 70,

                                decoration: BoxDecoration(
                                  color:
                                  Colors.white,
                                  shape: BoxShape.circle,
                                ),

                                child: ClipOval(
                                  child: Image.network(

                                    data['imageUrl'] ?? '',

                                    fit: BoxFit.cover,

                                    errorBuilder:
                                        (context, error, stackTrace) {

                                      return Icon(
                                        Icons.image_not_supported,
                                        color:
                                        Colors.grey.shade400,
                                      );
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              Padding(
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),

                                child: Text(

                                  data['name'] ?? '',

                                  textAlign:
                                  TextAlign.center,

                                  maxLines: 2,

                                  overflow:
                                  TextOverflow.ellipsis,

                                  style:
                                  GoogleFonts.poppins(
                                    fontSize: 12,
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
          ],
        ),
      ),
    );
  }
}