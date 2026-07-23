import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cartify/providers/cart_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'address_screen.dart';
import 'login_screen.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPayment = "Cash on Delivery";
  bool isPlacingOrder = false;

  // Id of the address currently selected in the dropdown picker.
  // Null means "use the default address" (the initial state).
  String? selectedAddressId;

  // ---- Design tokens (matches Figma / other screens) ----
  static const Color _accent = Color(0xFF061473);
  static const Color _pageBg = Color(0xFFF9F9FB);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    const double deliveryCharge = 0;

    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Checkout",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.cartItems.isEmpty) {
            return Center(
              child: Text(
                "Your cart is empty.",
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                // ---------- ADDRESS ----------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .collection('addresses')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _accent,
                            ),
                          ),
                        );
                      }

                      final docs = snapshot.data?.docs ?? [];

                      if (docs.isEmpty) {
                        return Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Delivery Address",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "No address added yet.",
                              style: GoogleFonts.poppins(fontSize: 10),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _accent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const AddressScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Add Address",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      // Resolve which address is currently selected:
                      QueryDocumentSnapshot selectedDoc = docs.first;

                      if (selectedAddressId != null) {
                        final match = docs.where((d) => d.id == selectedAddressId);

                        if (match.isNotEmpty) {
                          selectedDoc = match.first;
                        }
                      } else {
                        final defaults = docs.where(
                              (d) => (d.data() as Map<String, dynamic>)["isDefault"] == true,
                        );

                        if (defaults.isNotEmpty) {
                          selectedDoc = defaults.first;
                        }
                      }

                      final data =
                      selectedDoc.data() as Map<String, dynamic>;

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _openAddressPicker(
                          context,
                          docs,
                          selectedDoc.id,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: _accent,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['addressType'] ?? '',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "${data['houseNumber']}, "
                                        "${data['buildingName']}, "
                                        "${data['area']}, "
                                        "${data['city']} - "
                                        "${data['pincode']}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 18,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // ---------- ORDER SUMMARY ----------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order Summary",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...cartProvider.cartItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;

                        return Column(
                          children: [

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.imageUrl,
                                      width: 42,
                                      height: 42,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.image_outlined,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text(
                                          item.productName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        const SizedBox(height: 3),

                                        Text(
                                          "${item.cartQuantity} × ${item.quantity.toStringAsFixed(0)} ${item.unit}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    "₹${item.totalPrice.toStringAsFixed(0)}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Divider between products
                            if (index != cartProvider.cartItems.length - 1)
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Divider(
                                  height: 1,
                                  thickness: 0.8,
                                  color: Color(0xFFE5E5E5),
                                ),
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ---------- BILL SUMMARY ----------
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      billRow(
                        "Subtotal",
                        "₹${cartProvider.subtotal.toStringAsFixed(0)}",
                      ),
                      billRow(
                        "Savings",
                        "₹${cartProvider.totalSavings.toStringAsFixed(0)}",
                      ),
                      billRow(
                        "Delivery",
                        deliveryCharge == 0
                            ? "FREE"
                            : "₹${deliveryCharge.toStringAsFixed(0)}",
                      ),

                      Divider(color: Colors.grey.shade200),

                      billRow(
                        "Grand Total",
                        "₹${(cartProvider.subtotal + deliveryCharge).toStringAsFixed(0)}",
                        bold: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ---------- PAYMENT METHOD ----------
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Payment Method",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _paymentTile("Cash on Delivery"),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _paymentTile("Credit/Debit Card", "Credit / Debit Card"),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _paymentTile("UPI"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: isPlacingOrder ? null : placeOrder,
                    child: isPlacingOrder
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      "Place Order",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _paymentTile(String value, [String? label]) {
    return RadioListTile(
      value: value,
      groupValue: selectedPayment,
      activeColor: _accent,
      dense: true,
      visualDensity: VisualDensity.compact,
      onChanged: (v) => setState(() => selectedPayment = v.toString()),
      title: Text(
        label ?? value,
        style: GoogleFonts.poppins(fontSize: 11),
      ),
    );
  }

  void _openAddressPicker(
      BuildContext context,
      List<QueryDocumentSnapshot> docs,
      String currentSelectedId,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Delivery Address",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  return RadioListTile<String>(
                    value: doc.id,
                    groupValue: currentSelectedId,
                    activeColor: _accent,
                    dense: true,
                    onChanged: (v) {
                      setState(() => selectedAddressId = v);
                      Navigator.pop(sheetContext);
                    },
                    title: Text(
                      data['addressType'] ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "${data['houseNumber']}, ${data['buildingName']}, "
                          "${data['area']}, ${data['city']} - ${data['pincode']}",
                      style: GoogleFonts.poppins(fontSize: 10),
                    ),
                  );
                }),
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddressScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 16, color: _accent),
                  label: Text(
                    "Add New Address",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget billRow(
      String title,
      String value, {
        bool bold = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: bold ? 12 : 10,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
              color: bold ? Colors.black : Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: bold ? 12 : 10,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
              color: bold ? _accent : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> placeOrder() async {
    setState(() {
      isPlacingOrder = true;
    });
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.isAnonymous) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
      setState(() {
        isPlacingOrder = false;
      });
      return;
    }

    final cartProvider =
    Provider.of<CartProvider>(context, listen: false);

    const double deliveryCharge = 0;

    final double grandTotal = cartProvider.subtotal + deliveryCharge;

    if (cartProvider.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Your cart is empty.",
            style: GoogleFonts.poppins(fontSize: 10),
          ),
        ),
      );
      setState(() {
        isPlacingOrder = false;
      });
      return;
    }

    final addressesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('addresses')
        .get();

    if (addressesSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please add a delivery address.",
            style: GoogleFonts.poppins(fontSize: 10),
          ),
        ),
      );

      setState(() {
        isPlacingOrder = false;
      });
      return;
    }

    // Use whichever address the user selected in the dropdown;
    // fall back to the default address if none was explicitly chosen.
    QueryDocumentSnapshot<Map<String, dynamic>> selectedDoc =
        addressesSnapshot.docs.first;

    if (selectedAddressId != null) {
      final match = addressesSnapshot.docs.where(
            (d) => d.id == selectedAddressId,
      );

      if (match.isNotEmpty) {
        selectedDoc = match.first;
      }
    } else {
      final defaults = addressesSnapshot.docs.where(
            (d) => d.data()["isDefault"] == true,
      );

      if (defaults.isNotEmpty) {
        selectedDoc = defaults.first;
      }
    }

    final address = selectedDoc.data();
    final orderRef =
    FirebaseFirestore.instance.collection("orders").doc();

    await orderRef.set({
      "orderId": orderRef.id,
      "userId": user.uid,

      "status": "pending",

      "paymentMethod": selectedPayment,

      "subtotal": cartProvider.subtotal,

      "totalSavings": cartProvider.totalSavings,

      "grandTotal": grandTotal,

      "totalItems": cartProvider.totalItems,

      "createdAt": FieldValue.serverTimestamp(),

      "address": address,

      "products": cartProvider.cartItems.map((item) {
        return {
          "productId": item.productId,
          "productName": item.productName,
          "brand": item.brand,
          "imageUrl": item.imageUrl,
          "sellingPrice": item.sellingPrice,
          "mrp": item.mrp,
          "quantity": item.quantity,
          "unit": item.unit,

          "cartQuantity": item.cartQuantity,
          "totalPrice": item.totalPrice,
        };
      }).toList(),
    });

    await cartProvider.clearCart();
    setState(() {
      isPlacingOrder = false;
    });
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const OrderSuccessScreen(),
      ),
    );
  }
}