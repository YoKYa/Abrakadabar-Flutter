import 'package:abrakadabar/API/MateriApi.dart';
import 'package:abrakadabar/helper/Auth.dart';
import 'package:abrakadabar/model/User.dart';
import 'package:abrakadabar/screen/GuestDrawer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class DaftarGuruAdminScreen extends StatefulWidget {
  DaftarGuruAdminScreen({Key? key, required this.status}) : super(key: key);
  final String status;
  @override
  _DaftarGuruAdminScreenState createState() => _DaftarGuruAdminScreenState();
}

class _DaftarGuruAdminScreenState extends State<DaftarGuruAdminScreen> {
  late Future<Users> usersBuffer;

  @override
  void initState() {
    super.initState();
    usersBuffer = MateriAPI().fetchAllUsers({'status': widget.status});
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
                "Daftar",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      body: Container(
          child: FutureBuilder<Users>(
              future: usersBuffer,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ShowUsersWidget(
                    users: snapshot.data?.users,
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              })),
      drawer: GuestDrawer(),
    );
  }
}

class ShowUsersWidget extends StatefulWidget {
  final users;
  ShowUsersWidget({Key? key, this.users}) : super(key: key);

  @override
  _ShowUsersWidgetState createState() => _ShowUsersWidgetState();
}

class _ShowUsersWidgetState extends State<ShowUsersWidget> {
  late List<User> _userList;
  @override
  void initState() {
    super.initState();
    _userList = widget.users;
  }

  Future delUser(BuildContext context, id) async {
    var result = await showDialog(
        context: context,
        builder: (context) =>
            FutureProgressDialog(Auth().requestDelUser({'id': id})));
    if (result['status'] == true) {
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: _userList.length,
          itemBuilder: (ctx, index) {
            return Card(
              child: ListTile(
                  leading: Icon(
                    Icons.supervised_user_circle,
                    size: 50,
                  ),
                  title: Text('${_userList[index].fullName}'),
                  subtitle: Text('@${_userList[index].username}'),
                  trailing: TextButton(
                    child: Text(
                      "Hapus",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.WARNING,
                          headerAnimationLoop: false,
                          animType: AnimType.TOPSLIDE,
                          showCloseIcon: false,
                          closeIcon: Icon(Icons.close_fullscreen_outlined),
                          title: 'Hapus Akun ini?',
                          desc: '${_userList[index].fullName}',
                          btnCancelOnPress: () {},
                          onDissmissCallback: (type) {
                            debugPrint('Dialog Dissmiss from callback $type');
                          },
                          btnOkOnPress: () {
                            delUser(context, _userList[index].ide);
                          })
                        ..show();
                    },
                  )),
            );
          }),
    );
  }
}
