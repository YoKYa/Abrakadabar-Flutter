class Soals {
  late List<Soal> soals;
  Soals({required this.soals});

  factory Soals.fromJson(json) {
    var list =
        List.generate(json.toList().length, (i) => Soal.fromJson(json[i]));
    return Soals(soals: list);
  }
}

class Soal {
  int? id;
  int? materi_id;
  String? link_image;
  String? keyword;
  String? petunjuk;
  Soal({this.id, this.materi_id, this.link_image, this.keyword, this.petunjuk});

  factory Soal.fromJson(json) {
    return Soal(
      id: json['id'],
      materi_id: json['materi_id'],
      link_image: json['link_image'],
      keyword: json['keyword'],
      petunjuk: json['petunjuk'],
    );
  }
}
