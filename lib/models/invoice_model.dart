import 'dart:convert';

InvoiceData invoiceDataFromJson(String str) =>
    InvoiceData.fromJson(json.decode(str));

String invoiceDataToJson(InvoiceData data) => json.encode(data.toJson());

class InvoiceData {
  final List<PosTran> posTrans;

  InvoiceData({
    required this.posTrans,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
        posTrans: List<PosTran>.from(
            json["pos_trans"].map((x) => PosTran.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pos_trans": List<dynamic>.from(posTrans.map((x) => x.toJson())),
      };
}

class PosTran {
  final int id;
  final String merchantId;
  final String posTxnNo;
  final String netPrice;
  final PaymentType paymentType;
  final String custEmail;
  final List<PosDetail> itemsArray;
  final Merchant merchant;

  PosTran({
    required this.id,
    required this.merchantId,
    required this.posTxnNo,
    required this.netPrice,
    required this.paymentType,
    required this.custEmail,
    required this.itemsArray,
    required this.merchant,
  });

  factory PosTran.fromJson(Map<String, dynamic> json) => PosTran(
        id: json["id"],
        merchantId: json["merchant_id"],
        posTxnNo: json["pos_txn_no"],
        netPrice: json["net_price"],
        paymentType: PaymentType.fromJson(json["payment_type"]),
        custEmail: json["cust_email"],
        itemsArray: List<PosDetail>.from(
            json["pos_details"].map((x) => PosDetail.fromJson(x))),
        merchant: Merchant.fromJson(json["merchant"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "merchant_id": merchantId,
        "pos_txn_no": posTxnNo,
        "net_price": netPrice,
        "payment_type": paymentType.toJson(),
        "cust_email": custEmail,
        "pos_details": List<dynamic>.from(itemsArray.map((x) => x.toJson())),
        "merchant": merchant.toJson(),
      };
}

class Merchant {
  final int id;
  final String companyName;
  final String logoUrl;

  Merchant({
    required this.id,
    required this.companyName,
    required this.logoUrl,
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

class PaymentType {
  final int id;
  final String name;
  final String description;

  PaymentType({
    required this.id,
    required this.name,
    required this.description,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}

class PosDetail {
  final int id;
  final String posId;
  final String productId;
  final String quantity;
  final String price;
  final Product product;

  PosDetail({
    required this.id,
    required this.posId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.product,
  });

  factory PosDetail.fromJson(Map<String, dynamic> json) => PosDetail(
        id: json["id"],
        posId: json["pos_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        price: json["price"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pos_id": posId,
        "product_id": productId,
        "quantity": quantity,
        "price": price,
        "product": product.toJson(),
      };
}

class Product {
  final int id;
  final String sku;
  final String name;
  final String summary;
  final String categoryId;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.summary,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        sku: json["sku"],
        name: json["name"],
        summary: json["summary"],
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sku": sku,
        "name": name,
        "summary": summary,
        "category_id": categoryId,
      };
}
