import 'package:cartify/models/product_model.dart';
import 'package:cartify/screens/products/add_edit_product_screen.dart';
import 'package:cartify/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final service = ProductService();
  final searchController = TextEditingController();
  String search = '';

  Future<void> _confirmDelete(ProductModel product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('Delete Product', style: GoogleFonts.poppins()),
        content: Text(
          'Are you sure you want to delete "${product.productName}"? This cannot be undone.',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && product.id != null) {
      await service.deleteProduct(product.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted')),
        );
      }
    }
  }

  Widget _statusChip(String label, bool value, Color color) {
    if (!value) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(right: 6, top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
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
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Manage Products',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditProductScreen()),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Product',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (v) => setState(() => search = v.toLowerCase()),
              style: GoogleFonts.poppins(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search products',
                hintStyle: GoogleFonts.poppins(fontSize: 13),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ProductModel>>(
              stream: service.getProducts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var products = snapshot.data!;
                if (search.isNotEmpty) {
                  products = products
                      .where(
                        (p) =>
                    p.productName.toLowerCase().contains(search) ||
                        p.brand.toLowerCase().contains(search) ||
                        p.categoryName.toLowerCase().contains(search),
                  )
                      .toList();
                }

                if (products.isEmpty) {
                  return Center(
                    child: Text('No products found', style: GoogleFonts.poppins()),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    final lowStock = p.stock <= p.minimumStock;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 64,
                              height: 64,
                              child: p.imageUrls.isNotEmpty
                                  ? Image.network(
                                p.imageUrls.first,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey.shade100,
                                  child: const Icon(Icons.image_not_supported_outlined),
                                ),
                              )
                                  : Container(
                                color: Colors.grey.shade100,
                                child: const Icon(Icons.image_outlined),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.productName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${p.categoryName} • ${p.brand}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      '₹${p.sellingPrice.toStringAsFixed(0)}',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.green,
                                      ),
                                    ),
                                    if (p.mrp > p.sellingPrice) ...[
                                      const SizedBox(width: 6),
                                      Text(
                                        '₹${p.mrp.toStringAsFixed(0)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(width: 10),
                                    Text(
                                      'Stock: ${p.stock}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: lowStock ? Colors.red : Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                Wrap(
                                  children: [
                                    _statusChip('Active', p.isActive, Colors.green),
                                    _statusChip('Inactive', !p.isActive, Colors.grey),
                                    _statusChip('Featured', p.isFeatured, Colors.orange),
                                    _statusChip('Trending', p.isTrending, Colors.purple),
                                    if (lowStock)
                                      _statusChip('Low Stock', true, Colors.red),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (v) async {
                              switch (v) {
                                case 'edit':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddEditProductScreen(product: p),
                                    ),
                                  );
                                  break;
                                case 'delete':
                                  _confirmDelete(p);
                                  break;
                                case 'toggle_active':
                                  if (p.id != null) {
                                    await service.toggleActive(p.id!, !p.isActive);
                                  }
                                  break;
                                case 'toggle_featured':
                                  if (p.id != null) {
                                    await service.toggleFeatured(p.id!, !p.isFeatured);
                                  }
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(
                                value: 'toggle_active',
                                child: Text(p.isActive ? 'Mark Inactive' : 'Mark Active'),
                              ),
                              PopupMenuItem(
                                value: 'toggle_featured',
                                child: Text(p.isFeatured ? 'Unfeature' : 'Feature'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete', style: TextStyle(color: Colors.red)),
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
          ),
        ],
      ),
    );
  }
}