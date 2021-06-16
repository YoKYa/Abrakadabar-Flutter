import 'package:abrakadabar/API/MateriApi.dart';
import 'package:abrakadabar/model/NilaiUser.dart';
import 'package:flutter/material.dart';

class SkorSiswaScreen extends StatefulWidget {
  SkorSiswaScreen({Key? key, this.user_id}) : super(key: key);
  final int? user_id;

  @override
  _SkorSiswaScreenState createState() => _SkorSiswaScreenState();
}

class _SkorSiswaScreenState extends State<SkorSiswaScreen> {
  late Future<NilaisUser> nilaiBuffer;
  @override
  void initState() {
    super.initState();
    nilaiBuffer = MateriAPI().fetchNilai({'user_id': widget.user_id});
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
                "Daftar Skor",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      body: Container(
          child: FutureBuilder<NilaisUser>(
              future: nilaiBuffer,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SkorWidget(skors: snapshot.data!.nilaiuser);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              })),
    );
  }
}

class SkorWidget extends StatefulWidget {
  SkorWidget({Key? key, required this.skors}) : super(key: key);
  final skors;

  @override
  _SkorWidgetState createState() => _SkorWidgetState();
}

class _SkorWidgetState extends State<SkorWidget> {
  late List<NilaiUser> _nilaiUserList;
  @override
  void initState() {
    super.initState();
    _nilaiUserList = widget.skors;
  }

  @override
  Widget build(BuildContext context) {
    if (_nilaiUserList.length == 0) {
      return Center(child: Text("Tidak Ada Data"));
    } else {
      return Container(
        child: ListView.builder(
            itemCount: _nilaiUserList.length,
            itemBuilder: (ctx, index) {
              return Card(
                child: ListTile(
                  leading: Icon(
                    Icons.supervised_user_circle,
                    size: 50,
                  ),
                  title: Text('${_nilaiUserList[index].materi}'),
                  subtitle: Text('@${_nilaiUserList[index].score}'),
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (BuildContext context) => SkorSiswaScreen(
                    //           user_id: _userList[index].ide,
                    //         )));
                  },
                ),
              );
            }),
      );
    }
  }
}
