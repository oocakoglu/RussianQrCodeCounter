class DrugBarcode {
  final String barcode;
  final String drugName;
  int total;
  //DateTime? lastUpdate;

  DrugBarcode(
      {required this.barcode, required this.drugName, required this.total}) {
    //lastUpdate = DateTime.now();
  }

  factory DrugBarcode.fromJson(Map<String, dynamic> json) {
    try {
      DrugBarcode sym = DrugBarcode(
          barcode: json['barcode'] as String,
          drugName: json['drugName'] as String,
          total: json['total'] as int);
      return sym;
    } catch (e) {
      return DrugBarcode(barcode: "barcode", drugName: "drugName", total: 1);
    }
  }

  Map<String, dynamic> toJson() =>
      {'barcode': barcode, 'drugName': drugName, 'total': total};
}
