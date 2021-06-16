class AllMateri {
  late List<Materis> allmateri;
  AllMateri({required this.allmateri});

  factory AllMateri.fromJson(json) {
    var list = List.generate(json['data'].toList().length, (i) {
      return Materis.fromJson(json['data'][i]);
    });
    return AllMateri(allmateri: list);
  }
}

class Materis {
  int? id;
  String? title;
  String? link_image;
  String? kesulitan;
  String? sinopsis;
  String? publish;
  late List<Nilai> nilai;
  Materis(
      {this.id,
      this.title,
      this.link_image,
      this.kesulitan,
      this.sinopsis,
      this.publish,
      required this.nilai});

  factory Materis.fromJson(json) {
    var list = List.generate(1, (i) {
      return Nilai.fromJson(json['nilai'][i]);
    });
    return Materis(
      id: json['id'],
      title: json['title'],
      link_image: json['link_image'],
      kesulitan: json['kesulitan'],
      sinopsis: json['sinopsis'],
      publish: json['publish'],
      nilai: list,
    );
  }
}

class Nilai {
  int? id;
  int? score;
  List? materi;
  Nilai({this.id, this.score, this.materi});
  factory Nilai.fromJson(json) {
    if (json == null) {
      return Nilai(
        id: 0,
        score: 102,
      );
    } else {
      return Nilai(
        id: json['id'],
        score: json['nilai'],
      );
    }
  }
}
