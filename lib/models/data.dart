class Demo {
  late String transactionId;
  late String time;
}

List<Demo> transaction() {
  Demo transac = Demo();
  transac.transactionId = "1492948";
  transac.time = "18/02/2023";
  Demo transac1 = Demo();
  transac1.transactionId = "483748294";
  transac1.time = "16/05/2023";
  Demo transac2 = Demo();
  transac2.transactionId = "329048534";
  transac2.time = "27/03/2023";
  Demo transac3 = Demo();
  transac3.transactionId = "0238849847";
  transac3.time = "01/08/2023";
  return [transac, transac1, transac2, transac3];
}

class Invoice {
  late String orderId;
  late String date;
  late String custusr;
  late String prodname;
  late String price;
  late int quantity;
  late String subtotal;
}

List<Invoice> invoice() {
  Invoice invoice = Invoice();
  invoice.orderId = "48294710";
  invoice.date = "16/07/2020";
  invoice.custusr = "Azim";
  invoice.prodname = "Arabic Bean 100g";
  invoice.price = "100.00";
  invoice.quantity = 2;
  invoice.subtotal = "200.00";
  invoice.prodname = "Italian Bean 100g";
  invoice.price = "50.00";
  invoice.quantity = 3;
  invoice.subtotal = "150.00";
  invoice.prodname = "Vietnam Bean 100g";
  invoice.price = "70.00";
  invoice.quantity = 3;
  invoice.subtotal = "210.00";
  return [invoice];
}
