import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageBannersScreen extends StatefulWidget {
  const ManageBannersScreen({super.key});

  @override
  State<ManageBannersScreen> createState() =>
      _ManageBannersScreenState();
}

class _ManageBannersScreenState
    extends State<ManageBannersScreen> {

  final bannerController =
  TextEditingController();

  Future<void> addBanner() async {

    if (bannerController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter banner image URL",
          ),
        ),
      );

      return;
    }

    await FirebaseFirestore.instance
        .collection('banners')
        .add({

      'imageUrl':
      bannerController.text.trim(),

      'isActive': true,

      'createdAt': Timestamp.now(),
    });

    bannerController.clear();

    if (mounted) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Banner Added Successfully",
          ),
        ),
      );
    }
  }

  Future<void> updateBanner(
      String documentId,
      String oldImageUrl,
      ) async {

    final controller =
    TextEditingController(
      text: oldImageUrl,
    );

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title: Text(
            "Edit Banner",
            style: GoogleFonts.poppins(),
          ),

          content: TextField(
            controller: controller,

            decoration: InputDecoration(
              labelText: "Banner Image URL",

              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(12),
              ),
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(

              onPressed: () async {

                await FirebaseFirestore.instance
                    .collection('banners')
                    .doc(documentId)
                    .update({

                  'imageUrl':
                  controller.text.trim(),
                });

                if (!mounted) return;

                Navigator.pop(context);
              },

              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: Text(
          "Manage Banners",

          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      floatingActionButton:
      FloatingActionButton.extended(

        backgroundColor: Colors.green,

        onPressed: () {

          bannerController.clear();

          showDialog(
            context: context,

            builder: (context) {

              return AlertDialog(

                title: Text(
                  "Add Banner",
                  style: GoogleFonts.poppins(),
                ),

                content: TextField(
                  controller: bannerController,

                  decoration: InputDecoration(
                    labelText:
                    "Banner Image URL",

                    hintText:
                    "Paste image URL here",

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                ),

                actions: [

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text("Cancel"),
                  ),

                  ElevatedButton(

                    onPressed: () async {

                      await addBanner();

                      if (!mounted) return;

                      Navigator.pop(context);
                    },

                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },

        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),

        label: Text(
          "Add Banner",

          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection('banners')
            .orderBy(
          'createdAt',
          descending: true,
        )
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {

            return Center(
              child: Text(
                "No Banners Added",

                style:
                GoogleFonts.poppins(),
              ),
            );
          }

          return ListView.builder(

            padding:
            const EdgeInsets.only(
              top: 16,
              bottom: 100,
            ),

            itemCount:
            snapshot.data!.docs.length,

            itemBuilder: (context, index) {

              final doc =
              snapshot.data!.docs[index];

              final data =
              doc.data()
              as Map<String, dynamic>;

              return Container(

                margin:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(16),
                ),

                child: Column(
                  children: [

                    AspectRatio(
                      aspectRatio: 2.4, // 1200 / 500

                      child: ClipRRect(

                        borderRadius:
                        const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),

                        child: Image.network(
                          data['imageUrl'],

                          width: double.infinity,

                          fit: BoxFit.fill,

                          errorBuilder:
                              (context, error, stackTrace) {

                            return Container(
                              alignment: Alignment.center,
                              color: Colors.grey.shade200,

                              child: Text(
                                "Invalid Image URL",
                                style: GoogleFonts.poppins(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.end,

                      children: [

                        IconButton(

                          onPressed: () {

                            updateBanner(
                              doc.id,
                              data['imageUrl'],
                            );
                          },

                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.orange,
                          ),
                        ),

                        IconButton(

                          onPressed: () async {

                            await FirebaseFirestore
                                .instance
                                .collection(
                                'banners')
                                .doc(doc.id)
                                .delete();
                          },

                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}