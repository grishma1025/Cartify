import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? id;

  final String productName;
  final String brand;

  final String categoryId;
  final String categoryName;
  final String subCategory;

  final String description;
  final String ingredients;
  final String manufacturer;
  final String countryOfOrigin;
  final String storageInstructions;

  final double mrp;
  final double sellingPrice;

  final double quantity;
  final String unit;

  final int stock;
  final int minimumStock;

  final int shelfLifeDays;

  final bool isPerishable;
  final bool isFeatured;
  final bool isTrending;
  final bool isRecommended;
  final bool isActive;

  final List<String> imageUrls;

  final double rating;
  final int reviewCount;
  final int totalSold;

  final Timestamp createdAt;

  const ProductModel({
    this.id,
    required this.productName,
    required this.brand,
    required this.categoryId,
    required this.categoryName,
    required this.subCategory,
    required this.description,
    required this.ingredients,
    required this.manufacturer,
    required this.countryOfOrigin,
    required this.storageInstructions,
    required this.mrp,
    required this.sellingPrice,
    required this.quantity,
    required this.unit,
    required this.stock,
    required this.minimumStock,
    required this.shelfLifeDays,
    required this.isPerishable,
    required this.isFeatured,
    required this.isTrending,
    required this.isRecommended,
    required this.isActive,
    required this.imageUrls,
    required this.rating,
    required this.reviewCount,
    required this.totalSold,
    required this.createdAt,
  });

  double get discountPercentage {
    if (mrp <= 0) return 0;
    return ((mrp - sellingPrice) / mrp) * 100;
  }

  Map<String, dynamic> toMap() {
    return {
      "productName": productName,
      "brand": brand,
      "categoryId": categoryId,
      "categoryName": categoryName,
      "subCategory": subCategory,
      "description": description,
      "ingredients": ingredients,
      "manufacturer": manufacturer,
      "countryOfOrigin": countryOfOrigin,
      "storageInstructions": storageInstructions,
      "mrp": mrp,
      "sellingPrice": sellingPrice,
      "quantity": quantity,
      "unit": unit,
      "stock": stock,
      "minimumStock": minimumStock,
      "shelfLifeDays": shelfLifeDays,
      "isPerishable": isPerishable,
      "isFeatured": isFeatured,
      "isTrending": isTrending,
      "isRecommended": isRecommended,
      "isActive": isActive,
      "imageUrls": imageUrls,
      "rating": rating,
      "reviewCount": reviewCount,
      "totalSold": totalSold,
      "createdAt": createdAt,
      "searchKeywords": _keywords(productName),
    };
  }

  factory ProductModel.fromDocument(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      productName: d["productName"] ?? "",
      brand: d["brand"] ?? "",
      categoryId: d["categoryId"] ?? "",
      categoryName: d["categoryName"] ?? "",
      subCategory: d["subCategory"] ?? "",
      description: d["description"] ?? "",
      ingredients: d["ingredients"] ?? "",
      manufacturer: d["manufacturer"] ?? "",
      countryOfOrigin: d["countryOfOrigin"] ?? "",
      storageInstructions: d["storageInstructions"] ?? "",
      mrp: (d["mrp"] ?? 0).toDouble(),
      sellingPrice: (d["sellingPrice"] ?? 0).toDouble(),
      quantity: (d["quantity"] ?? 0).toDouble(),
      unit: d["unit"] ?? "pcs",
      stock: d["stock"] ?? 0,
      minimumStock: d["minimumStock"] ?? 0,
      shelfLifeDays: d["shelfLifeDays"] ?? 0,
      isPerishable: d["isPerishable"] ?? false,
      isFeatured: d["isFeatured"] ?? false,
      isTrending: d["isTrending"] ?? false,
      isRecommended: d["isRecommended"] ?? false,
      isActive: d["isActive"] ?? true,
      imageUrls: List<String>.from(d["imageUrls"] ?? []),
      rating: (d["rating"] ?? 0).toDouble(),
      reviewCount: d["reviewCount"] ?? 0,
      totalSold: d["totalSold"] ?? 0,
      createdAt: d["createdAt"] ?? Timestamp.now(),
    );
  }

  static List<String> _keywords(String name) {
    final words = name.toLowerCase().trim().split(RegExp(r'\s+'));
    final set = <String>{};
    for (var w in words) {
      set.add(w);
    }
    for (int i = 0; i < words.length - 1; i++) {
      set.add("${words[i]} ${words[i+1]}");
    }
    return set.toList();
  }
}
