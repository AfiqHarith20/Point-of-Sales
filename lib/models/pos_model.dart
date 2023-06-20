class Pos {
  final int merchantId;
  final int userId;
  final String userName;
  final String userEmail;
  final String companyName;
  final List<dynamic> products;
  final List<PaymentType> paymentType;
  final List<PaymentType> paymentTypeName;
  final List<PaymentTax> paymentTax;
  final List<PaymentTax> paymentTaxPercent;
  final List<PaymentTax> paymentTaxName;


  Pos({
    required this.merchantId,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.companyName,
    required this.products,
    required this.paymentType,
    required this.paymentTax,
    required this.paymentTypeName,
    required this.paymentTaxPercent, 
    required this.paymentTaxName,
  });
}

class ProductPos {
  final String sku;
  final String name;
  final String summary;
  final String details;
  final String categoryId;
  final String price;
  final String quantity;

  ProductPos({
    required this.sku,
    required this.name,
    required this.summary,
    required this.details,
    required this.categoryId,
    required this.price,
    required this.quantity,
  });
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
}

class PaymentType {
  final int id;
  final String name;

  PaymentType({
    required this.id,
    required this.name,
  });
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
  final String paymentType;
  final String remarks;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;
  final int status;
  final int createdBy;
  final int updatedBy;

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
    required this.paymentType,
    required this.remarks,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.status,
    required this.createdBy,
    required this.updatedBy,
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
  final String quantity;
  final String price;

  ItemsArray({
    required this.productId,
    required this.quantity,
    required this.price,
  });
}
