import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageAdminsScreen extends StatefulWidget {
  const ManageAdminsScreen({super.key});

  @override
  State<ManageAdminsScreen> createState() =>
      _ManageAdminsScreenState();
}

class _ManageAdminsScreenState
    extends State<ManageAdminsScreen> {

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController =
  TextEditingController();
  final phoneController = TextEditingController();

  String selectedRole = "Admin";

  Future<void> addAdmin() async {

    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );

      return;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
        ),
      );

      return;
    }

    final existingAdmin =
    await FirebaseFirestore.instance
        .collection('admin')
        .where(
      'email',
      isEqualTo: emailController.text.trim(),
    )
        .get();

    if (existingAdmin.docs.isNotEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email already exists"),
        ),
      );

      return;
    }

    await FirebaseFirestore.instance
        .collection('admin')
        .add({

      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'phone': phoneController.text.trim(),
      'role': selectedRole,
      'createdAt': Timestamp.now(),
    });

    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "New Admin Added Successfully",
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> deleteAdmin(
      String docId,
      String role) async {

    if (role == "Super Admin") {

      final superAdmins =
      await FirebaseFirestore.instance
          .collection('admin')
          .where(
        'role',
        isEqualTo: "Super Admin",
      )
          .get();

      if (superAdmins.docs.length <= 1) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Cannot delete last Super Admin",
            ),
          ),
        );

        return;
      }
    }

    await FirebaseFirestore.instance
        .collection('admin')
        .doc(docId)
        .delete();
  }

  Future<void> editAdmin(
      String docId,
      Map<String, dynamic> adminData) async {

    final name =
    TextEditingController(text: adminData['name']);

    final email =
    TextEditingController(text: adminData['email']);

    final phone =
    TextEditingController(text: adminData['phone']);

    String role = adminData['role'];

    showDialog(
      context: context,
      builder: (context) {

        return StatefulBuilder(
          builder: (context, setDialogState) {

            return AlertDialog(

              title: const Text("Edit Admin"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [

                    TextField(
                      controller: name,
                      decoration:
                      const InputDecoration(
                        labelText: "Name",
                      ),
                    ),

                    TextField(
                      controller: email,
                      decoration:
                      const InputDecoration(
                        labelText: "Email",
                      ),
                    ),

                    TextField(
                      controller: phone,
                      decoration:
                      const InputDecoration(
                        labelText: "Phone",
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButton<String>(
                      value: role,
                      isExpanded: true,

                      items: const [

                        DropdownMenuItem(
                          value: "Admin",
                          child: Text("Admin"),
                        ),

                        DropdownMenuItem(
                          value: "Super Admin",
                          child: Text("Super Admin"),
                        ),
                      ],

                      onChanged: (value) {

                        setDialogState(() {
                          role = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [

                TextButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                ElevatedButton(

                  onPressed: () async {

                    await FirebaseFirestore.instance
                        .collection('admin')
                        .doc(docId)
                        .update({

                      'name': name.text.trim(),
                      'email': email.text.trim(),
                      'phone': phone.text.trim(),
                      'role': role,
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
      },
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,

      obscureText: isPassword
          ? (hint == "Password"
          ? hidePassword
          : hideConfirmPassword)
          : false,

      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: Icon(
          icon,
          color: Colors.indigo,
        ),

        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            (hint == "Password"
                ? hidePassword
                : hideConfirmPassword)
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),

          onPressed: () {
            setState(() {
              if (hint == "Password") {
                hidePassword = !hidePassword;
              } else {
                hideConfirmPassword =
                !hideConfirmPassword;
              }
            });
          },
        )
            : null,

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text(
          "Manage Admins",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(
              "Add New Admin",

              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            buildTextField(
              controller: nameController,
              hint: "Full Name",
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 14),

            buildTextField(
              controller: emailController,
              hint: "Email",
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 14),

            buildTextField(
              controller: passwordController,
              hint: "Password",
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 14),

            buildTextField(
              controller:
              confirmPasswordController,
              hint: "Confirm Password",
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 14),

            buildTextField(
              controller: phoneController,
              hint: "Phone Number",
              icon: Icons.phone_outlined,
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              value: selectedRole,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),

              items: const [

                DropdownMenuItem(
                  value: "Admin",
                  child: Text("Admin"),
                ),

                DropdownMenuItem(
                  value: "Super Admin",
                  child: Text("Super Admin"),
                ),
              ],

              onChanged: (value) {

                setState(() {
                  selectedRole = value!;
                });
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),

                onPressed: addAdmin,

                child: Text(
                  "Create Admin",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Existing Admins",

              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 15),

            StreamBuilder<QuerySnapshot>(

              stream: FirebaseFirestore.instance
                  .collection('admin')
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

                return ListView.builder(

                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount:
                  snapshot.data!.docs.length,

                  itemBuilder: (context, index) {

                    final doc =
                    snapshot.data!.docs[index];

                    final data =
                    doc.data()
                    as Map<String, dynamic>;

                    return Card(
                      margin:
                      const EdgeInsets.only(
                        bottom: 12,
                      ),

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                      ),

                      child: ListTile(

                        leading: CircleAvatar(
                          backgroundColor:
                          Colors.indigo.shade50,

                          child: const Icon(
                            Icons.admin_panel_settings,
                            color: Colors.indigo,
                          ),
                        ),

                        title: Text(data['name']),

                        subtitle: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Text(data['email']),

                            Text(
                              data['role'],
                              style: const TextStyle(
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),

                        trailing: Row(
                          mainAxisSize:
                          MainAxisSize.min,

                          children: [

                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),

                              onPressed: () {

                                editAdmin(
                                  doc.id,
                                  data,
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),

                              onPressed: () {

                                deleteAdmin(
                                  doc.id,
                                  data['role'],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}