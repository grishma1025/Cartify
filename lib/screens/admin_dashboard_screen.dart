import 'package:cartify/screens/manage_admins_screen.dart';
import 'package:cartify/screens/manage_pending_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'manage_orders_screen.dart';
import 'manage_users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'reports_screen.dart';
import 'manage_categories_screen.dart';
import 'products/manage_products_screen.dart';
import 'manage_banners_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String formatRevenue(double revenue) {
      if (revenue >= 1000000) {
        return "₹${(revenue / 1000000).toStringAsFixed(1)}M";
      } else if (revenue >= 1000) {
        return "₹${(revenue / 1000).toStringAsFixed(1)}K";
      } else {
        return "₹${revenue.toStringAsFixed(0)}";
      }
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: Text(
          "Admin Dashboard",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),

        actions: [

          PopupMenuButton(

            icon: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.indigo.shade50,

              child: Icon(
                Icons.person_outline,
                color: Colors.indigo,
              ),
            ),

            itemBuilder: (context) => [

              PopupMenuItem(
                value: 'logout',

                child: Row(
                  children: [

                    const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),

                    const SizedBox(width: 10),

                    Text(
                      "Logout",
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ),
            ],

            onSelected: (value) async {

              if (value == 'logout') {

                await FirebaseAuth.instance.signOut();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,

                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),

                      (route) => false,
                );
              }
            },
          ),

          const SizedBox(width: 10),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.1,

          children: [

            /*pending orders*/
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("orders")
                  .where("status", isEqualTo: "pending")
                  .snapshots(),

              builder: (context, snapshot) {

                int pending =
                    snapshot.data?.docs.length ?? 0;

                return GestureDetector(

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const ManagePendingOrdersScreen(),
                      ),
                    );

                  },

                  child: dashboardCard(
                    icon: Icons.pending_actions_outlined,
                    title: "Pending Orders",
                    value: pending.toString(),
                    color: Colors.redAccent,
                  ),
                );
              },
            ),

            /*orders*/
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("orders")
                  .snapshots(),

              builder: (context, snapshot) {

                int totalOrders =
                    snapshot.data?.docs.length ?? 0;

                return GestureDetector(

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const ManageOrdersScreen(),
                      ),
                    );

                  },

                  child: dashboardCard(
                    icon: Icons.shopping_bag_outlined,
                    title: "Total Orders",
                    value: totalOrders.toString(),
                    color: Colors.orange,
                  ),
                );
              },
            ),

            /*users*/
            StreamBuilder<QuerySnapshot>(

              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),

              builder: (context, snapshot) {

                int totalUsers =
                    snapshot.data?.docs.length ?? 0;

                return GestureDetector(

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const ManageUsersScreen(),
                      ),
                    );
                  },

                  child: dashboardCard(
                    icon: Icons.people_outline,
                    title: "Users",
                    value: totalUsers.toString(),
                    color: Colors.blue,
                  ),
                );
              },
            ),

            /*revenue*/
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("orders")
                  .snapshots(),

              builder: (context, snapshot) {

                double revenue = 0;

                if (snapshot.hasData) {

                  for (var doc in snapshot.data!.docs) {

                    revenue +=
                        (doc["grandTotal"] as num)
                            .toDouble();

                  }

                }

                return GestureDetector(

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const ReportsScreen(),
                      ),
                    );

                  },

                  child: dashboardCard(
                    icon: Icons.currency_rupee,
                    title: "Revenue",
                    value: formatRevenue(revenue),
                    color: Colors.green,
                  ),
                );
              },
            ),

            /*prod*/
            /*products*/
            StreamBuilder<QuerySnapshot>(

              stream: FirebaseFirestore.instance
                  .collection('products')
                  .snapshots(),

              builder: (context, snapshot) {

                int totalProducts =
                    snapshot.data?.docs.length ?? 0;

                return GestureDetector(

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const ManageProductsScreen(),
                      ),
                    );
                  },

                  child: dashboardCard(
                    icon: Icons.inventory_2_outlined,
                    title: "Products",
                    value: totalProducts.toString(),
                    color: Colors.purple,
                  ),
                );
              },
            ),

            /*categories*/
            StreamBuilder<QuerySnapshot>(

              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),

              builder: (context, snapshot) {

                int totalCategories =
                    snapshot.data?.docs.length ?? 0;

                return GestureDetector(

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const ManageCategoriesScreen(),
                      ),
                    );
                  },

                  child: dashboardCard(
                    icon: Icons.grid_view_rounded,
                    title: "Categories",
                    value: totalCategories.toString(),
                    color: Colors.deepOrange,
                  ),
                );
              },
            ),

            /*banners*/
            StreamBuilder<QuerySnapshot>(

              stream: FirebaseFirestore.instance
                  .collection('banners')
                  .snapshots(),

              builder: (context, snapshot) {

                int totalBanners =
                    snapshot.data?.docs.length ?? 0;

                return GestureDetector(

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const ManageBannersScreen(),
                      ),
                    );
                  },

                  child: dashboardCard(
                    icon: Icons.photo_library_outlined,
                    title: "Banners",
                    value: totalBanners.toString(),
                    color: Colors.teal,
                  ),
                );
              },
            ),

            /*admins*/
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('admin')
                  .snapshots(),

              builder: (context, snapshot) {

                int totalAdmins =
                    snapshot.data?.docs.length ?? 0;

                return GestureDetector(

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const ManageAdminsScreen(),
                      ),
                    );
                  },

                  child: dashboardCard(
                    icon: Icons.admin_panel_settings_outlined,
                    title: "Admins",
                    value: totalAdmins.toString(),
                    color: Colors.indigo,
                  ),
                );
              },
            ),



          ],
        ),
      ),
      ),
    );
  }

  Widget dashboardCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,

        children: [

          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.12),

            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),

          const SizedBox(height: 10),

          FittedBox(
            child: Text(
              value,

              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,

            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,

            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );

  }
}