import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:abrakadabar/helper/Auth.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _panggilanCtrl = TextEditingController();
  final _tempatLahirCtrl = TextEditingController();
  final _tanggalLahirCtrl = TextEditingController();
  final _detailCtrl = TextEditingController();
  final _formKeySiswa = GlobalKey<FormState>();
  String _genderCtrl = "";
  List<String> _status = ["Laki-laki", "Perempuan"];

  @override
  void dispose() {
    _panggilanCtrl.dispose();
    _tempatLahirCtrl.dispose();
    _tanggalLahirCtrl.dispose();
    _detailCtrl.dispose();
    super.dispose();
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
  DateTimeField dateInput(context, label){
    return DateTimeField(
      controller: _tanggalLahirCtrl,
      format: DateFormat("dd-MM-yyyy"),
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Tanggal Lahir",
        labelStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  Future submitDetail(BuildContext context) async{
    var inputFormat = DateFormat('dd-MM-yyyy');
    var inputDate = inputFormat.parse(_tanggalLahirCtrl.text); // <-- Incoming date

    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate); // <-- Desired date
    var result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(Auth().requestDetail({
          'call_name': _panggilanCtrl.text,
          'tempat_lahir': _tempatLahirCtrl.text,
          'tanggal_lahir': outputDate,
          'jenis_kelamin': _genderCtrl.toString(),
          'detail': _detailCtrl.text
        })));
    if (result['status'] == true) {
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.NO_HEADER,
          showCloseIcon: true,
          title: 'Berhasil',
          desc: "Berhasil Melengkapi Data",
          btnOkOnPress: () {
            Navigator.pushNamed(context, '/home');
          },
          headerAnimationLoop: false,
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dismiss from callback $type');
          })
        ..show();
    } else {
      setState(() {
        _errorMsg = result['error_msg'];
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var res = context.read<Auth>().user;
    var status = '';
    var detail = '';
    if (res.status == "Siswa"){
      status = "SISWA";
      detail = "Asal Sekolah";
    }else{
      status = "GURU";
      detail = "Tempat Mengajar";
    }
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Column(children: [
            Image.asset(
              'images/logo.png',
              width: 150,
              height: 150,
            ),
            Text("Lengkapi Data")
          ],)
        ),
        centerTitle: true,
        toolbarHeight: 200,
        leading: Container(

        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(status, style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Form(
                      key: _formKeySiswa,
                      child: Column(
                        children: [
                          formInput(_panggilanCtrl, "Nama Panggilan", false),
                          Container(height: 10),
                          formInput(_tempatLahirCtrl, "Tempat Lahir", false),
                          Container(height: 10),
                          dateInput(context, "Tanggal Lahir"),
                          Container(height: 10),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(15, 0, 0, 0),
                                    child: Text("Jenis Kelamin"),
                                  )
                                ],
                              ),
                              RadioGroup<String>.builder(
                                groupValue: _genderCtrl,
                                onChanged: (value) => setState(() {
                                  _genderCtrl = value.toString();
                                }),
                                items: _status,
                                itemBuilder: (item) => RadioButtonBuilder(
                                  item,
                                ),
                                activeColor: Colors.blue,
                              ),

                            ],
                          ),
                          Container(height: 10),
                          formInput(_detailCtrl, detail, false),
                          Container(height: 10),
                          Visibility(
                              visible: _hasError,
                              child: Column(
                                children: [
                                  Text("$_errorMsg",
                                      style:
                                      TextStyle(color: Colors.red)),
                                ],
                              )
                          ),
                          Container(height: 10),
                          AnimatedButton(
                            text: "Lengkapi Data",
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                            buttonTextStyle: TextStyle(fontSize: 16, color: Colors.white),
                            pressEvent: () {
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.QUESTION,
                                  headerAnimationLoop: false,
                                  animType: AnimType.TOPSLIDE,
                                  showCloseIcon: false,
                                  closeIcon: Icon(Icons.close_fullscreen_outlined),
                                  title: 'Lengkapi Data',
                                  desc: 'Simpan Informasi?',
                                  btnCancelOnPress: () {

                                  },
                                  onDissmissCallback: (type) {
                                  },
                                  btnOkOnPress: () {
                                    submitDetail(context);
                                  })
                                ..show();
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                      ]
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

//Save

// print(outputDate);
