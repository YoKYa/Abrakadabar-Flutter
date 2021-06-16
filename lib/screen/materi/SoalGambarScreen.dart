import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abrakadabar/helper/Auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

// ignore: must_be_immutable
class SoalGambarScreen extends StatefulWidget {
  SoalGambarScreen({Key? key, this.id, required this.num}) : super(key: key);
  final int? id;
  int num;

  @override
  _SoalGambarScreenState createState() => _SoalGambarScreenState();
}

class _SoalGambarScreenState extends State<SoalGambarScreen> {
  final _keywordCtrl = TextEditingController();
  final _petunjukCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  PickedFile? _imageFile;
  dynamic _pickImageError;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    checkIsGambar();
  }

  @override
  void dispose() {
    _keywordCtrl.dispose();
    _petunjukCtrl.dispose();
    super.dispose();
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Widget _previewImage() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      if (kIsWeb) {
        return Image.network(_imageFile!.path);
      } else {
        return Semantics(
            child: Image.file(File(_imageFile!.path)),
            label: 'image_picker_example_picked_image');
      }
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Future<FormData> form(id) async {
    File _image = File(_imageFile!.path);
    String fileName = _image.path.split('/').last;
    return FormData.fromMap({
      'materi_id': id,
      'keyword': _keywordCtrl.text,
      'petunjuk': _petunjukCtrl.text,
      'link_image': await MultipartFile.fromFile(
        _image.path,
        filename: fileName,
      ),
    });
  }

  Future<FormData> form3(id) async {
    return FormData.fromMap({'id': id});
  }

  Future<FormData> form2(id) async {
    File _image = File(_imageFile!.path);
    String fileName = _image.path.split('/').last;
    return FormData.fromMap({
      'publish': 'Published',
      'materi_id': id,
      'keyword': _keywordCtrl.text,
      'petunjuk': _petunjukCtrl.text,
      'link_image': await MultipartFile.fromFile(
        _image.path,
        filename: fileName,
      ),
    });
  }

  Future simpanGambar(BuildContext context, id, num) async {
    var res = await showDialog(
        context: context,
        builder: (context) =>
            FutureProgressDialog(Auth().requestAddSoal(form(id))));
    if (res['status'] == true) {
      var route = MaterialPageRoute(
          builder: (BuildContext context) => SoalGambarScreen(
                id: id,
                num: num,
              ));
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.NO_HEADER,
          showCloseIcon: true,
          title: 'Berhasil',
          desc: "Berhasil ditambakan",
          btnOkOnPress: () {
            Navigator.of(context).push(route);
          },
          btnOkText: "Lanjutkan",
          headerAnimationLoop: false,
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();
    } else {}
  }

  Future simpanGambarPublished(BuildContext context, id) async {
    var res = await showDialog(
        context: context,
        builder: (context) =>
            FutureProgressDialog(Auth().requestAddSoal(form2(id))));
    if (res['status'] == true) {
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.NO_HEADER,
          showCloseIcon: true,
          title: 'Berhasil',
          desc: "Berhasil ditambakan",
          btnOkOnPress: () {
            Navigator.pushNamed(context, '/home');
          },
          btnOkText: "Lanjutkan",
          headerAnimationLoop: false,
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();
    } else {}
  }

  Future hapusSoal(BuildContext context, id) async {
    var res = await showDialog(
        context: context,
        builder: (context) =>
            FutureProgressDialog(Auth().requestHapusMateri(form3(id))));
    if (res['status'] == true) {
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.NO_HEADER,
          showCloseIcon: true,
          title: 'Berhasil',
          desc: "Berhasil Dihapus",
          btnOkOnPress: () {
            Navigator.pushNamed(context, '/home');
          },
          btnOkText: "Lanjutkan",
          headerAnimationLoop: false,
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();
    } else {}
  }

  Future checkIsGambar() async {
    await Provider.of<Auth>(context, listen: false)
        .requestCheckGambar({'id': widget.id});
    return true;
  }

  TextFormField formInput(controller, label, hidden) {
    return TextFormField(
      controller: controller,
      obscureText: hidden,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        labelStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var res = context.watch<Auth>().materi;
    var title;
    if (res.title.toString().isNotEmpty == true) {
      title = res.title.toString();
    } else {
      title = "Load";
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
                  "Tambah Gambar",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
        body: ListView(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(5),
              child: Column(children: [
                Form(
                    key: _formKey,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "JUDUL : ",
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(title),
                                ],
                              )
                            ],
                          ),
                          Container(height: 20),
                          Container(
                            child: Text(
                              "Ke-${widget.num}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(height: 10),
                          // Gambar
                          Container(
                            width: 200,
                            height: 200,
                            child: Center(
                              child: !kIsWeb &&
                                      defaultTargetPlatform ==
                                          TargetPlatform.android
                                  ? FutureBuilder<void>(
                                      future: retrieveLostData(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<void> snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                            return const Text(
                                              'You have not yet picked an image.',
                                              textAlign: TextAlign.center,
                                            );
                                          case ConnectionState.done:
                                            return _previewImage();
                                          default:
                                            if (snapshot.hasError) {
                                              return Text(
                                                'Pick image error: ${snapshot.error}}',
                                                textAlign: TextAlign.center,
                                              );
                                            } else {
                                              return const Text(
                                                'You have not yet picked an image.',
                                                textAlign: TextAlign.center,
                                              );
                                            }
                                        }
                                      },
                                    )
                                  : (_previewImage()),
                            ),
                          ),
                          // Input Gambar
                          Container(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                _onImageButtonPressed(ImageSource.gallery,
                                    context: context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                height: 50,
                                child: Text(
                                  "Upload Gambar Soal",
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                          ),

                          Container(height: 10),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: formInput(_keywordCtrl,
                                "Keyword, Contoh : buku, papan, pensil", false),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              "Pisahkan antara keyword dengan tanda ',' (Koma)",
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                          Container(height: 10),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: formInput(_petunjukCtrl, "Petunjuk", false),
                          ),
                          Container(height: 10),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: AnimatedButton(
                              text: 'Simpan dan Tambahkan Gambar',
                              borderRadius: BorderRadius.circular(5),
                              buttonTextStyle: TextStyle(fontSize: 14),
                              pressEvent: () async {
                                await simpanGambar(
                                    context, widget.id, ++widget.num);
                              },
                            ),
                          ),
                          Container(
                            color: Colors.green,
                            margin: EdgeInsets.all(10),
                            child: AnimatedButton(
                              text: 'Simpan dan Terbitkan',
                              borderRadius: BorderRadius.circular(5),
                              buttonTextStyle: TextStyle(fontSize: 14),
                              pressEvent: () async {
                                await simpanGambarPublished(context, widget.id);
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: AnimatedButton(
                              color: Colors.red,
                              text: 'Batalkan dan Hapus',
                              borderRadius: BorderRadius.circular(5),
                              buttonTextStyle: TextStyle(fontSize: 14),
                              pressEvent: () async {
                                await hapusSoal(context, widget.id);
                              },
                            ),
                          )
                        ],
                      ),
                    )),
              ]),
            ),
          ],
        ));
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
