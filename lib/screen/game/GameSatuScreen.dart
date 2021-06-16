import 'package:abrakadabar/API/MateriApi.dart';
import 'package:abrakadabar/model/Materi.dart';
import 'package:abrakadabar/screen/game/GameDuaScreen.dart';
import 'package:flutter/material.dart';

class GameSatuScreen extends StatefulWidget {
  GameSatuScreen({Key? key, required this.materi_id}) : super(key: key);
  final materi_id;

  @override
  _GameSatuScreenState createState() => _GameSatuScreenState();
}

class _GameSatuScreenState extends State<GameSatuScreen> {
  late Future<Materi> materiBuffer;

  @override
  void initState() {
    materiBuffer = MateriAPI().fetchMateri({'id': widget.materi_id});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Materi>(
      future: materiBuffer,
      builder: (context, ss) {
        if (ss.hasData) {
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
                        "${ss.data!.title}",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              body: GridView.count(
                crossAxisCount: 1,
                children: [
                  Image.network(
                    'https://abrakadabar.yokya.id/storage/${ss.data!.link_image}',
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 350,
                                child: Text(
                                  ss.data!.title,
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                width: 350,
                                margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                child: Text(
                                  "Sinopsis :",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                width: 350,
                                child: Text(
                                  ss.data!.sinopsis,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  width: 350,
                                  color: Colors.blueAccent,
                                  child: TextButton(
                                      onPressed: () => {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        GameDuaScreen(
                                                            materi_id:
                                                                ss.data!.id,
                                                            list: ss.data!.soal,
                                                            index: 0)),
                                                (Route<dynamic> route) => false)
                                          },
                                      child: Text(
                                        "Lanjutkan",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ))),
                            ],
                          )
                        ],
                      ))
                ],
              ));
        } else if (ss.hasError) {
          return Text("${ss.error}");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
