import 'package:abrakadabar/API/MateriApi.dart';
import 'package:abrakadabar/model/Soals.dart';
import 'package:flutter/material.dart';

class ListSoalScreen extends StatefulWidget {
  ListSoalScreen({Key? key, this.materi_id}) : super(key: key);
  final materi_id;

  @override
  _ListSoalScreenState createState() => _ListSoalScreenState();
}

class _ListSoalScreenState extends State<ListSoalScreen> {
  late Future<Soals> soalsBuffer;

  @override
  void initState() {
    super.initState();
    soalsBuffer = MateriAPI().fetchAllSoal({'materi_id': widget.materi_id});
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
                "Halaman Soal",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      body: Container(
          child: FutureBuilder<Soals>(
              future: soalsBuffer,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ShowSoalWidget(
                    soals: snapshot.data?.soals,
                  );
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

class ShowSoalWidget extends StatefulWidget {
  final soals;
  ShowSoalWidget({Key? key, this.soals}) : super(key: key);

  @override
  _ShowSoalWidgetState createState() => _ShowSoalWidgetState();
}

class _ShowSoalWidgetState extends State<ShowSoalWidget> {
  late List<Soal> _soalList;
  @override
  void initState() {
    super.initState();
    _soalList = widget.soals;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: _soalList.length,
          itemBuilder: (ctx, index) {
            return Card(
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
                                'https://abrakadabar.yokya.id/storage/${_soalList[index].link_image}',
                                height: 200,
                              ),
                            )),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "Keyword : ${_soalList[index].keyword}",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "Petunjuk : ${_soalList[index].petunjuk}",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )));
          }),
    );
  }
}
