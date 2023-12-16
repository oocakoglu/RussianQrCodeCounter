import '../model/enum.dart';
import 'package:flutter/material.dart';

class PopupMenu extends StatelessWidget {
  //VoidCallback onCountSelected(MItem mItem);
  final Function(MItem) onCountChanged;
  const PopupMenu({super.key, required this.onCountChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MItem>(
      //onSelected: mItemSelect,
      onSelected: onCountChanged,
      itemBuilder: (context) => <PopupMenuEntry<MItem>>[
        const PopupMenuItem<MItem>(
          value: MItem.sayimBitir,
          child: Text("Send to Server"),
        ),
        const PopupMenuItem<MItem>(
          value: MItem.sifirla,
          child: Text("Clear Items"),
        )
      ],
    );
  }
}
