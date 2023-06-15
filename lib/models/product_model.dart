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

class Product {
  final String sku;
  final String name;
  final String summary;
  final String details;
  final String categoryId;
  final String price;
  final String quantity;

  Product({
    required this.sku,
    required this.name,
    required this.summary,
    required this.details,
    required this.categoryId,
    required this.price,
    required this.quantity,
  });
}


