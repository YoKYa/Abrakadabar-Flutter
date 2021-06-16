class Materi {
  int id;
  String title;
  String link_image;
  String kesulitan;
  String sinopsis;
  List soal;
  Materi(
      {required this.id,
      required this.title,
      required this.link_image,
      required this.kesulitan,
      required this.sinopsis,
      required this.soal});

  factory Materi.input(data) {
    return Materi(
        id: data[0]['id'],
        title: data[0]['title'].toString(),
        link_image: data[0]['link_image'].toString(),
        kesulitan: data[0]['kesulitan'].toString(),
        sinopsis: data[0]['sinopsis'].toString(),
        soal: data[1]);
  }
}
