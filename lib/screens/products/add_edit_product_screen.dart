import 'package:cartify/models/product_model.dart';
import 'package:cartify/services/product_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ProductService();

  bool get isEditing => widget.product != null;
  bool isSaving = false;

  // Text controllers
  late final TextEditingController productNameController;
  late final TextEditingController brandController;
  late final TextEditingController subCategoryController;
  late final TextEditingController descriptionController;
  late final TextEditingController ingredientsController;
  late final TextEditingController manufacturerController;
  late final TextEditingController countryOfOriginController;
  late final TextEditingController storageInstructionsController;
  late final TextEditingController mrpController;
  late final TextEditingController sellingPriceController;
  late final TextEditingController quantityController;
  late final TextEditingController stockController;
  late final TextEditingController minimumStockController;
  late final TextEditingController shelfLifeDaysController;
  final TextEditingController imageUrlController = TextEditingController();

  // Category dropdown
  String? selectedCategoryId;
  String? selectedCategoryName;

  // Unit dropdown
  static const List<String> unitOptions = [
    'pcs',
    'kg',
    'g',
    'l',
    'ml',
    'dozen',
    'pack',
    'box',
    'bottle',
    'jar',
  ];
  late String selectedUnit;

  // Images
  late List<String> imageUrls;

  // Flags
  late bool isPerishable;
  late bool isFeatured;
  late bool isTrending;
  late bool isRecommended;
  late bool isActive;

  @override
  void initState() {
    super.initState();
    final p = widget.product;

    productNameController = TextEditingController(text: p?.productName ?? '');
    brandController = TextEditingController(text: p?.brand ?? '');
    subCategoryController = TextEditingController(text: p?.subCategory ?? '');
    descriptionController = TextEditingController(text: p?.description ?? '');
    ingredientsController = TextEditingController(text: p?.ingredients ?? '');
    manufacturerController =
        TextEditingController(text: p?.manufacturer ?? '');
    countryOfOriginController =
        TextEditingController(text: p?.countryOfOrigin ?? '');
    storageInstructionsController =
        TextEditingController(text: p?.storageInstructions ?? '');
    mrpController =
        TextEditingController(text: p != null ? p.mrp.toString() : '');
    sellingPriceController = TextEditingController(
        text: p != null ? p.sellingPrice.toString() : '');
    quantityController =
        TextEditingController(text: p != null ? p.quantity.toString() : '');
    stockController =
        TextEditingController(text: p != null ? p.stock.toString() : '');
    minimumStockController = TextEditingController(
        text: p != null ? p.minimumStock.toString() : '0');
    shelfLifeDaysController = TextEditingController(
        text: p != null ? p.shelfLifeDays.toString() : '0');

    selectedCategoryId = p?.categoryId;
    selectedCategoryName = p?.categoryName;

    selectedUnit = (p != null && unitOptions.contains(p.unit))
        ? p.unit
        : unitOptions.first;

    imageUrls = p != null ? List<String>.from(p.imageUrls) : <String>[];

    isPerishable = p?.isPerishable ?? false;
    isFeatured = p?.isFeatured ?? false;
    isTrending = p?.isTrending ?? false;
    isRecommended = p?.isRecommended ?? false;
    isActive = p?.isActive ?? true;
  }

  @override
  void dispose() {
    productNameController.dispose();
    brandController.dispose();
    subCategoryController.dispose();
    descriptionController.dispose();
    ingredientsController.dispose();
    manufacturerController.dispose();
    countryOfOriginController.dispose();
    storageInstructionsController.dispose();
    mrpController.dispose();
    sellingPriceController.dispose();
    quantityController.dispose();
    stockController.dispose();
    minimumStockController.dispose();
    shelfLifeDaysController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  void _addImageUrl() {
    final url = imageUrlController.text.trim();
    if (url.isEmpty) return;
    if (!url.startsWith('http')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid URL')),
      );
      return;
    }
    setState(() {
      imageUrls.add(url);
      imageUrlController.clear();
    });
  }

  void _removeImageUrl(int index) {
    setState(() => imageUrls.removeAt(index));
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (imageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image URL')),
      );
      return;
    }

    if (selectedCategoryId == null || selectedCategoryName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final mrp = double.tryParse(mrpController.text.trim()) ?? 0;
    final sellingPrice = double.tryParse(sellingPriceController.text.trim()) ?? 0;

    if (sellingPrice > mrp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selling price cannot be greater than MRP'),
        ),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final product = ProductModel(
        id: widget.product?.id,
        productName: productNameController.text.trim(),
        brand: brandController.text.trim(),
        categoryId: selectedCategoryId!,
        categoryName: selectedCategoryName!,
        subCategory: subCategoryController.text.trim(),
        description: descriptionController.text.trim(),
        ingredients: ingredientsController.text.trim(),
        manufacturer: manufacturerController.text.trim(),
        countryOfOrigin: countryOfOriginController.text.trim(),
        storageInstructions: storageInstructionsController.text.trim(),
        mrp: mrp,
        sellingPrice: sellingPrice,
        quantity: double.tryParse(quantityController.text.trim()) ?? 0,
        unit: selectedUnit,
        stock: int.tryParse(stockController.text.trim()) ?? 0,
        minimumStock: int.tryParse(minimumStockController.text.trim()) ?? 0,
        shelfLifeDays: int.tryParse(shelfLifeDaysController.text.trim()) ?? 0,
        isPerishable: isPerishable,
        isFeatured: isFeatured,
        isTrending: isTrending,
        isRecommended: isRecommended,
        isActive: isActive,
        imageUrls: imageUrls,
        rating: widget.product?.rating ?? 0,
        reviewCount: widget.product?.reviewCount ?? 0,
        totalSold: widget.product?.totalSold ?? 0,
        createdAt: widget.product?.createdAt ?? Timestamp.now(),
      );

      if (isEditing) {
        await _service.updateProduct(product);
      } else {
        await _service.addProduct(product);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Product updated' : 'Product added'),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
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
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          isEditing ? 'Edit Product' : 'Add Product',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            _sectionCard(
              title: 'Images',
              children: [_buildImagesSection()],
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: 'Basic Information',
              children: [
                _textField(
                  controller: productNameController,
                  label: 'Product Name',
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 14),
                _textField(
                  controller: brandController,
                  label: 'Brand',
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 14),
                _buildCategoryDropdown(),
                const SizedBox(height: 14),
                _textField(
                  controller: subCategoryController,
                  label: 'Sub Category',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: 'Pricing & Stock',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _textField(
                        controller: mrpController,
                        label: 'MRP (₹)',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: _requiredValidator,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _textField(
                        controller: sellingPriceController,
                        label: 'Selling Price (₹)',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: _requiredValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _textField(
                        controller: quantityController,
                        label: 'Quantity',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: _requiredValidator,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _buildUnitDropdown()),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _textField(
                        controller: stockController,
                        label: 'Stock',
                        keyboardType: TextInputType.number,
                        validator: _requiredValidator,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _textField(
                        controller: minimumStockController,
                        label: 'Minimum Stock',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: 'Product Details',
              children: [
                _textField(
                  controller: descriptionController,
                  label: 'Description',
                  maxLines: 4,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 14),
                _textField(
                  controller: ingredientsController,
                  label: 'Ingredients',
                  maxLines: 3,
                ),
                const SizedBox(height: 14),
                _textField(
                  controller: manufacturerController,
                  label: 'Manufacturer',
                ),
                const SizedBox(height: 14),
                _textField(
                  controller: countryOfOriginController,
                  label: 'Country of Origin',
                ),
                const SizedBox(height: 14),
                _textField(
                  controller: storageInstructionsController,
                  label: 'Storage Instructions',
                  maxLines: 2,
                ),
                const SizedBox(height: 14),
                _textField(
                  controller: shelfLifeDaysController,
                  label: 'Shelf Life (Days)',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: 'Visibility & Flags',
              children: [
                _switchTile(
                  label: 'Perishable',
                  value: isPerishable,
                  onChanged: (v) => setState(() => isPerishable = v),
                ),
                _switchTile(
                  label: 'Featured',
                  value: isFeatured,
                  onChanged: (v) => setState(() => isFeatured = v),
                ),
                _switchTile(
                  label: 'Trending',
                  value: isTrending,
                  onChanged: (v) => setState(() => isTrending = v),
                ),
                _switchTile(
                  label: 'Recommended',
                  value: isRecommended,
                  onChanged: (v) => setState(() => isRecommended = v),
                ),
                _switchTile(
                  label: 'Active (visible to customers)',
                  value: isActive,
                  onChanged: (v) => setState(() => isActive = v),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: isSaving ? null : _saveProduct,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isSaving
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : Text(
              isEditing ? 'Update Product' : 'Add Product',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Reusable UI pieces ----------

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.poppins(fontSize: 13),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  Widget _switchTile({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      activeColor: Colors.green,
      title: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildUnitDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedUnit,
      decoration: InputDecoration(
        labelText: 'Unit',
        labelStyle: GoogleFonts.poppins(fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      items: unitOptions
          .map(
            (u) => DropdownMenuItem(
          value: u,
          child: Text(u, style: GoogleFonts.poppins(fontSize: 13)),
        ),
      )
          .toList(),
      onChanged: (v) {
        if (v != null) setState(() => selectedUnit = v);
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .orderBy('displayOrder')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            snapshot.error.toString(),
            style: const TextStyle(color: Colors.red),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("No categories found");
        }

        final docs = snapshot.data!.docs;

        // Guard against a selected category that no longer matches an
        // active category id (e.g. it was deactivated).


        return DropdownButtonFormField<String>(
          value: selectedCategoryId,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Category',
            labelStyle: GoogleFonts.poppins(fontSize: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          items: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return DropdownMenuItem(
              value: doc.id,
              child: Text(
                data['name'] ?? '',
                style: GoogleFonts.poppins(fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: (id) {
            if (id == null) return;
            final doc = docs.firstWhere((d) => d.id == id);
            final data = doc.data() as Map<String, dynamic>;
            setState(() {
              selectedCategoryId = id;
              selectedCategoryName = data['name'] ?? '';
            });
          },
          validator: (v) => v == null ? 'Please select a category' : null,
        );
      },
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: imageUrlController,
                style: GoogleFonts.poppins(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Paste imgbb image URL',
                  hintStyle: GoogleFonts.poppins(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                onFieldSubmitted: (_) => _addImageUrl(),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              width: 48,
              child: ElevatedButton(
                onPressed: _addImageUrl,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (imageUrls.isEmpty)
          Text(
            'No images added yet',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(imageUrls.length, (index) {
              final url = imageUrls[index];
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: GestureDetector(
                      onTap: () => _removeImageUrl(index),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
      ],
    );
  }
}
