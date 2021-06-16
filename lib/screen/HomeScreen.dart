import 'package:abrakadabar/screen/AppDrawer.dart';
import 'package:abrakadabar/screen/GuestDrawer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abrakadabar/helper/Auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card listMenu(icon, text, route) {
    return Card(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: ListTile(
          leading: Icon(icon),
          title: Container(
              child: Text(
            text,
            textAlign: TextAlign.start,
          )),
          onTap: () => Navigator.pushNamed(context, route),
        ));
  }

  void initState() {
    super.initState();
    checkIsLoggedIn();
  }

  void checkIsLoggedIn() async {
    await Provider.of<Auth>(context, listen: false).requestCheckMe();
  }

  Future submitLogout(context) async {
    final res = await Provider.of<Auth>(context, listen: false).requestLogout();
    if (res['status'] == true) {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    var user, draw;
    final res = context.read<Auth>().user;
    if (res.cek == '0' && res.status == "Guru") {
      user = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sebagai Guru \nAnda harus konfirmasi dulu ke Admin",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      );
      draw = GuestDrawer();
    } else {
      if (res.status == "Guru") {
        user = Column(
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
                          "SELAMAT DATANG",
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
                            "STATUS",
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                res.status.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Container(
              child: listMenu(Icons.manage_accounts_outlined,
                  "Petunjuk Pengisian", '/petunjukGuru'),
            ),
            Container(
              child: listMenu(
                  Icons.score_outlined, "Melihat Skor", '/daftarSkorSiswa'),
            ),
            Container(
              child: listMenu(
                  Icons.book_online_outlined, "Pengisian Materi", '/addMatery'),
            ),
          ],
        );
        draw = AppDrawer();
      } else if (res.status == "Siswa") {
        user = Column(
          children: [
            Container(
              child: Column(
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
                                "SELAMAT DATANG",
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
                                  "STATUS",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      res.status.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    child: listMenu(Icons.grading_sharp, "Aturan Permainan",
                        '/petunjukSiswa'),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                    height: 220,
                    width: 220,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            color: Colors.blueAccent,
                            shadowColor: Colors.blueGrey,
                            child: TextButton(
                              style:
                                  TextButton.styleFrom(primary: Colors.white),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                                    child: Icon(
                                      Icons.games,
                                      size: 100,
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.all(20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Mulai Permainan",
                                            textAlign: TextAlign.start,
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/modeGame'),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        );
        draw = AppDrawer();
      } else {
        user = Column(
          children: [
            Container(
              child: listMenu(Icons.manage_accounts_outlined, "Daftar Guru",
                  '/daftarGuruAdmin'),
            ),
            Container(
              child: listMenu(Icons.manage_accounts_outlined, "Daftar Siswa",
                  '/daftarSiswaAdmin'),
            ),
            Container(
              child: listMenu(Icons.manage_accounts_outlined,
                  "Daftar Guru Belum Verify", '/daftarGuruAdminUn'),
            ),
            Container(
                child: AnimatedButton(
              text: "Keluar dari Akun",
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              buttonTextStyle: TextStyle(fontSize: 16, color: Colors.red),
              pressEvent: () {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.WARNING,
                    headerAnimationLoop: false,
                    animType: AnimType.TOPSLIDE,
                    showCloseIcon: false,
                    closeIcon: Icon(Icons.close_fullscreen_outlined),
                    title: 'Keluar dari Akun',
                    desc: 'Apakah kamu yakin mau keluar dari Akun ini?',
                    btnCancelOnPress: () {},
                    onDissmissCallback: (type) {
                      debugPrint('Dialog Dissmiss from callback $type');
                    },
                    btnOkOnPress: () {
                      submitLogout(context);
                    })
                  ..show();
              },
            ))
          ],
        );
        draw = GuestDrawer();
      }
    }

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
                "Abrakadabar",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      body: ListView(
        children: [user],
      ),
      drawer: draw,
    );
  }
}
