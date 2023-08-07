import 'package:pointofsales/models/pos_model.dart';

class InvoiceData {
  final int taxId;
  final double taxAmount;
  final double netPrice;
  final double grossPrice;
  final int discountId;
  final double discountAmount;
  final List<PaymentType> paymentType;
  final List<ItemsArray> searchResult;
  final String remark;

  InvoiceData({
    required this.taxId,
    required this.taxAmount,
    required this.netPrice,
    required this.grossPrice,
    required this.paymentType,
    required this.discountId,
    required this.discountAmount,
    required this.searchResult,
    required this.remark,
  });
}
