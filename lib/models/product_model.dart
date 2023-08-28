import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  final List<ProductElement> products;

  Product({
    required this.products,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        products: List<ProductElement>.from(
            json["products"].map((x) => ProductElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class ProductElement {
  final int id;
  final String merchantId;
  final String sku;
  final String name;
  final String summary;
  final String categoryId;
  final String price;
  final String mainImage;
  final Category category;

  ProductElement({
    required this.id,
    required this.merchantId,
    required this.sku,
    required this.name,
    required this.summary,
    required this.categoryId,
    required this.price,
    required this.mainImage,
    required this.category,
  });

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
        id: json["id"],
        merchantId: json["merchant_id"],
        sku: json["sku"],
        name: json["name"],
        summary: json["summary"],
        categoryId: json["category_id"],
        price: json["price"],
        mainImage: json["main_image"],
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "merchant_id": merchantId,
        "sku": sku,
        "name": name,
        "summary": summary,
        "category_id": categoryId,
        "price": price,
        "main_image": mainImage,
        "category": category.toJson(),
      };
}

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}