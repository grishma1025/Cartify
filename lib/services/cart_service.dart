import 'package:cartify/models/cart_item_model.dart';
import 'package:cartify/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _cartItems {
    return _firestore
        .collection("users")
        .doc(_uid)
        .collection("cart");
  }

  /// ADD PRODUCT

  Future<void> addToCart(
      ProductModel product, {
        bool isSuggested = false,
        String suggestionReason = "",
      }) async {
    final doc = _cartItems.doc(product.id);

    final snapshot = await doc.get();

    if (snapshot.exists) {
      final data = snapshot.data()!;

      final qty = data["cartQuantity"] ?? 1;

      await doc.update({
        "cartQuantity": qty + 1,
        "updatedAt": Timestamp.now(),
      });
    } else {
      final item = CartItemModel.fromProduct(
        product,
        isSuggested: isSuggested,
        suggestionReason: suggestionReason,
      );

      await doc.set(item.toMap());
    }
  }

  /// REMOVE COMPLETELY

  Future<void> removeItem(String productId) async {
    await _cartItems.doc(productId).delete();
  }

  /// INCREASE

  Future<void> increaseQuantity(String productId) async {
    final doc = _cartItems.doc(productId);

    final data = (await doc.get()).data();

    if (data == null) return;

    await doc.update({
      "cartQuantity": data["cartQuantity"] + 1,
      "updatedAt": Timestamp.now(),
    });
  }

  /// DECREASE

  Future<void> decreaseQuantity(String productId) async {
    final doc = _cartItems.doc(productId);

    final data = (await doc.get()).data();

    if (data == null) return;

    final qty = data["cartQuantity"];

    if (qty <= 1) {
      await doc.delete();
    } else {
      await doc.update({
        "cartQuantity": qty - 1,
        "updatedAt": Timestamp.now(),
      });
    }
  }

  /// CLEAR CART

  Future<void> clearCart() async {
    final snapshot = await _cartItems.get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  /// STREAM CART ITEMS

  Stream<List<CartItemModel>> cartItems() {
    return _cartItems.snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => CartItemModel.fromDocument(doc))
          .toList(),
    );
  }

  /// TOTAL ITEMS

  Stream<int> cartCount() {
    return _cartItems.snapshots().map(
          (snapshot) => snapshot.docs.fold(
        0,
            (sum, doc) =>
        sum + ((doc.data()["cartQuantity"] ?? 0) as int),
      ),
    );
  }
}