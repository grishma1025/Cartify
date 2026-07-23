import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cartify/models/product_model.dart';

class CartItemModel {
  final String productId;
  final String productName;
  final String brand;

  final String imageUrl;

  final double mrp;
  final double sellingPrice;

  final double quantity;
  final String unit;

  final int cartQuantity;

  final bool isSuggested;
  final String suggestionReason;

  final Timestamp addedAt;
  final Timestamp updatedAt;

  const CartItemModel({
    required this.productId,
    required this.productName,
    required this.brand,
    required this.imageUrl,
    required this.mrp,
    required this.sellingPrice,
    required this.quantity,
    required this.unit,
    required this.cartQuantity,
    required this.isSuggested,
    required this.suggestionReason,
    required this.addedAt,
    required this.updatedAt,
  });

  /// Create Cart Item from Product
  factory CartItemModel.fromProduct(
      ProductModel product, {
        int cartQuantity = 1,
        bool isSuggested = false,
        String suggestionReason = "",
      }) {
    return CartItemModel(
      productId: product.id!,
      productName: product.productName,
      brand: product.brand,
      imageUrl:
      product.imageUrls.isEmpty ? "" : product.imageUrls.first,
      mrp: product.mrp,
      sellingPrice: product.sellingPrice,
      quantity: product.quantity,
      unit: product.unit,
      cartQuantity: cartQuantity,
      isSuggested: isSuggested,
      suggestionReason: suggestionReason,
      addedAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "productId": productId,
      "productName": productName,
      "brand": brand,
      "imageUrl": imageUrl,
      "mrp": mrp,
      "sellingPrice": sellingPrice,
      "quantity": quantity,
      "unit": unit,
      "cartQuantity": cartQuantity,
      "isSuggested": isSuggested,
      "suggestionReason": suggestionReason,
      "addedAt": addedAt,
      "updatedAt": updatedAt,
    };
  }

  factory CartItemModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CartItemModel(
      productId: data["productId"],
      productName: data["productName"],
      brand: data["brand"],
      imageUrl: data["imageUrl"],
      mrp: (data["mrp"] as num).toDouble(),
      sellingPrice: (data["sellingPrice"] as num).toDouble(),
      quantity: (data["quantity"] as num).toDouble(),
      unit: data["unit"],
      cartQuantity: data["cartQuantity"],
      isSuggested: data["isSuggested"] ?? false,
      suggestionReason: data["suggestionReason"] ?? "",
      addedAt: data["addedAt"] ?? Timestamp.now(),
      updatedAt: data["updatedAt"] ?? Timestamp.now(),
    );
  }

  CartItemModel copyWith({
    int? cartQuantity,
    bool? isSuggested,
    String? suggestionReason,
  }) {
    return CartItemModel(
      productId: productId,
      productName: productName,
      brand: brand,
      imageUrl: imageUrl,
      mrp: mrp,
      sellingPrice: sellingPrice,
      quantity: quantity,
      unit: unit,
      cartQuantity: cartQuantity ?? this.cartQuantity,
      isSuggested: isSuggested ?? this.isSuggested,
      suggestionReason:
      suggestionReason ?? this.suggestionReason,
      addedAt: addedAt,
      updatedAt: Timestamp.now(),
    );
  }

  double get totalPrice =>
      sellingPrice * cartQuantity;

  double get totalMrp =>
      mrp * cartQuantity;

  double get totalSaving =>
      (mrp - sellingPrice) * cartQuantity;
}