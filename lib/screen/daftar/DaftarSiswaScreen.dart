import 'package:abrakadabar/API/MateriApi.dart';
import 'package:abrakadabar/model/User.dart';
import 'package:abrakadabar/screen/AppDrawer.dart';
import 'package:flutter/material.dart';

class DaftarSiswaScreen extends StatefulWidget {
  DaftarSiswaScreen({Key? key, required this.status}) : super(key: key);
  final String status;
  @override
  _DaftarSiswaScreenState createState() => _DaftarSiswaScreenState();
}

class _DaftarSiswaScreenState extends State<DaftarSiswaScreen> {
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
                "Daftar Siswa",
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
      drawer: AppDrawer(),
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
              ),
            );
          }),
    );
  }
}
