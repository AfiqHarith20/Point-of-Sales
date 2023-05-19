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
  return [transac, transac1];
}
