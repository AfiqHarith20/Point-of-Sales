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
