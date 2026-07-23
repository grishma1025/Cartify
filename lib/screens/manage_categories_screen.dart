import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() =>
      _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState
    extends State<ManageCategoriesScreen> {

  final TextEditingController categoryController =
  TextEditingController();

  Future<void> addCategory(String imageUrl) async {

    if (categoryController.text.trim().isEmpty ||
        imageUrl.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('categories')
        .add({

      'name': categoryController.text.trim(),
      'imageUrl': imageUrl.trim(),
      'isActive': true,
      'displayOrder': 0,
      'createdAt': Timestamp.now(),
    });

    categoryController.clear();
  }

  Future<void> updateCategory(
      String documentId,
      String oldName,
      String oldImageUrl) async {

    final nameController =
    TextEditingController(text: oldName);

    final imageController =
    TextEditingController(text: oldImageUrl);

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: Text(
            "Edit Category",
            style: GoogleFonts.poppins(),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Category Name",
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: imageController,
                decoration: InputDecoration(
                  labelText: "Image URL",
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {

                await FirebaseFirestore.instance
                    .collection('categories')
                    .doc(documentId)
                    .update({

                  'name': nameController.text.trim(),
                  'imageUrl':
                  imageController.text.trim(),
                });

                if (mounted) Navigator.pop(context);
              },

              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Future<void> initializeDefaultCategories() async {

    final snapshot = await FirebaseFirestore
        .instance
        .collection('categories')
        .get();

    if (snapshot.docs.isNotEmpty) return;

    List<String> categories = [
      "Fruits & Vegetables",
      "Dairy, Bread & Eggs",
      "Atta, Rice & Oil",
      "Packaged Food",
      "Masala & Dry Fruits",
      "Tea & Coffee",
      "Ice Cream & Chocolate",
      "Cold Drinks & Juices",
      "Skincare",
      "Makeup & Beauty",
      "Bath & Body",
      "Haircare",
      "Babycare",
      "Pharmacy & Wellness",
      "Pet Care",
    ];

    for (int i = 0; i < categories.length; i++) {

      await FirebaseFirestore.instance
          .collection('categories')
          .add({

        'name': categories[i],
        'imageUrl': '',
        'isActive': true,
        'displayOrder': i + 1,
        'createdAt': Timestamp.now(),
      });
    }
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
          "Manage Categories",
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

          categoryController.clear();
          final imageController =
          TextEditingController();

          showDialog(
            context: context,
            builder: (context) {

              return AlertDialog(
                title: const Text("Add Category"),

                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    TextField(
                      controller: categoryController,
                      decoration: InputDecoration(
                        labelText: "Category Name",
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: imageController,
                      decoration: InputDecoration(
                        labelText: "Image URL",
                        hintText: "Paste image URL",
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),

                actions: [

                  TextButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),

                  ElevatedButton(
                    onPressed: () async {

                      await addCategory(
                          imageController.text);

                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },

        icon: const Icon(Icons.add,
            color: Colors.white),

        label: const Text(
          "Add Category",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),

                onPressed:
                initializeDefaultCategories,

                child: const Text(
                  "Initialize Default Categories",
                  style:
                  TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(

              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .orderBy('displayOrder')
                  .snapshots(),

              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Categories Found"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 120,
                  ),

                  itemCount:
                  snapshot.data!.docs.length,

                  itemBuilder: (context, index) {

                    final doc =
                    snapshot.data!.docs[index];

                    final data =
                    doc.data() as Map<String, dynamic>;

                    return Card(
                      margin:
                      const EdgeInsets.only(bottom: 12),

                      child: ListTile(

                        leading:
                        data['imageUrl'] != null &&
                            data['imageUrl'] != ''

                            ? CircleAvatar(
                          radius: 28,
                          backgroundImage:
                          NetworkImage(
                            data['imageUrl'],
                          ),
                        )

                            : CircleAvatar(
                          child:
                          Text("${index + 1}"),
                        ),

                        title: Text(data['name']),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [

                            IconButton(
                              onPressed: () {
                                updateCategory(
                                  doc.id,
                                  data['name'],
                                  data['imageUrl'] ?? '',
                                );
                              },

                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
                            ),

                            IconButton(
                              onPressed: () async {

                                await FirebaseFirestore
                                    .instance
                                    .collection('categories')
                                    .doc(doc.id)
                                    .delete();
                              },

                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
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
    );
  }
}
