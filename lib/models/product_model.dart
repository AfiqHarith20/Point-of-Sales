import 'dart:convert';
class ProductMerch {
  final int merchantId;
  final int userId;
  final String userName;
  final String userEmail;
  final String companyName;
  final List<dynamic> products;

  ProductMerch({
    required this.merchantId,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.companyName,
    required this.products,
  });
}

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
  final List<ProductDetail> products;

  Products({
    required this.products,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        products: List<ProductDetail>.from(
            json["products"].map((x) => ProductDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class ProductDetail {
  final int id;
  final String sku;
  final String name;
  final String summary;
  final String details;
  final int categoryId;
  final double price;
  final int quantity;
  final dynamic isSearch;
  final dynamic ispromo;
  final dynamic promoPrice;
  final dynamic promoStartdate;
  final dynamic promoEnddate;
  final dynamic stock;
  final int status;
  final dynamic mainImage;
  final ProductCategory productCategory;

  ProductDetail({
    required this.id,
    required this.sku,
    required this.name,
    required this.summary,
    required this.details,
    required this.categoryId,
    required this.price,
    required this.quantity,
    this.isSearch,
    this.ispromo,
    this.promoPrice,
    this.promoStartdate,
    this.promoEnddate,
    this.stock,
    required this.status,
    this.mainImage,
    required this.productCategory,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        id: json["id"],
        sku: json["sku"],
        name: json["name"],
        summary: json["summary"],
        details: json["details"],
        categoryId: json["category_id"],
        price: json["price"]?.toDouble(),
        quantity: json["quantity"],
        isSearch: json["isSearch"],
        ispromo: json["ispromo"],
        promoPrice: json["promo_price"],
        promoStartdate: json["promo_startdate"],
        promoEnddate: json["promo_enddate"],
        stock: json["stock"],
        status: json["status"],
        mainImage: json["main_image"],
        productCategory: ProductCategory.fromJson(json["product_category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sku": sku,
        "name": name,
        "summary": summary,
        "details": details,
        "category_id": categoryId,
        "price": price,
        "quantity": quantity,
        "isSearch": isSearch,
        "ispromo": ispromo,
        "promo_price": promoPrice,
        "promo_startdate": promoStartdate,
        "promo_enddate": promoEnddate,
        "stock": stock,
        "status": status,
        "main_image": mainImage,
        "product_category": productCategory.toJson(),
      };
}

class ProductCategory {
  final int id;
  final String name;
  final int status;

  ProductCategory({
    required this.id,
    required this.name,
    required this.status,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        id: json["id"],
        name: json["name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
      };
}


