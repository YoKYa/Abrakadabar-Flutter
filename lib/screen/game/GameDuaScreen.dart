import 'package:abrakadabar/API/MateriApi.dart';
import 'package:abrakadabar/helper/Auth.dart';
import 'package:abrakadabar/model/Soals.dart';
import 'package:abrakadabar/screen/game/GameTigaScreen.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class GameDuaScreen extends StatefulWidget {
  GameDuaScreen(
      {Key? key,
      required this.materi_id,
      required this.list,
      required this.index})
      : super(key: key);
  final materi_id;
  final List list;
  late final int index;

  @override
  _GameDuaScreenState createState() => _GameDuaScreenState();
}

class _GameDuaScreenState extends State<GameDuaScreen> {
  late Future<Soal> soalBuffer;
  final _jawabanCtrl = TextEditingController();

  @override
  void dispose() {
    _jawabanCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    soalBuffer = MateriAPI().fetchSoal(
        {'materi_id': widget.materi_id, 'soal_id': widget.list[widget.index]});
    super.initState();
  }

  Future nextQuestion(BuildContext context) async {
    var result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(Auth().requestAddJawaban({
              'materi_id': widget.materi_id,
              'soal_id': widget.list[widget.index],
              'jawaban': _jawabanCtrl.text
            })));
    if (result['status'] == true) {
      if (widget.list.length == (widget.index + 1)) {
        var res = await Auth().requestNilai({
          'materi_id': widget.materi_id,
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                GameTigaScreen(res: res['nilai'])));
      } else {
        AwesomeDialog(
            context: context,
            animType: AnimType.TOPSLIDE,
            dialogType: DialogType.NO_HEADER,
            showCloseIcon: false,
            title: 'Selanjutnya',
            btnOkOnPress: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => GameDuaScreen(
                          materi_id: widget.materi_id,
                          list: widget.list,
                          index: widget.index + 1)),
                  (Route<dynamic> route) => false);
            },
            headerAnimationLoop: false,
            btnOkIcon: Icons.check_circle,
            onDissmissCallback: (type) {
              debugPrint('Dialog Dismiss from callback $type');
            })
          ..show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var text;
    if (widget.list.length == widget.index + 1) {
      text = "SELESAI DAN SIMPAN";
    } else {
      text = "LANJUTKAN";
    }
    return FutureBuilder<Soal>(
      future: soalBuffer,
      builder: (context, ss) {
        if (ss.hasData) {
          var help = 5;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
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
                      "Gambar Ke-${widget.index + 1}",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            body: GridView.count(crossAxisCount: 1, children: [
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
                            margin: EdgeInsets.fromLTRB(50, 10, 50, 0),
                            width: 200,
                            child: Column(
                              children: [
                                AnimatedButton(
                                  text: 'Petunjuk',
                                  color: Colors.cyan,
                                  pressEvent: () {
                                    if (help > 0) {
                                      AwesomeDialog(
                                        context: context,
                                        headerAnimationLoop: false,
                                        dialogType: DialogType.NO_HEADER,
                                        title: ss.data!.petunjuk,
                                        desc:
                                            "Petunjuk anda tinggal ${help - 1}",
                                        btnOkOnPress: () {
                                          debugPrint('OnClcik');
                                        },
                                        btnOkIcon: Icons.check_circle,
                                      )..show();
                                      help--;
                                    } else {
                                      AwesomeDialog(
                                        context: context,
                                        headerAnimationLoop: false,
                                        dialogType: DialogType.NO_HEADER,
                                        title: "Petunjuk Sudah Habis",
                                        btnOkOnPress: () {
                                          debugPrint('OnClcik');
                                        },
                                        btnOkIcon: Icons.check_circle,
                                      )..show();
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: 350,
                            child: Form(
                              child: TextFormField(
                                minLines: 5,
                                maxLines: 10,
                                controller: _jawabanCtrl,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Text Cerita",
                                  labelStyle: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.all(10),
                              width: 350,
                              child: Column(
                                children: [
                                  AnimatedButton(
                                    text: text,
                                    borderRadius: BorderRadius.circular(5),
                                    buttonTextStyle: TextStyle(fontSize: 16),
                                    pressEvent: () {
                                      nextQuestion(context);
                                    },
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ))
                        ],
                      )
                    ],
                  )),
            ]),
          );
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
