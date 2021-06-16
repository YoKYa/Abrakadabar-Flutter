
class NilaisUser {
  late List<NilaiUser> nilaiuser;
  NilaisUser({required this.nilaiuser});

  factory NilaisUser.fromJson(json) {
    var list = List.generate(json.toList().length, (i) {
      return NilaiUser.fromJson(json[i]);
    });
    return NilaisUser(nilaiuser: list);
  }
}

class NilaiUser {
  int? id;
  int? score;
  String? materi;
  NilaiUser({this.id, this.score, this.materi});
  factory NilaiUser.fromJson(json) {
    return NilaiUser(
      id: json['id'],
      score: json['nilai'],
      materi: json['materi']['title'],
    );
  }
}