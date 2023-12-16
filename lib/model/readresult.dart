class ReadResult {
  final String drugName;
  final String readResult;

  ReadResult({this.drugName = "", this.readResult = ""}) {
    //lastUpdate = DateTime.now();
  }

  // factory ReadResult.fromBarkod(String barkod, String readResult) {

  //   return ReadResult(
  //       drugName: json['barcode'] as String,
  //       readResult: readResult);
  // }

  // factory Drug.fromJson(Map<String, dynamic> json) {
  //   return Drug(
  //       barcode: json['barcode'] as String,
  //       drugName: json['drugName'] as String);
  // }

  // Map<String, dynamic> toJson() => {'barcode': barcode, 'drugName': drugName};
}
