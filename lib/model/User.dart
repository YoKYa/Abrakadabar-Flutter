class Users {
  late List<User> users;
  Users({required this.users});

  factory Users.fromJson(json) {
    var list =
        List.generate(json.toList().length, (i) => User.fromJson(json[i]));
    return Users(users: list);
  }
}

class User {
  int ide;
  String fullName;
  String username;
  String callName;
  String tempatLahir;
  String tanggalLahir;
  String jenisKelamin;
  String status;
  String detail;
  String cek;

  User(
      {required this.ide,
      required this.fullName,
      required this.username,
      required this.callName,
      required this.tempatLahir,
      required this.tanggalLahir,
      required this.jenisKelamin,
      required this.status,
      required this.detail,
      required this.cek});

  factory User.fromJson(json) {
    return User(
      ide: json['id'],
      username: json['username'].toString(),
      fullName: json['name'].toString(),
      callName: json['call_name'].toString(),
      tempatLahir: json['tempat_lahir'].toString(),
      tanggalLahir: json['tanggal_lahir'].toString(),
      jenisKelamin: json['jenis_kelamin'].toString(),
      status: json['status'].toString(),
      detail: json['detail'].toString(),
      cek: json['cek'].toString(),
    );
  }
}
