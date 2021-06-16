import 'package:abrakadabar/screen/game/ListModeGameScreen.dart';
import 'package:flutter/material.dart';

class ModeGameScreen extends StatefulWidget {
  ModeGameScreen({Key? key}) : super(key: key);

  @override
  _ModeGameScreenState createState() => _ModeGameScreenState();
}

class _ModeGameScreenState extends State<ModeGameScreen> {
  Card listMenu(text) {
    return Card(
        color: Colors.blueAccent,
        margin: EdgeInsets.all(10),
        child: ListTile(
          title: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )
                    ],
                  )
                ],
              )),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ListModeGameScreen(
                    mode: text,
                  ))),
        ));
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
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Column(
            children: [
              listMenu("EASY"),
              listMenu("MEDIUM"),
              listMenu("HARD"),
            ],
          ))
        ],
      )),
    );
  }
}
