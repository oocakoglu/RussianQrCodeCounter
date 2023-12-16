import 'package:flutter/material.dart';
import '../model/drugkarekod.dart';
import '../model/drugbarcode.dart';
import '../pages/detailpage.dart';

class MyListView extends StatelessWidget {
  //final DBHelper _api = DBHelper();
  final List<DrugBarcode> countBarcode;
  final List<DrugKarekod> countKarekod;
  const MyListView(
      {Key? key, required this.countBarcode, required this.countKarekod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: countBarcode.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xff764abc),
            child: countBarcode[index].drugName != ""
                ? Text(countBarcode[index].drugName[0])
                : const Text("."),
          ),
          title: Text(countBarcode[index].barcode),
          subtitle: Text(countBarcode[index].drugName),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                textAlign: TextAlign.right,
                countBarcode[index].total.toString(),
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              IconButton(
                color: Colors.red,
                padding: EdgeInsets.zero,
                alignment: Alignment.centerRight,
                icon: Icon(
                  Icons.chevron_right,
                  color: Colors.brown[900],
                ),
                onPressed: () {
                  List<DrugKarekod> karekods = countKarekod
                      .where((element) =>
                          element.barkod == countBarcode[index].barcode)
                      .toList();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailPage(karekods)));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
