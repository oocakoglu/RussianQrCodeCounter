class Drug {
  final String barcode;
  final String drugName;

  Drug({required this.barcode, required this.drugName}) {
    //lastUpdate = DateTime.now();
  }

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
        barcode: json['barcode'] as String,
        drugName: json['drugName'] as String);
  }

  Map<String, dynamic> toJson() => {'barcode': barcode, 'drugName': drugName};
}
