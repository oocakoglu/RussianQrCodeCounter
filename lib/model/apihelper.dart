import 'dart:convert';
import 'package:flutter/services.dart';
import 'drug.dart';

class ApiHelper {
  static List<Drug>? _uruns;

  Future<List<Drug>> get uruns async {
    if (_uruns != null) return _uruns!;
    _uruns = await getAllDrugs();
    return _uruns!;
  }

  Future<List<Drug>> getAllDrugs() async {
    String jsondata = await rootBundle.loadString('assets/drugs.json');
    List<Drug> sayimIlacs = <Drug>[];
    json.decode(jsondata).forEach((element) {
      try {
        sayimIlacs.add(Drug.fromJson(element));
      } catch (e) {
        //print(e.toString());
      }
    });
    return sayimIlacs;
  }

  Future<String> getDrugNameByBarkod(String barkod) async {
    var lsturun = await uruns;
    bool chkUrun = lsturun.where((q) => q.barcode == barkod).isEmpty;
    return chkUrun
        ? ""
        : lsturun.where((q) => q.barcode == barkod).first.drugName;
  }
}
