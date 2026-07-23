import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  late Future<List<Map<String, dynamic>>> ordersFuture;

  @override
  void initState() {
    super.initState();
    ordersFuture = getOrders();
  }
  Future<List<Map<String, dynamic>>> getOrders() async {
    final orderSnapshot = await FirebaseFirestore.instance
        .collection("orders")
        .orderBy("createdAt", descending: true)
        .get();

    List<Map<String, dynamic>> orderList = [];

    for (var orderDoc in orderSnapshot.docs) {
      Map<String, dynamic> order = orderDoc.data();

      String userId = order["userId"];

      String customerName = "Unknown User";

      try {
        final userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .get();

        if (userDoc.exists) {
          customerName = userDoc["fullName"] ?? "Unknown User";
        }
      } catch (_) {}

      orderList.add({
        "orderId": order["orderId"],

        "customerName": customerName,
        "docId": orderDoc.id,
        "grandTotal": order["grandTotal"],

        "paymentMethod": order["paymentMethod"],

        "status": order["status"],

        "createdAt": order["createdAt"],
      });
    }

    return orderList;
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;

      case "delivered":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      default:
        return Colors.blue;
    }
  }
  Future<void> showStatusDialog(String docId, String currentStatus) async {

    String selectedStatus = currentStatus.toLowerCase();

    await showDialog(
      context: context,

      builder: (context) {

        return StatefulBuilder(

          builder: (context, setState) {

            return AlertDialog(

              title: const Text("Update Order Status"),

              content: DropdownButton<String>(

                value: selectedStatus,

                isExpanded: true,

                items: const [

                  DropdownMenuItem(
                    value: "pending",
                    child: Text("Pending"),
                  ),

                  DropdownMenuItem(
                    value: "out for delivery",
                    child: Text("Out for Delivery"),
                  ),

                  DropdownMenuItem(
                    value: "delivered",
                    child: Text("Delivered"),
                  ),

                  DropdownMenuItem(
                    value: "cancelled",
                    child: Text("Cancelled"),
                  ),

                ],

                onChanged: (value) {

                  if (value != null) {

                    setState(() {
                      selectedStatus = value;
                    });

                  }

                },
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
                        .collection("orders")
                        .doc(docId)
                        .update({

                      "status": selectedStatus,

                    });

                    if (mounted) {


                      Navigator.pop(context);   // Close the dialog first

                      setState(() {
                        ordersFuture = getOrders();
                      });

                      ScaffoldMessenger.of(context).showSnackBar(

                        const SnackBar(
                          content: Text(
                            "Order status updated successfully",
                          ),
                        ),

                      );

                    }

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        centerTitle: true,

        title: Text(
          "Manage Orders",

          style: GoogleFonts.poppins(
            color: Colors.black,

            fontWeight: FontWeight.w600,

            fontSize: 17,
          ),
        ),

        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ordersFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No Orders Found", style: GoogleFonts.poppins()),
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.08),
                      blurRadius: 8,
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Expanded(
                          child: Text(
                            order["orderId"].toString(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            color: getStatusColor(
                              order["status"],
                            ).withOpacity(.15),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Text(
                            order["status"].toString(),
                            style: GoogleFonts.poppins(
                              color: getStatusColor(order["status"]),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      order["customerName"].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "₹${order["grandTotal"]}",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      order["paymentMethod"].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                          showStatusDialog(
                            order["docId"],
                            order["status"],
                          );

                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: Text(
                          "Update Status",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
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
