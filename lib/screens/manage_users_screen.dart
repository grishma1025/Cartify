import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: Text(
          "Manage Users",
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

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection('users')
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
                "No Users Found",
                style: GoogleFonts.poppins(),
              ),
            );
          }

          final users = snapshot.data!.docs;

          return ListView.builder(

            padding: const EdgeInsets.all(16),

            itemCount: users.length,

            itemBuilder: (context, index) {

              final doc = users[index];

              final data =
              doc.data() as Map<String, dynamic>;

              String name =
                  data['name'] ??
                      data['username'] ??
                      'Guest User';

              String email =
                  data['email'] ?? 'No Email';

              String phone =
                  data['phone'] ??
                      data['phoneNumber'] ??
                      'No Phone';

              return Container(

                margin:
                const EdgeInsets.only(bottom: 12),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(18),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.06),
                      blurRadius: 6,
                    )
                  ],
                ),

                child: ListTile(

                  contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),

                  leading: CircleAvatar(
                    radius: 24,

                    backgroundColor:
                    Colors.blue.shade50,

                    child: Text(
                      name[0].toUpperCase(),

                      style: GoogleFonts.poppins(
                        color: Colors.blue,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),

                  title: Text(
                    name,

                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        email,

                        style: GoogleFonts.poppins(
                          fontSize: 11,
                        ),
                      ),

                      Text(
                        phone,

                        style: GoogleFonts.poppins(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),

                  trailing: IconButton(

                    onPressed: () async {

                      bool? confirm =
                      await showDialog(

                        context: context,

                        builder: (context) {

                          return AlertDialog(

                            title:
                            const Text("Delete User"),

                            content: const Text(
                              "Are you sure you want to delete this user?",
                            ),

                            actions: [

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context,
                                      false);
                                },

                                child:
                                const Text("Cancel"),
                              ),

                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context,
                                      true);
                                },

                                child:
                                const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {

                        await FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(doc.id)
                            .delete();
                      }
                    },

                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}