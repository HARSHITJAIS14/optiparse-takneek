class Transaction {
  final String merchantName;
  final String merchantId;
  final String address;
  final String phoneNumber;
  final String fax;
  final String invoiceNumber;
  final String gstRegistrationNumber;
  final double gstPercentage;
  final String date;
  final String month;
  final int year;
  final String time;
  final String financialDocumentClass;
  final String itemType;
  final double totalAmount;
  final String cashierName;
  final String customerName;
  final int numberOfItems;

  Transaction({
    required this.merchantName,
    required this.merchantId,
    required this.address,
    required this.phoneNumber,
    required this.fax,
    required this.invoiceNumber,
    required this.gstRegistrationNumber,
    required this.gstPercentage,
    required this.date,
    required this.month,
    required this.year,
    required this.time,
    required this.financialDocumentClass,
    required this.itemType,
    required this.totalAmount,
    required this.cashierName,
    required this.customerName,
    required this.numberOfItems,
  });

  factory Transaction.fromJson(List<dynamic> json) {
    return Transaction(
      merchantName: json[1],
      merchantId: json[2],
      address: json[3],
      phoneNumber: json[4],
      fax: json[5],
      invoiceNumber: json[6],
      gstRegistrationNumber: json[7],
      gstPercentage: json[8].toDouble(),
      date: json[9],
      month: json[10],
      year: json[11],
      time: json[12],
      financialDocumentClass: json[13],
      itemType: json[14],
      totalAmount: json[15].toDouble(),
      cashierName: json[16],
      customerName: json[17],
      numberOfItems: json[18],
    );
  }
}
