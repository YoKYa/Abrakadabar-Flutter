import 'package:flutter/material.dart';

class GameTigaScreen extends StatefulWidget {
  GameTigaScreen({Key? key, this.res}) : super(key: key);
  final int? res;

  @override
  _GameTigaScreenState createState() => _GameTigaScreenState();
}

class _GameTigaScreenState extends State<GameTigaScreen> {
  Row cek(nilai) {
    if (nilai > 75) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            color: Colors.white,
            size: 40,
          ),
          Icon(
            Icons.star,
            color: Colors.white,
            size: 40,
          ),
          Icon(
            Icons.star,
            color: Colors.white,
            size: 40,
          )
        ],
      );
    } else if (nilai == 75) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            color: Colors.white,
            size: 40,
          ),
          Icon(
            Icons.star,
            color: Colors.white,
            size: 40,
          ),
          Icon(
            Icons.star_border,
            color: Colors.white,
            size: 40,
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            color: Colors.white,
            size: 40,
          ),
          Icon(
            Icons.star_border,
            color: Colors.white,
            size: 40,
          ),
          Icon(
            Icons.star_border,
            color: Colors.white,
            size: 40,
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                "Kamu telah selesai mengisi cerita",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                "Skor Kamu saat ini",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Container(
              child: cek(widget.res),
            ),
            Container(
                margin: EdgeInsets.all(20),
                child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                      backgroundColor: Colors.white,
                      onSurface: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: Text(
                      "Kembali Ke Beranda",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline),
                    ))),
          ],
        )),
      ),
    );
  }
}
