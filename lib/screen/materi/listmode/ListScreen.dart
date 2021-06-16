import 'package:abrakadabar/model/AllMateri.dart';
import 'package:flutter/material.dart';
import 'package:abrakadabar/API/MateriApi.dart';
import 'package:abrakadabar/screen/materi/ShowMateriScreen.dart';
import 'dart:core';

class ListScreen extends StatefulWidget {
  ListScreen({Key? key, required this.mode}) : super(key: key);

  final String mode;

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
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
                  "${widget.mode} Mode",
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: _materiList.length,
          itemBuilder: (ctx, index) {
            return ListTile(
              leading: Container(
                width: 50,
                height: 50,
                child: Image.network(
                  'https://abrakadabar.yokya.id/storage/${_materiList[index].link_image}',
                  width: 50,
                  height: 50,
                ),
              ),
              title: Text('${_materiList[index].title}'),
              isThreeLine: true,
              subtitle: Text('${_materiList[index].sinopsis}'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ShowMateriScreen(
                        id_materi: _materiList[index].id, mode: widget.mode)));
              },
              trailing: Icon(Icons.lens_blur_outlined),
            );
          }),
    );
  }
}
