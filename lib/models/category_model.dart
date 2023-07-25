import 'dart:convert';

ProductCategory productCategoryFromJson(String str) =>
    ProductCategory.fromJson(json.decode(str));

String productCategoryToJson(ProductCategory data) =>
    json.encode(data.toJson());

class ProductCategory {
  final Data data;

  ProductCategory({
    required this.data,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  final List<Category> category;

  Data({
    required this.category,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        category: List<Category>.from(
            json["category"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category": List<dynamic>.from(category.map((x) => x.toJson())),
      };
}

class Category {
  final int id;
  final String name;
  final int status;
  final List<ProductList> productList;

  Category({
    required this.id,
    required this.name,
    required this.status,
    required this.productList,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        productList: List<ProductList>.from(
            json["product_list"].map((x) => ProductList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "product_list": List<dynamic>.from(productList.map((x) => x.toJson())),
      };
}

class ProductList {
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
  final String? mainImage;
  final int merchantId;

  ProductList({
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
    required this.merchantId,

  });

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
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
        merchantId: json["merchant_id"],
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
        "merchant_id": merchantId,
      };
}
