import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../model/apihelper.dart';
import '../model/drug.dart';
import '../model/drugbarcode.dart';
import '../model/drugkarekod.dart';
import '../model/enum.dart';
import '../widgets/mylistview.dart';
import '../widgets/popupmenu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Uint8List? createdCodeBytes;
  late SharedPreferences prefs;
  ScreenMode _screenMode = ScreenMode.sList;
  final ApiHelper _api = ApiHelper();
  late List<Drug> _drugs;
  final List<DrugBarcode> _countBarcode = <DrugBarcode>[];
  final List<DrugKarekod> _countKarekod = <DrugKarekod>[];

  void _loadCounted() async {
    prefs = await SharedPreferences.getInstance();
    String? stringBarcodes = prefs.getString('countBarcode');
    if (stringBarcodes != null) {
      List barcodeList = jsonDecode(stringBarcodes);
      for (var barcode in barcodeList) {
        _countBarcode.add(DrugBarcode.fromJson(barcode));
      }

      String? stringKarekods = prefs.getString('countKarekod');
      if (stringKarekods != null) {
        List krdList = jsonDecode(stringKarekods);
        for (var karekod in krdList) {
          _countKarekod.add(DrugKarekod.fromJson(karekod));
        }
      }

      setState(() {
        _countBarcode.sort((a, b) => a.drugName.compareTo(b.drugName));
      });
    }
  }

  void _saveCounted() async {
    prefs.setString('countBarcode', jsonEncode(_countBarcode));
    prefs.setString('countKarekod', jsonEncode(_countKarekod));
  }

  @override
  void initState() {
    super.initState();
    _loadCounted();
    _api.getAllDrugs().then((value) {
      _drugs = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Counter(Zxing)'),
        actions: [
          PopupMenu(
            onCountChanged: _popupItemSelect,
          )
        ],
      ),
      body: _screenMode == ScreenMode.sCamera
          ? ReaderWidget(
              codeFormat: Format.dataMatrix,
              tryHarder: true,
              cropPercent: 1,
              onScan: (value) {
                showMessage(context, 'Scanned: ${value.text ?? ''}');
              },
              tryInverted: true,
            )
          : _countBarcode.isEmpty
              ? const Center(child: Text("Please scan karekods"))
              : MyListView(
                  countBarcode: _countBarcode, countKarekod: _countKarekod),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressedFloatButton,
        tooltip: 'Count',
        child: _screenMode == ScreenMode.sCamera
            ? const Icon(Icons.format_list_bulleted)
            : const Icon(Icons.linked_camera),
      ),
    );
  }

  void _onPressedFloatButton() async {
    if (_screenMode == ScreenMode.sCamera) {
      _saveCounted();
      setState(() {
        _screenMode = ScreenMode.sList;
        _countBarcode.sort((a, b) => a.drugName.compareTo(b.drugName));
      });
    } else {
      setState(() {
        _screenMode = ScreenMode.sCamera;
      });
    }
  }

  showMessage(BuildContext context, String karekodtxt) {
    _vibrateWithBeep();
    String message = addKarekodToList(karekodtxt);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String addKarekodToList(String karekodtxt) {
    String snackMessage = "";
    karekodtxt = karekodtxt
        .replaceAll("Scanned:", "")
        .replaceAll("", "")
        .replaceAll(" ", "");

    var k = _countKarekod.firstWhere(
      (k) => k.karekod == karekodtxt,
      orElse: () {
        //**Add Karekod
        DrugKarekod krd = DrugKarekod(karekodtxt);
        _countKarekod.add(krd);

        var sayim = _countBarcode
            .firstWhere((element) => element.barcode == krd.barkod, orElse: () {
          var secUrun = _drugs.firstWhere(
            (u) => u.barcode == krd.barkod,
            orElse: () {
              return Drug(barcode: krd.barkod, drugName: "Not Define Drug");
            },
          );

          _countBarcode.add(DrugBarcode(
              barcode: krd.barkod, drugName: secUrun.drugName, total: 0));

          snackMessage = "${secUrun.drugName} Added List.";

          return _countBarcode.firstWhere((q) => q.barcode == krd.barkod);
        });

        setState(() {
          sayim.total = sayim.total + 1;
        });

        if (snackMessage == "") {
          snackMessage = "${sayim.drugName} ${sayim.total} counted.";
        }
        return DrugKarekod("-1");
      },
    );

    if (k.karekod != "-1") {
      var dBarcode = _countBarcode.firstWhere(
        (u) => u.barcode == k.barkod,
        orElse: () {
          return DrugBarcode(
              barcode: "", drugName: "Undefined Medicine", total: 0);
        },
      );
      snackMessage =
          "${dBarcode.drugName} already Counted. Total : ${dBarcode.total}";
    }
    return snackMessage;
  }

  void _popupItemSelect(MItem mItem) {
    switch (mItem) {
      case MItem.sayimBitir:
        // Share Data
        break;
      case MItem.sifirla:
        setState(() {
          _countBarcode.clear();
          _countKarekod.clear();
          _saveCounted();
        });
        break;
      default:
    }
  }

  void _vibrateWithBeep() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate();
    }
    FlutterBeep.beep();
  }
}
