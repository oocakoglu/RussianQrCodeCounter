class DrugKarekod {
  late String karekod;
  String barkod = "";
  String sn = "";
  String vcode = "";
  String signature = "";

  DrugKarekod(String krd) {
    karekod = krd;
    String preGtin = krd.substring(0, 2);
    if (preGtin == "01") {
      barkod = krd.substring(2, 16);
      String preSn = krd.substring(16, 18);
      if (preSn == "21") {
        sn = krd.substring(18, 31);
        String prevcode = krd.substring(31, 33);
        if (prevcode == "91") {
          vcode = krd.substring(33, 37);
          String prevcSign = krd.substring(37, 39);
          if (prevcSign == "92") {
            signature = krd.substring(39, krd.length);
          }
        }
      }
    }
    // log(karekod);
    // log(barkod);
    // log(sn);
    // log(vcode);
    // log(signature);
  }

  DrugKarekod.fromJson(Map<String, dynamic> json) {
    karekod = json["karekod"];
    barkod = json["barkod"];
    sn = json["sn"];
    vcode = json["vcode"];
    signature = json["signature"];
  }

  Map<String, dynamic> toJson() => {
        'karekod': karekod,
        'barkod': barkod,
        'sn': sn,
        'vcode': vcode,
        'signature': signature
      };
}
