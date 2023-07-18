import 'dart:convert';

Pos posFromJson(String str) => Pos.fromJson(json.decode(str));

String posToJson(Pos data) => json.encode(data.toJson());

class Pos {
  final List<Datum> data;
  final List<PaymentType> paymentType;
  final List<PaymentTax> paymentTax;

  Pos({
    required this.data,
    required this.paymentType,
    required this.paymentTax,
  });

  factory Pos.fromJson(Map<String, dynamic> json) => Pos(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        paymentType: List<PaymentType>.from(
            json["payment_type"].map((x) => PaymentType.fromJson(x))),
        paymentTax: List<PaymentTax>.from(
            json["payment_tax"].map((x) => PaymentTax.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "payment_type": List<dynamic>.from(paymentType.map((x) => x.toJson())),
        "payment_tax": List<dynamic>.from(paymentTax.map((x) => x.toJson())),
      };
}

class Datum {
  final int merchantId;
  final int userId;
  final User user;
  final Merchant merchant;
  final List<Product> products;
  final List<dynamic> customers;

  Datum({
    required this.merchantId,
    required this.userId,
    required this.user,
    required this.merchant,
    required this.products,
    required this.customers,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        merchantId: json["merchant_id"],
        userId: json["user_id"],
        user: User.fromJson(json["user"]),
        merchant: Merchant.fromJson(json["merchant"]),
        products: List<Product>.from(json["products"].map((x) => x)),
        customers: List<dynamic>.from(json["customers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "merchant_id": merchantId,
        "user_id": userId,
        "user": user.toJson(),
        "merchant": merchant.toJson(),
        "products": List<dynamic>.from(products.map((x) => x)),
        "customers": List<dynamic>.from(customers.map((x) => x)),
      };
}

class Merchant {
  final int id;
  final String companyName;
  final dynamic logoUrl;

  Merchant({
    required this.id,
    required this.companyName,
    this.logoUrl,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
        id: json["id"],
        companyName: json["company_name"],
        logoUrl: json["logo_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "logo_url": logoUrl,
      };
}

class User {
  final int userid;
  final String username;
  final String useremail;

  User({
    required this.userid,
    required this.username,
    required this.useremail,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userid: json["id"],
        username: json["name"],
        useremail: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": userid,
        "name": username,
        "email": useremail,
      };
}

Payment paymentFromJson(String str) => Payment.fromJson(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toJson());

class Payment {
  final List<PaymentType> paymentType;
  final List<PaymentTax> paymentTax;

  Payment({
    required this.paymentType,
    required this.paymentTax,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        paymentType: List<PaymentType>.from(
            json["payment_type"].map((x) => PaymentType.fromJson(x))),
        paymentTax: List<PaymentTax>.from(
            json["payment_tax"].map((x) => PaymentTax.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "payment_type": List<dynamic>.from(paymentType.map((x) => x.toJson())),
        "payment_tax": List<dynamic>.from(paymentTax.map((x) => x.toJson())),
      };
}

class PaymentTax {
  final int id;
  final String name;
  final int taxPercentage;

  PaymentTax({
    required this.id,
    required this.name,
    required this.taxPercentage,
  });

  factory PaymentTax.fromJson(Map<String, dynamic> json) => PaymentTax(
        id: json["id"],
        name: json["name"],
        taxPercentage: json["tax_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tax_percentage": taxPercentage,
      };
}

class PaymentType {
  final int id;
  final String name;

  PaymentType({
    required this.id,
    required this.name,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
        id: json["id"],
        name: json["name"],
      );


  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Customer {
  final int merchantId;
  final String customerId;
  final String posTxnNo;
  final String grossPrice;
  final dynamic taxId;
  final dynamic taxAmount;
  final dynamic discId;
  final dynamic discAmount;
  final String netPrice;
  final String paymentTypes;
  final String remarks;
  // final DateTime updatedAt;
  // final DateTime createdAt;
  final int id;
  final int status;
  // final int createdBy;
  // final int updatedBy;

  Customer({
    required this.merchantId,
    required this.customerId,
    required this.posTxnNo,
    required this.grossPrice,
    this.taxId,
    this.taxAmount,
    this.discId,
    this.discAmount,
    required this.netPrice,
    required this.paymentTypes,
    required this.remarks,
    // required this.updatedAt,
    // required this.createdAt,
    required this.id,
    required this.status,
    // required this.createdBy,
    // required this.updatedBy,
  });
}

class Items {
  final String customerId;
  final String grossPrice;
  final String taxId;
  final String taxAmount;
  final String discId;
  final String discAmount;
  final String netPrice;
  final String paymentType;
  final String remarks;
  final List<ItemsArray> itemsArray;

  Items({
    required this.customerId,
    required this.grossPrice,
    required this.taxId,
    required this.taxAmount,
    required this.discId,
    required this.discAmount,
    required this.netPrice,
    required this.paymentType,
    required this.remarks,
    required this.itemsArray,
  });
}

class ItemsArray {
  final String productId;
  final String name;
  String? quantity;
  final String price;

  ItemsArray({
    required this.productId,
    required this.name,
    this.quantity,
    required this.price,
  });
}

class Product {
  final int id;
  final int merchantId;
  final String sku;
  final String name;
  final String summary;
  final int categoryId;
  final double price;
  final dynamic mainImage;
  final ProductCategory productCategory;

  Product({
    required this.id,
    required this.merchantId,
    required this.sku,
    required this.name,
    required this.summary,
    required this.categoryId,
    required this.price,
    this.mainImage,
    required this.productCategory,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        merchantId: json["merchant_id"],
        sku: json["sku"],
        name: json["name"],
        summary: json["summary"],
        categoryId: json["category_id"],
        price: json["price"]?.toDouble(),
        mainImage: json["main_image"],
        productCategory: ProductCategory.fromJson(json["product_category"]),
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
        "product_category": productCategory.toJson(),
      };
}

class ProductCategory {
  final int catid;
  final String catname;

  ProductCategory({
    required this.catid,
    required this.catname,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        catid: json["id"],
        catname: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": catid,
        "name": catname,
      };
}

