
import 'package:cartify/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _products => _db.collection('products');

  Future<void> addProduct(ProductModel product) async {
    await _products.add(product.toMap());
  }

  Future<void> updateProduct(ProductModel product) async {
    if (product.id == null) {
      throw Exception("Product id is null.");
    }
    await _products.doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    await _products.doc(productId).delete();
  }

  Stream<List<ProductModel>> getProducts() {
    return _products
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ProductModel.fromDocument(doc))
        .toList());
  }

  Stream<List<ProductModel>> getProductsByCategory(String categoryId) {

    print("==================================");
    print("Selected Category ID: $categoryId");

    return _products
        .where('categoryId', isEqualTo: categoryId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {

      print("Products Found: ${snapshot.docs.length}");

      for (var doc in snapshot.docs) {
        print(doc["productName"]);
      }

      return snapshot.docs
          .map((doc) => ProductModel.fromDocument(doc))
          .toList();
    });
  }

  Stream<List<ProductModel>> getFeaturedProducts() {
    return _products
        .where('isFeatured', isEqualTo: true)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ProductModel.fromDocument(doc))
        .toList());
  }

  Future<void> updateStock({
    required String productId,
    required int stock,
  }) async {
    await _products.doc(productId).update({
      'stock': stock,
    });
  }

  Future<void> toggleFeatured(String productId, bool value) async {
    await _products.doc(productId).update({
      'isFeatured': value,
    });
  }

  Future<void> toggleTrending(String productId, bool value) async {
    await _products.doc(productId).update({
      'isTrending': value,
    });
  }

  Future<void> toggleRecommended(String productId, bool value) async {
    await _products.doc(productId).update({
      'isRecommended': value,
    });
  }

  Future<void> toggleActive(String productId, bool value) async {
    await _products.doc(productId).update({
      'isActive': value,
    });
  }

  Future<List<ProductModel>> searchProducts(String keyword) async {
    final key = keyword.toLowerCase().trim();

    final snapshot = await _products
        .where('searchKeywords', arrayContains: key)
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromDocument(doc))
        .toList();
  }
  Future<ProductModel?> getProductById(String productId) async {

    final doc = await _products.doc(productId).get();

    if (!doc.exists) {
      return null;
    }

    return ProductModel.fromDocument(doc);
  }
}
