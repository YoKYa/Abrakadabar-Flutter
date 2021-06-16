import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';
import 'package:abrakadabar/helper/Auth.dart';

import 'daftar/DaftarGuruScreen.dart';
import 'daftar/DaftarSiswaScreen.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Future submitLogout(context) async {
    final res = await Provider.of<Auth>(context, listen: false).requestLogout();
    if (res['status'] == true) {
      Navigator.pushNamed(context, '/login');
    }
  }

  AnimatedButton logout() {
    return AnimatedButton(
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
            btnCancelOnPress: () {
              Navigator.pop(context);
            },
            onDissmissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            },
            btnOkOnPress: () {
              submitLogout(context);
            })
          ..show();
      },
    );
  }

  Column menu(title, route) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          onTap: () {
            Navigator.pushNamed(context, route);
          },
        ),
        Container(
          height: 1,
          color: Colors.grey,
          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        ),
      ],
    );
  }

  var Guru = MaterialPageRoute(
      builder: (BuildContext context) => DaftarGuruScreen(status: 'Guru'));
  var Siswa = MaterialPageRoute(
      builder: (BuildContext context) => DaftarSiswaScreen(status: 'Siswa'));
  @override
  Widget build(BuildContext context) {
    var res = context.read<Auth>().user;
    var draw;
    if (res.status == "Guru") {
      draw = Drawer(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Column(
                    children: [
                      Text("${res.fullName} - ${res.callName}"),
                      Text(
                        "Username : ${res.username}",
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )),
              Container(
                height: 1,
                color: Colors.grey,
                margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  res.status.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              menu('Beranda', '/home'),
              Column(
                children: [
                  ListTile(
                    title: Text("Daftar Guru"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(Guru);
                    },
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  ),
                ],
              ),
              Column(
                children: [
                  ListTile(
                    title: Text("Daftar Siswa"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(Siswa);
                    },
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  ),
                ],
              ),
              menu('Daftar Cerita', '/modeList'),
              menu('Profil Pengembang Media', '/profilPengembang'),
              logout(),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      );
    } else if (res.status == "Siswa") {
      draw = Drawer(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Column(
                    children: [
                      Text("${res.fullName} - ${res.callName}"),
                      Text(
                        "Username : ${res.username}",
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )),
              Container(
                height: 1,
                color: Colors.grey,
                margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  res.status.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              menu('Beranda', '/home'),
              menu('Aturan Permainan', '/petunjukSiswa'),
              menu('Profil Pengembang Media', '/profilPengembang'),
              logout(),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      );
    }
    return draw;
  }
}
