import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _wishlist {
    return _firestore
        .collection("users")
        .doc(_uid)
        .collection("wishlist");
  }

  // ==========================
  // ADD / REMOVE WISHLIST
  // ==========================

  Future<void> toggleWishlist(String productId) async {
    final doc = _wishlist.doc(productId);

    if ((await doc.get()).exists) {
      await doc.delete();
    } else {
      await doc.set({
        "addedAt": Timestamp.now(),
      });
    }
  }

  // ==========================
  // CHECK SINGLE PRODUCT
  // ==========================

  Stream<bool> isWishlisted(String productId) {
    return _wishlist.doc(productId).snapshots().map(
          (doc) => doc.exists,
    );
  }

  // ==========================
  // GET ALL PRODUCT IDS
  // ==========================

  Stream<List<String>> wishlistIds() {
    return _wishlist.snapshots().map(
          (snapshot) =>
          snapshot.docs.map((doc) => doc.id).toList(),
    );
  }

  // ==========================
  // GET COMPLETE WISHLIST
  // ==========================

  Stream<QuerySnapshot<Map<String, dynamic>>> wishlistStream() {
    return _wishlist.snapshots();
  }

  // ==========================
  // REMOVE PRODUCT
  // ==========================

  Future<void> removeFromWishlist(String productId) async {
    await _wishlist.doc(productId).delete();
  }
}