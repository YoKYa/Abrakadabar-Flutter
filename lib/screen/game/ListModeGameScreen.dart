import 'package:abrakadabar/model/AllMateri.dart';
import 'package:abrakadabar/screen/game/GameSatuScreen.dart';
import 'package:flutter/material.dart';
import 'package:abrakadabar/API/MateriApi.dart';

import 'dart:core';

class ListModeGameScreen extends StatefulWidget {
  ListModeGameScreen({Key? key, required this.mode}) : super(key: key);

  final String mode;

  @override
  _ListModeGameScreenState createState() => _ListModeGameScreenState();
}

class _ListModeGameScreenState extends State<ListModeGameScreen> {
  late Future<AllMateri> materiBuffer;

  @override
  void initState() {
    materiBuffer = MateriAPI().fetchAll({'mode': widget.mode});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                alignment: Alignment.centerRight,
                color: Color.fromRGBO(29, 172, 234, 1),
                child: Image.asset(
                  'images/logo.png',
                  width: 50,
                  height: 50,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text(
                  "Mode ${widget.mode} ",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
        body: FutureBuilder<AllMateri>(
          future: materiBuffer,
          builder: (context, ss) {
            if (ss.hasData) {
              return DaftarCeritaWidget(
                  materis: ss.data?.allmateri, mode: widget.mode);
            } else if (ss.hasError) {
              return Text("${ss.error}");
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

class DaftarCeritaWidget extends StatefulWidget {
  final materis;
  final String mode;
  DaftarCeritaWidget({Key? key, required this.materis, required this.mode})
      : super(key: key);

  @override
  _DaftarCeritaWidgetState createState() => _DaftarCeritaWidgetState();
}

class _DaftarCeritaWidgetState extends State<DaftarCeritaWidget> {
  late List<Materis> _materiList;
  @override
  void initState() {
    super.initState();
    _materiList = widget.materis;
  }

  Row nilaiLock(nilai) {
    if (nilai == 101) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.lock)],
      );
    } else if (nilai == 102) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_border,
          ),
          Icon(
            Icons.star_border,
          ),
          Icon(
            Icons.star_border,
          ),
        ],
      );
    } else {
      if (nilai > 75) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.star), Icon(Icons.star), Icon(Icons.star)],
        );
      } else if (nilai == 75) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star),
            Icon(Icons.star),
            Icon(Icons.star_border)
          ],
        );
      } else if (nilai < 75) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star),
            Icon(Icons.star_border),
            Icon(Icons.star_border)
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.lock)],
        );
      }
    }
  }

  Center materiGrid(judul, nilai) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(5),
          child: Text(
            judul,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        Container(
          child: nilaiLock(nilai),
        )
      ],
    ));
  }

  cek(List<Materis> data, index) {
    if (index == 0 && data[index].nilai[0].score == 102) {
      return Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              GameSatuScreen(materi_id: data[index].id)));
    } else if (index == 0) {
      return Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              GameSatuScreen(materi_id: data[index].id)));
    } else if (data[index - 1].nilai[0].score! != 102 &&
        data[index - 1].nilai[0].score! >= 75) {
      return Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              GameSatuScreen(materi_id: data[index].id)));
    } else {
      return print("Ga Oke");
    }
  }

  cekNilai(List<Materis> data, index) {
    if (index == 0 && data[index].nilai[0].score == 102) {
      return materiGrid(data[index].title, 102);
    } else if (index == 0) {
      return materiGrid(data[index].title, data[index].nilai[0].score);
    } else if (data[index - 1].nilai[0].score! != 102 &&
        data[index - 1].nilai[0].score! >= 75) {
      return materiGrid(data[index].title, data[index].nilai[0].score);
    } else {
      return materiGrid(data[index].title, 101);
    }
  }

  @override
  Widget build(BuildContext context) {
    _materiList.removeWhere((element) => element.publish == "Draft");
    if (_materiList.length == 0) {
      return Text("Data Tidak Ada");
    } else {
      return Container(
          child: GridView.builder(
        itemCount: _materiList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (ctx, index) {
          print(index);
          // ignore: unnecessary_null_comparison

          return TextButton(
              onPressed: () {
                cek(_materiList, index);
              },
              child: Stack(children: [
                Image.network(
                  'https://abrakadabar.yokya.id/storage/${_materiList[index].link_image}',
                ),
                Container(color: Colors.black45),
                cekNilai(_materiList, index),
              ]));
        },
      ));
    }
  }
}
