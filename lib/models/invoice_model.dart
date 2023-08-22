import 'dart:convert';

InvoiceData invoiceDataFromJson(String str) =>
    InvoiceData.fromJson(json.decode(str));

String invoiceDataToJson(InvoiceData data) => json.encode(data.toJson());

class InvoiceData {
  final PosTrans posTrans;

  InvoiceData({
    required this.posTrans,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
        posTrans: PosTrans.fromJson(json["pos_trans"]),
      );

  Map<String, dynamic> toJson() => {
        "pos_trans": posTrans.toJson(),
      };
}

class PosTrans {
  final int id;
  final String merchantId;
  final String customerId;
  final String posTxnNo;
  final String grossPrice;
  final String taxId;
  final String taxAmount;
  final dynamic discId;
  final String discAmount;
  final String netPrice;
  final String paymentType;
  final String remarks;
  final String status;
  final String custEmail;
  final String isReceipt;

  PosTrans({
    required this.id,
    required this.merchantId,
    required this.customerId,
    required this.posTxnNo,
    required this.grossPrice,
    required this.taxId,
    required this.taxAmount,
    required this.discId,
    required this.discAmount,
    required this.netPrice,
    required this.paymentType,
    required this.remarks,
    required this.status,
    required this.custEmail,
    required this.isReceipt,
  });

  factory PosTrans.fromJson(Map<String, dynamic> json) => PosTrans(
        id: json["id"],
        merchantId: json["merchant_id"],
        customerId: json["customer_id"],
        posTxnNo: json["pos_txn_no"],
        grossPrice: json["gross_price"],
        taxId: json["tax_id"],
        taxAmount: json["tax_amount"],
        discId: json["disc_id"],
        discAmount: json["disc_amount"],
        netPrice: json["net_price"],
        paymentType: json["payment_type"],
        remarks: json["remarks"],
        status: json["status"],
        custEmail: json["cust_email"],
        isReceipt: json["is_receipt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "merchant_id": merchantId,
        "customer_id": customerId,
        "pos_txn_no": posTxnNo,
        "gross_price": grossPrice,
        "tax_id": taxId,
        "tax_amount": taxAmount,
        "disc_id": discId,
        "disc_amount": discAmount,
        "net_price": netPrice,
        "payment_type": paymentType,
        "remarks": remarks,
        "status": status,
        "cust_email": custEmail,
        "is_receipt": isReceipt,
      };
}
