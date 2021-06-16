import 'dart:io';
import 'package:abrakadabar/screen/materi/SoalGambarScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abrakadabar/helper/Auth.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/basic.dart';

class AddMateriScreen extends StatefulWidget {
  const AddMateriScreen({Key? key, this.title}) : super(key: key);

  final String? title;
  @override
  _AddMateriScreenState createState() => _AddMateriScreenState();
}

class _AddMateriScreenState extends State<AddMateriScreen> {
  final _titleCtrl = TextEditingController();
  final _sinopsisCtrl = TextEditingController();
  String _modeCtrl = "";
  List<String> _mode = ["Easy", "Medium", "Hard"];
  PickedFile? _imageFile;
  dynamic _pickImageError;
  String? _retrieveDataError;

  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _sinopsisCtrl.dispose();
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

  @override
  void initState() {
    super.initState();
    checkIsLoggedIn();
  }

  void checkIsLoggedIn() async {
    await Provider.of<Auth>(context, listen: false).requestCheckMe();
  }

  bool _hasError = false;
  String _errorMsg = "";

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

  Widget _previewImage() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      if (kIsWeb) {
        // Why network?
        // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
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

  Future<FormData> form() async {
    File _image = File(_imageFile!.path);
    String fileName = _image.path.split('/').last;
    return FormData.fromMap({
      'title': _titleCtrl.text,
      'kesulitan': _modeCtrl.toString(),
      'sinopsis': _sinopsisCtrl.text,
      'link_image': await MultipartFile.fromFile(
        _image.path,
        filename: fileName,
      ),
    });
  }

  Future checkIsGambar(id) async {
    await Provider.of<Auth>(context, listen: false)
        .requestCheckGambar({'id': id});
    return true;
  }

  Future simpanMateri(BuildContext context) async {
    var res = await showDialog(
        context: context,
        builder: (context) =>
            FutureProgressDialog(Auth().requestAddMateri(form())));
    if (res['status'] == true) {
      checkIsGambar(res['id']);
      var route = MaterialPageRoute(
          builder: (BuildContext context) => SoalGambarScreen(id: res['id'], num: 1,));
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
    } else {
      setState(() {
        _errorMsg = res['error_msg'];
        _hasError = true;
      });
    }
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
                  "Pengisian Materi",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              color: Colors.white,
              child: Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: formInput(_titleCtrl, "Judul Cerita", false),
                          ),
                          Container(height: 10),
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
                                  "Upload Gambar Judul",
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          Container(height: 10),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                    child: Text("Tingkat Kesulitan"),
                                  )
                                ],
                              ),
                              RadioGroup<String>.builder(
                                groupValue: _modeCtrl,
                                onChanged: (value) => setState(() {
                                  _modeCtrl = value.toString();
                                }),
                                items: _mode,
                                itemBuilder: (item) => RadioButtonBuilder(
                                  item,
                                ),
                                activeColor: Colors.blue,
                              ),
                            ],
                          ),
                          Container(height: 10),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextFormField(
                              controller: _sinopsisCtrl,
                              obscureText: false,
                              style: TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Sinopsis",
                                labelStyle: TextStyle(fontSize: 14),
                              ),
                              minLines: 4,
                              maxLines: 10,
                            ),
                          ),
                          Container(height: 10),
                          Visibility(
                              visible: _hasError,
                              child: Column(
                                children: [
                                  Text("$_errorMsg",
                                      style: TextStyle(color: Colors.red)),
                                ],
                              )),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: AnimatedButton(
                              text: 'Simpan dan Lanjutkan',
                              borderRadius: BorderRadius.circular(5),
                              buttonTextStyle: TextStyle(fontSize: 16),
                              pressEvent: () async {
                                await simpanMateri(context);
                              },
                            ),
                          )
                        ]),
                  )),
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
