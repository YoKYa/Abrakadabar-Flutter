import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';
import 'package:abrakadabar/helper/Auth.dart';

class GuestDrawer extends StatefulWidget {
  @override
  _GuestDrawerState createState() => _GuestDrawerState();
}

class _GuestDrawerState extends State<GuestDrawer> {
  Future submitLogout(context) async {
    // final response = context.read<Auth>().user;

    final res = await Provider.of<Auth>(context, listen: false).requestLogout();
    if (res['status'] == true) {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            AnimatedButton(
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
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
