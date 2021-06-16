import 'package:abrakadabar/screen/AppDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abrakadabar/helper/Auth.dart';
import 'package:abrakadabar/screen/materi/listmode/ListScreen.dart';

class ModeScreen extends StatefulWidget {
  @override
  _ModeScreenState createState() => _ModeScreenState();
}

class _ModeScreenState extends State<ModeScreen> {
  Card listMenu(text) {
    return Card(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: ListTile(
          title: Container(
              child: Text(
            text,
            textAlign: TextAlign.start,
          )),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ListScreen(
                    mode: text,
                  ))),
        ));
  }

  void initState() {
    super.initState();
    checkIsLoggedIn();
  }

  void checkIsLoggedIn() async {
    await Provider.of<Auth>(context, listen: false).requestCheckMe();
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
                "Pilih Mode",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "DAFTAR MODE",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                ],
              )),
          Container(
            child: listMenu("Easy"),
          ),
          Container(
            child: listMenu("Medium"),
          ),
          Container(
            child: listMenu("Hard"),
          )
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
