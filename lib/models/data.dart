class Demo {
  late String transactionId;
  late String time;
}

List<Demo> transaction() {
  Demo transac = Demo();
  transac.transactionId = "1492948";
  transac.time = "18/02/2023";
  Demo transac1 = Demo();
  transac1.transactionId = "4837485";
  transac1.time = "16/05/2023";
  Demo transac2 = Demo();
  transac2.transactionId = "3290482";
  transac2.time = "27/03/2023";
  Demo transac3 = Demo();
  transac3.transactionId = "0238847";
  transac3.time = "01/08/2023";
  return [transac, transac1, transac2, transac3];
}

class Invoice {
  String? orderId;
  String? date;
  String? custusr;
  String? prodname;
  String? price;
  String? quantity;
  String? subtotal;
}

List<Invoice> invoice() {
  Invoice invoice = Invoice();
  invoice.orderId = "48294710";
  invoice.date = "16/07/2020";
  invoice.custusr = "Azim";
  invoice.prodname = "Arabic Bean 100g";
  invoice.price = "75.00";
  invoice.quantity = "2";
  // invoice.subtotal = "200.00";
  Invoice invoice1 = Invoice();
  invoice1.prodname = "Italian Bean 100g";
  invoice1.price = "80.00";
  invoice1.quantity = "3";
  // invoice1.subtotal = "150.00";
  Invoice invoice2 = Invoice();
  invoice2.prodname = "Vietnam Bean 100g";
  invoice2.price = "70.00";
  invoice2.quantity = "3";
  // invoice2.subtotal = "210.00";
  return [invoice, invoice1, invoice2];
}

class Product {
  String? prodId;
  String? prodName;
  String? prodImage;
  String? prodPrice;
}
