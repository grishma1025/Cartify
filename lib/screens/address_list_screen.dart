import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'address_screen.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: Text(
          "My Addresses",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),

      body: user == null
          ? Center(
        child: Text(
          "Please login to view addresses",
          style: GoogleFonts.poppins(),
        ),
      )

          : StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('addresses')
            .orderBy(
          'createdAt',
          descending: true,
        )
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
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.location_off_outlined,
                    size: 70,
                    color: Colors.grey.shade400,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "No Addresses Added Yet",

                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Add your delivery address to continue.",

                    textAlign: TextAlign.center,

                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(

            padding: const EdgeInsets.all(16),

            itemCount: snapshot.data!.docs.length,

            itemBuilder: (context, index) {

              final doc =
              snapshot.data!.docs[index];

              final data =
              doc.data() as Map<String, dynamic>;

              return buildAddressCard(
                context,
                documentId: doc.id,
                title: data['addressType'] ?? '',
                isDefault:
                data['isDefault'] ?? false,

                address:
                "${data['houseNumber']}, "
                    "${data['buildingName']}, "
                    "${data['area']}, "
                    "${data['city']} - "
                    "${data['pincode']}",
              );
            },
          );
        },
      ),

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.white,

        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const AddressScreen(),
            ),
          );
        },

            icon: const Padding(
              padding: EdgeInsets.only(right: 2),
              child: Icon(
                Icons.add,
                size: 20,
                color: Color(0xFF620AA1),
              ),
            ),
        label: Text(
          "Add New Address",

          style: GoogleFonts.poppins(
            color: const Color(0xFF620AA1),

            fontWeight: FontWeight.w600,

          ),

        ),

      ),
    ),);
  }

  Widget buildAddressCard(
      BuildContext context, {

        required String documentId,
        required String title,
        required String address,
        required bool isDefault,
      }) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFEDEBFF),

        borderRadius:
        BorderRadius.circular(18),

        boxShadow: const [],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [



          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Row(
                  children: [

                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.black54,
                    ),

                    const SizedBox(width: 8),

                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(width: 8),

                    if (isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Default",
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () async {
                          final addressDocs = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .collection('addresses')
                              .get();

                          for (var address in addressDocs.docs) {
                            await address.reference.update({
                              'isDefault': false,
                            });
                          }

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('addresses')
                              .doc(documentId)
                              .update({
                            'isDefault': true,
                          });
                        },
                        child: Text(
                          "Set as Default",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFF4A1C6E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    const Spacer(),

                    PopupMenuButton<String>(
                      color: Colors.white,
                      surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.black12,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.black54,
                        size: 18,
                      ),
                      onSelected: (value) async {
                        if (value == "edit") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddressScreen(
                                documentId: documentId,
                              ),
                            ),
                          );
                        } else if (value == "delete") {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .collection('addresses')
                              .doc(documentId)
                              .delete();
                        }
                      },
                      itemBuilder: (context) => [

                        PopupMenuItem(
                          value: "edit",
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit_outlined,
                                color: Colors.black54,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Edit Address",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const PopupMenuDivider(),

                        PopupMenuItem(
                          value: "delete",
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_outline,
                                color: Colors.black54,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Delete Address",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 3),

                Text(
                  address,

                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 10),


              ],
            ),
          ),


        ],
      ),
    );
  }
}