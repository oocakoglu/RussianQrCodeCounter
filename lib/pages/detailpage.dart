import 'package:flutter/material.dart';
import '../model/drugkarekod.dart';

class DetailPage extends StatelessWidget {
  final List<DrugKarekod> _karekods;

  const DetailPage(
    this._karekods, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Details")),
        body: ListView.builder(
          itemCount: _karekods.length,
          itemBuilder: (context, index) {
            return ListTile(
              // leading: const CircleAvatar(
              //     backgroundColor: Color(0xff764abc), child: Text(".")),
              leading: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                  maxWidth: 64,
                  maxHeight: 64,
                ),
                child: Image.asset("assets/karekod.png", fit: BoxFit.cover),
              ),
              subtitle: Text(
                  "(01)0${_karekods[index].barkod}\n(21)${_karekods[index].sn}\n(91)${_karekods[index].vcode}\n(92)**Uzun Text**"),
            );
          },
        ));
  }
}
