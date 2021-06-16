import 'package:abrakadabar/screen/AppDrawer.dart';
import 'package:flutter/material.dart';

class ProfilPengembangMediaScreen extends StatefulWidget {
  ProfilPengembangMediaScreen({Key? key}) : super(key: key);

  @override
  _ProfilPengembangMediaScreenState createState() =>
      _ProfilPengembangMediaScreenState();
}

class _ProfilPengembangMediaScreenState
    extends State<ProfilPengembangMediaScreen> {
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
                "Profil",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "PROFIL PENGEMBANG MEDIA",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                ],
              )),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(120, 0, 120, 0),
                    color: Colors.grey[50],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "DATA",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Image(
                image: AssetImage('images/pp.png'),
                width: 225,
              )),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            width: 350,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "NAMA : FANY WAHYU FEBRIYANTI",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "TTL : SIDOARJO, 23 FEBRUARI 1999",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "USIA : 22 TAHUN",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "PEKERJAAN	: MAHASISWI, GURU",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              )
            ]),
          )
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
