import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddressScreen extends StatefulWidget {

  final String? documentId;

  const AddressScreen({
    super.key,
    this.documentId,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  final houseController = TextEditingController();
  final buildingController = TextEditingController();
  final areaController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();

  String selectedAddressType = "Home";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.documentId != null) {
      loadAddress();
    }
  }
  bool isFetchingCity = false;

  Future<void> fetchCityFromPincode(String pincode) async {

    if (pincode.length != 6) return;

    setState(() {
      isFetchingCity = true;
    });

    try {

      final response = await http.get(
        Uri.parse(
          "https://api.postalpincode.in/pincode/$pincode",
        ),
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        if (data[0]["Status"] == "Success") {

          final office = data[0]["PostOffice"][0];

          cityController.text = office["District"] ?? "";
        } else {

          cityController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid Pincode"),
            ),
          );
        }
      }

    } catch (e) {

      cityController.clear();
    }

    setState(() {
      isFetchingCity = false;
    });
  }
  Future<void> loadAddress() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    setState(() {
      isLoading = true;
    });

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('addresses')
        .doc(widget.documentId)
        .get();

    if (doc.exists) {

      final data = doc.data()!;

      houseController.text = data['houseNumber'];
      buildingController.text = data['buildingName'];
      areaController.text = data['area'];
      cityController.text = data['city'];
      pincodeController.text = data['pincode'];

      selectedAddressType = data['addressType'];
    }

    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: Text(
          widget.documentId == null
              ? "Delivery Address"
              : "Edit Address",
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

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
        widget.documentId == null
        ? "Add New Address"
            : "Edit Address",

              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              widget.documentId == null
                  ? "Please enter your delivery details."
                  : "Update your delivery details.",

              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black45,
              ),
            ),

            const SizedBox(height: 25),

            buildTextField(
              controller: houseController,
              hint: "House / Flat Number",
              icon: Icons.home_outlined,
            ),

            const SizedBox(height: 14),

            buildTextField(
              controller: buildingController,
              hint: "Building / Society Name",
              icon: Icons.apartment_outlined,
            ),

            const SizedBox(height: 14),

            buildTextField(
              controller: areaController,
              hint: "Area / Street Name",
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 14),

            buildTextField(
              controller: pincodeController,
              hint: "Pincode",
              icon: Icons.pin_drop_outlined,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (value) {

                if (value.length == 6) {
                  fetchCityFromPincode(value);
                }

              },
            ),

            const SizedBox(height: 14),

            Stack(
              alignment: Alignment.centerRight,
              children: [

                buildTextField(
                  controller: cityController,
                  hint: "City",
                  icon: Icons.location_city_outlined,
                ),

                if (isFetchingCity)
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 25),

            Text(
              "Address Type",

              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [

                buildChip("Home"),
                const SizedBox(width: 10),

                buildChip("Work"),
                const SizedBox(width: 10),

                buildChip("Other"),
              ],
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 54,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF620AA1),
                  elevation: 2,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                ),

                onPressed: () async {

                  final user = FirebaseAuth.instance.currentUser;

                  if (houseController.text.trim().isEmpty ||
                      buildingController.text.trim().isEmpty ||
                      areaController.text.trim().isEmpty ||
                      cityController.text.trim().isEmpty ||
                      pincodeController.text.trim().isEmpty) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all fields"),
                      ),
                    );

                    return;
                  }

                  if (user == null) return;

                  final addressCollection = FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('addresses');

                  if (widget.documentId == null) {

                    final existingAddresses =
                    await addressCollection.get();

                    bool makeDefault =
                        existingAddresses.docs.isEmpty;

                    await addressCollection.add({

                      'houseNumber': houseController.text.trim(),
                      'buildingName': buildingController.text.trim(),
                      'area': areaController.text.trim(),
                      'city': cityController.text.trim(),
                      'pincode': pincodeController.text.trim(),
                      'addressType': selectedAddressType,
                      'isDefault': makeDefault,
                      'createdAt': Timestamp.now(),

                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Address Saved Successfully"),
                      ),
                    );

                  } else {

                    await addressCollection
                        .doc(widget.documentId)
                        .update({

                      'houseNumber': houseController.text.trim(),
                      'buildingName': buildingController.text.trim(),
                      'area': areaController.text.trim(),
                      'city': cityController.text.trim(),
                      'pincode': pincodeController.text.trim(),
                      'addressType': selectedAddressType,

                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Address Updated Successfully"),
                      ),
                    );
                  }

                  if (!mounted) return;

                  Navigator.pop(context);
                },

                child: Text(
                  widget.documentId == null
                      ? "Save Address"
                      : "Update Address",

                  style: GoogleFonts.poppins(
                    color: const Color(0xFFF3F4F8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    Function(String)? onChanged,
  }) {

    return Container(

      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF), // Same soft grey as Home search bar
        borderRadius: BorderRadius.circular(18),
      ),

      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        onChanged: onChanged,
        style: GoogleFonts.poppins(
          fontSize: 13,
        ),

        decoration: InputDecoration(
          hintText: hint,

          hintStyle: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.black45,
          ),

          prefixIcon: Icon(
            icon,
            color: Colors.black54,
            size: 20,
          ),

          border: InputBorder.none,

          contentPadding:
          const EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget buildChip(String type) {

    return ChoiceChip(
      label: Text(
        type,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: selectedAddressType == type
              ? const Color(0xFF620AA1)
              : Colors.black87,
          fontWeight: FontWeight.w400,
        ),
      ),

      selected: selectedAddressType == type,

      selectedColor: const Color(0xFFEDEBFF),

      backgroundColor: Colors.white,

      side: BorderSide(
        color: selectedAddressType == type
            ? const Color(0xFF620AA1)
            : Colors.grey.shade300,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      onSelected: (value) {
        setState(() {
          selectedAddressType = type;
        });
      },
    );
  }
}