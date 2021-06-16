import 'package:abrakadabar/API/MateriApi.dart';
import 'package:abrakadabar/helper/Auth.dart';
import 'package:abrakadabar/model/AllMateri.dart';
import 'package:abrakadabar/screen/materi/SoalGambarScreen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

import 'listmode/ListSoalScreen.dart';

class ShowMateriScreen extends StatefulWidget {
  ShowMateriScreen({Key? key, required this.id_materi, required this.mode})
      : super(key: key);
  final int? id_materi;
  final String mode;
  @override
  _ShowMateriScreenState createState() => _ShowMateriScreenState();
}

class _ShowMateriScreenState extends State<ShowMateriScreen> {
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
                  "Halaman Cerita",
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
              return ShowMateriWidget(
                materis: ss.data?.allmateri,
                id_materi: widget.id_materi,
              );
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

class ShowMateriWidget extends StatefulWidget {
  final id_materi;
  final materis;
  ShowMateriWidget({Key? key, required this.materis, this.id_materi})
      : super(key: key);

  @override
  _ShowMateriWidgetState createState() => _ShowMateriWidgetState();
}

class _ShowMateriWidgetState extends State<ShowMateriWidget> {
  late List<Materis> _materiList;

  @override
  void initState() {
    super.initState();
    _materiList = widget.materis;
  }

  Future hapusSoal(BuildContext context, id) async {
    var res = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
            Auth().requestHapusMateri(FormData.fromMap({'id': id}))));
    if (res['status'] == true) {
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.NO_HEADER,
          showCloseIcon: true,
          title: 'Berhasil',
          desc: "Berhasil Dihapus",
          btnOkOnPress: () {
            Navigator.pushNamed(context, '/home');
          },
          btnOkText: "Lanjutkan",
          headerAnimationLoop: false,
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: _materiList.length,
          itemBuilder: (ctx, index) {
            if (_materiList[index].id == widget.id_materi) {
              return Container(
                  child: Column(children: [
                Card(
                  margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  shadowColor: Colors.grey,
                  borderOnForeground: true,
                  child: Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 320,
                              margin: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  _materiList[index].title.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              )),
                        ],
                      )
                    ],
                  )),
                ),
                Card(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    shadowColor: Colors.grey,
                    borderOnForeground: true,
                    child: Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: 320,
                                margin: EdgeInsets.all(10),
                                child: Center(
                                  child: Image.network(
                                    'https://abrakadabar.yokya.id/storage/${_materiList[index].link_image}',
                                    height: 300,
                                  ),
                                )),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                "Sinopsis :",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              width: 350,
                              margin: EdgeInsets.all(10),
                              child:
                                  Text(_materiList[index].sinopsis.toString()),
                            )
                          ],
                        )
                      ],
                    ))),
                Column(
                  children: [
                    Card(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: ListTile(
                            tileColor: Colors.blue,
                            title: Container(
                                child: Text(
                              "Daftar Soal",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            )),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ListSoalScreen(
                                          materi_id: _materiList[index].id)));
                            })),
                    Card(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: ListTile(
                            tileColor: Colors.blue,
                            title: Container(
                                child: Text(
                              "Tambah Soal",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            )),
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SoalGambarScreen(
                                            id: _materiList[index].id,
                                            num: 1))))),
                    Card(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: ListTile(
                            tileColor: Colors.red,
                            title: Container(
                                child: Text(
                              "Hapus Cerita",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            )),
                            onTap: () => hapusSoal(context, widget.id_materi))),
                  ],
                ),
              ]));
            } else {
              return Text("");
            }
          }),
    );
  }
}
