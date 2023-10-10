import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/hotmail.dart';
import 'package:p88/pages/loading.dart';
import 'package:p88/pages/widgets.dart';

import '../../model/model.dart';

class BatalDetail extends StatefulWidget {

  String id;
  BatalDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<BatalDetail> createState() => _BatalDetailState(id);
}

class _BatalDetailState extends State<BatalDetail> {
  String id;

  _BatalDetailState(this.id);

  final ReceivePort _port = ReceivePort();

  late Future<ListResult> futureFile;
  late Future<ListResult> futureFiles;
  late Future<ListResult> batalFiles;
  late String buktiUrl = '';
  late String ktpUrl = '';
  List<String> batalUrel = [];
  List<String> tdkjadiUrel = [];

  Iterable<Attachment> toAdds(Iterable<String>? attachments) =>
      (attachments ?? []).map((a) => FileAttachment(File(a)));

  Future sendMail(Laporan laporan) async{
    var collection = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses');
    var snapshot = await collection.get();
    var doc = snapshot.docs.last;
    final String deskripsi = doc.get('deskripsi');
    String emailTuju = laporan.email;
    String username = 'pagarappli88@hotmail.com';
    String password = 'prov88admin';
    final smtpServer = hotmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients = [emailTuju]
      ..subject = "Pemberitahuan Proses #88"
      ..text = "Proses berhasil dibatalkan \n\n Nomor Seri : ${laporan.id} \n Keterangan: $deskripsi"
    ..attachments.addAll(toAdds(batalUrel));

    try {
      await send(message, smtpServer);
    }
    on MailerException catch (e) {
      SnackBar(content: Text(e.toString()),);
    }
  }

  Future tdkjadiMail(Laporan laporan) async{
    var collection = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses');
    var snapshot = await collection.get();
    var doc = snapshot.docs.last;
    final String deskripsi = doc.get('deskripsi');
    String emailTuju = laporan.email;
    String username = 'pagarappli88@hotmail.com';
    String password = 'prov88admin';
    final smtpServer = hotmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients = [emailTuju]
      ..subject = "Pemberitahuan Proses #88"
      ..text = "Pencabutan ditolak. Proses dilanjutkan. \n\n Nomor Seri : ${laporan.id} \n Keterangan : $deskripsi"
      ..attachments.addAll(toAdds(tdkjadiUrel));

    try {
      await send(message, smtpServer);
    }
    on MailerException catch (e) {
      SnackBar(content: Text(e.toString()),);
    }
  }

  @override
  void initState()  {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('$id/bukti').listAll();
    futureFile = FirebaseStorage.instance.ref('$id/ktp').listAll();
    batalFiles = FirebaseStorage.instance.ref('$id/batal').listAll();
  }
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading? const Loading() : GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          toolbarHeight: 75,
          shadowColor: Colors.black87,
          title: Text("#88", style: Theme
              .of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.black),),
          centerTitle: true,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Text('Rinci Pencabutan', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black),),
                    const SizedBox(height: 20,),
                    const Divider(thickness: 1, color: Colors.lightBlue),
                    FutureBuilder<Laporan?>(
                      future: ambilLaporan(serial: id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final laporan = snapshot.data;
                          return Column(
                            children: [
                              isiLapor(context, laporan!),
                              const SizedBox(height: 10,),
                              /*Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Text('Unduh Dokumen Persyaratan : ', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black87)),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(
                                              Colors.white),
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.all(15)),
                                          fixedSize: MaterialStateProperty.all(
                                              const Size(400, 50)),
                                          backgroundColor: MaterialStateProperty.all(
                                              Colors.lightBlue),
                                          elevation: MaterialStateProperty.all(10),
                                          animationDuration: const Duration(
                                              milliseconds: 200),
                                          shadowColor: MaterialStateProperty.all(
                                              Colors.black87),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(50.0),
                                              )
                                          )
                                      ),
                                      onPressed: () async {
                                        ListResult bruh;
                                        bruh = await FirebaseStorage.instance.ref('$id/batal').listAll();
                                        for(var element in bruh.items){
                                          download(context, element, id);
                                        }
                                      }, child: const Text('Unduh Dokumen', style: TextStyle(color: Colors.white))
                                  ),
                                ],
                              ),*/
                              Container(
                                child:
                                ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.lightBlueAccent),
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.all(10)),
                                      fixedSize: MaterialStateProperty.all(
                                          Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 15)),
                                      backgroundColor: MaterialStateProperty.all(
                                          Colors.white),
                                      elevation: MaterialStateProperty.all(10),
                                      animationDuration: const Duration(
                                          milliseconds: 500),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.black87),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50.0),
                                              side: const BorderSide(
                                                  color: Colors.red)
                                          )
                                      )
                                  ),
                                  onPressed: () {
                                    stopAlert(context, id);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const SizedBox(width: 10,),
                                      Text("Konfimasi Pembatalan", textAlign: TextAlign.center,
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(color: Colors.red,
                                            fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                child:
                                StreamBuilder<List<Linimasa>>(
                                  stream: ambilLini(id: laporan.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData){
                                      final last = snapshot.data!.last;
                                      return ElevatedButton(
                                        style: ButtonStyle(
                                            overlayColor: MaterialStateProperty.all(
                                                Colors.lightBlueAccent),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.all(10)),
                                            fixedSize: MaterialStateProperty.all(
                                                Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 15)),
                                            backgroundColor: MaterialStateProperty.all(
                                                Colors.white),
                                            elevation: MaterialStateProperty.all(10),
                                            animationDuration: const Duration(
                                                milliseconds: 500),
                                            shadowColor: MaterialStateProperty.all(
                                                Colors.black87),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(50.0),
                                                    side: const BorderSide(
                                                        color: Colors.black)
                                                )
                                            )
                                        ),
                                        onPressed: () async {
                                          lanjutAlert(context, id);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            const SizedBox(width: 10,),
                                            Text("Lanjutkan Proses", textAlign: TextAlign.center,
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(color: Colors.black,
                                                  fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                      );
                                    }
                                    else {
                                      return const SizedBox();
                                    }
                                  }
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                  child:
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            overlayColor: MaterialStateProperty.all(
                                                Colors.lightBlueAccent),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.all(10)),
                                            fixedSize: MaterialStateProperty.all(
                                                Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 15)),
                                            backgroundColor: MaterialStateProperty.all(
                                                Colors.white),
                                            elevation: MaterialStateProperty.all(10),
                                            animationDuration: const Duration(
                                                milliseconds: 500),
                                            shadowColor: MaterialStateProperty.all(
                                                Colors.black87),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(50.0),
                                                    side: const BorderSide(
                                                        color: Colors.black)
                                                )
                                            )
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            const SizedBox(width: 10,),
                                            Text("Tutup", textAlign: TextAlign.center,
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(color: Colors.black87,
                                                  fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 20,),
                            ],
                          );
                        } else {
                          return const Center(
                            child: SizedBox.shrink(),);
                        }
                      },
                    ),
                  ]
              )
          ),
        ),
      ),
    );
  }

  void stopAlert(BuildContext context, String id){
    TextEditingController deskripsi = TextEditingController();
    TextEditingController berkas = TextEditingController();
    TextEditingController idih = TextEditingController(text: id);
    List<PlatformFile> stopFiles = [];

    Future getStopFiles() async {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result == null) return;
      setState(() {
        stopFiles = result.files.toList();
        for (var element in stopFiles) {
          batalUrel.add(element.path!);
        }
      });
    }
    Future uploadStFile(String id, int proses, PlatformFile? k2) async{
      final path = '$id/berkas/$proses/${k2!.name}';
      final file = File(k2.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
    }
    Future uploadFiles(String id, int proses) async {
      var buktiUrls = await Future.wait(stopFiles.map((e) => uploadStFile(id, proses, e)));
      return buktiUrls;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Pembatalan Proses'),
            content: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width/1.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  <Widget>[
                  TextFormField(
                    readOnly: true,
                    controller: idih,
                    decoration: const InputDecoration(
                      helperText: "",
                      labelText: "Nomor Seri",
                      labelStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextFormField(
                    maxLines: 2,
                    controller: deskripsi,
                    decoration: const InputDecoration(
                      helperText: "",
                      labelText: "Deskripsi",
                      labelStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  stopFiles != null?Wrap(
                    children: stopFiles.map((imageone){
                      batalUrel.add(imageone.path!);
                      return Container(
                          child:Card(
                            child: Container(
                              height: 75, width:75,
                              child: Image.file(File(imageone.path!)),
                            ),
                          )
                      );
                    }).toList(),
                  ):Container(),
                  TextFormField(
                    textAlign: TextAlign.center,
                    controller: berkas,
                    decoration: const InputDecoration(
                      labelText: "Upload Berkas",
                      labelStyle: TextStyle(fontSize: 16),
                      icon: Icon(Icons.upload_file_outlined),
                    ),
                    readOnly: true,
                    onTap: () async {
                      await getStopFiles();
                    },
                  ),
                  const SizedBox(height: 20,),
                  FutureBuilder(
                    future: ambilLaporan(serial: id),
                    builder: (context, snapshot){
                      if (snapshot.hasData){
                        final laporan = snapshot.data;
                        final nextnum = laporan!.proses + 1;
                        return ElevatedButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  Colors.lightBlueAccent),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(10)),
                              fixedSize: MaterialStateProperty.all(
                                  Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 17)),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.white),
                              elevation: MaterialStateProperty.all(10),
                              animationDuration: const Duration(
                                  milliseconds: 500),
                              shadowColor: MaterialStateProperty.all(
                                  Colors.black87),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(
                                          color: Colors.red.shade800)
                                  )
                              )
                          ),
                          onPressed: () async {
                            const snak = SnackBar(content: Text('Pengaduan dibatalkan'));
                            DateTime tanggal = DateTime.now();
                            final DateFormat formatter = DateFormat('d MMMM y', 'id').add_jm();
                            final nomor = laporan.proses + 1;
                            String keter = 'Pengaduan Dibatalkan';
                            final docLap = FirebaseFirestore.instance.collection('laporan').doc(id);
                            Navigator.pop(context);
                            setState(() {
                              isLoading = true;
                            });
                            final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses').doc(nomor.toString());
                            final timeline = Linimasa(
                              proses: nomor,
                              tanggal: formatter.format(tanggal),
                              keterangan: keter,
                              deskripsi: deskripsi.text,
                            );
                            final json = timeline.toJson();
                            await docTim.set(json);
                            await uploadFiles(id, nomor);
                            await docLap.update({
                              'proses' : 0,
                              'jenis' : 'batal',
                            });
                            if (laporan.email == ''){

                            } else {
                              await sendMail(laporan);
                            }
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(snak);
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Cabut Proses', style : TextStyle(color: Colors.red.shade800)),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox(height:10);
                      }
                    },
                  ),
                  const SizedBox(height:10),
                  ElevatedButton(
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.lightBlueAccent),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.all(10)),
                        fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 15)),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white),
                        elevation: MaterialStateProperty.all(10),
                        animationDuration: const Duration(
                            milliseconds: 500),
                        shadowColor: MaterialStateProperty.all(
                            Colors.black87),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                side: const BorderSide(
                                    color: Colors.black)
                            )
                        )
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: const <Widget>[
                        Text('Tutup', style : TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void lanjutAlert(BuildContext context, String id){
    TextEditingController deskripsi = TextEditingController();
    TextEditingController berkas = TextEditingController();
    TextEditingController idih = TextEditingController(text: id);
    List<PlatformFile> stopFiles = [];

    Future getStopFiles() async {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result == null) return;
      setState(() {
        stopFiles = result.files.toList();
        for (var element in stopFiles) {
          tdkjadiUrel.add(element.path!);
        }
      });
    }
    Future uploadStFile(String id, int proses, PlatformFile? k2) async{
      final path = '$id/berkas/$proses/${k2!.name}';
      final file = File(k2.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
    }
    Future uploadFiles(String id, int proses) async {
      var buktiUrls = await Future.wait(stopFiles.map((e) => uploadStFile(id, proses, e)));
      return buktiUrls;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Lanjutkan Proses'),
            content: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width/1.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  <Widget>[
                  TextFormField(
                    readOnly: true,
                    controller: idih,
                    decoration: const InputDecoration(
                      helperText: "",
                      labelText: "Nomor Seri",
                      labelStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextFormField(
                    maxLines: 2,
                    controller: deskripsi,
                    decoration: const InputDecoration(
                      helperText: "",
                      labelText: "Deskripsi",
                      labelStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  stopFiles != null?Wrap(
                    children: stopFiles.map((imageone){
                      batalUrel.add(imageone.path!);
                      return Container(
                          child:Card(
                            child: Container(
                              height: 75, width:75,
                              child: Image.file(File(imageone.path!)),
                            ),
                          )
                      );
                    }).toList(),
                  ):Container(),
                  TextFormField(
                    textAlign: TextAlign.center,
                    controller: berkas,
                    decoration: const InputDecoration(
                      labelText: "Upload Berkas",
                      labelStyle: TextStyle(fontSize: 16),
                      icon: Icon(Icons.upload_file_outlined),
                    ),
                    readOnly: true,
                    onTap: () async {
                      await getStopFiles();
                    },
                  ),
                  const SizedBox(height: 20,),
                  FutureBuilder(
                    future: ambilLaporan(serial: id),
                    builder: (context, snapshot){
                      if (snapshot.hasData){
                        final laporan = snapshot.data;
                        return StreamBuilder<List<Linimasa>>(
                            stream: ambilLini(id: laporan!.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData){
                                final last = snapshot.data!.last;
                                return ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.lightBlueAccent),
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.all(10)),
                                      fixedSize: MaterialStateProperty.all(
                                          Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 17)),
                                      backgroundColor: MaterialStateProperty.all(
                                          Colors.white),
                                      elevation: MaterialStateProperty.all(10),
                                      animationDuration: const Duration(
                                          milliseconds: 500),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.black87),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50.0),
                                              side: const BorderSide(
                                                  color: Colors.black)
                                          )
                                      )
                                  ),
                                  onPressed: () async {
                                    const snak = SnackBar(content: Text('Pengaduan dilanjutkan'));
                                    DateTime tanggal = DateTime.now();
                                    final DateFormat formatter = DateFormat('d MMMM y', 'id').add_jm();
                                    final nomor = last.proses;
                                    String keter = 'Pengaduan Dilanjutkan';
                                    final docLap = FirebaseFirestore.instance.collection('laporan').doc(id);
                                    Navigator.pop(context);
                                    setState(() {
                                      isLoading = true;
                                    });
                                    final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan!.id).collection('proses').doc(nomor.toString());
                                    final timeline = Linimasa(
                                      proses: nomor,
                                      tanggal: formatter.format(tanggal),
                                      keterangan: keter,
                                      deskripsi: '',
                                    );
                                    final json = timeline.toJson();
                                    await docTim.set(json);
                                    await docLap.update({
                                      'proses' : nomor,
                                      'jenis' : 'lapor',
                                    });
                                    if (laporan.email == ''){

                                    } else {
                                      await tdkjadiMail(laporan);
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(snak);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: const <Widget>[
                                      Text('Lanjutkan Proses', style : TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                );
                            } else {
                              return const SizedBox(
                              );
                            }
                          }
                        );
                      } else {
                        return const SizedBox(height:10);
                      }
                    },
                  ),
                  const SizedBox(height:10),
                  ElevatedButton(
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.lightBlueAccent),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.all(10)),
                        fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 17)),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white),
                        elevation: MaterialStateProperty.all(10),
                        animationDuration: const Duration(
                            milliseconds: 500),
                        shadowColor: MaterialStateProperty.all(
                            Colors.black87),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                side: const BorderSide(
                                    color: Colors.black)
                            )
                        )
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: const <Widget>[
                        Text('Tutup', style : TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget isiLapor(BuildContext context, Laporan laporan) {
    TextEditingController lapor0 = TextEditingController(text: laporan.id);
    TextEditingController lapor1 = TextEditingController(text: '${laporan.nik}');
    TextEditingController lapor2 = TextEditingController(text: laporan.pelapor);
    TextEditingController lapor3 = TextEditingController(text: laporan.tempatlahir);
    TextEditingController lapor4 = TextEditingController(text: laporan.tanggallahir);
    TextEditingController lapor5 = TextEditingController(text: laporan.email);
    TextEditingController lapor6 = TextEditingController(text: laporan.terlapor);
    TextEditingController lapor7 = TextEditingController(text: laporan.pangkat);
    TextEditingController lapor8 = TextEditingController(text: laporan.jabatan);
    TextEditingController lapor9 = TextEditingController(text: laporan.substaker);
    TextEditingController lapor10 = TextEditingController(text: '${laporan.nrp}');
    TextEditingController lapor11 = TextEditingController(text: laporan.deskripsi);
    TextEditingController lapor12 = TextEditingController(text: laporan.hppelapor);
    TextEditingController lapor13 = TextEditingController(text: laporan.hpterlapor);
    TextEditingController lapor14 = TextEditingController(text: laporan.alasan);
    return Column(
      children: [
        detilData(context, 'Nomor Seri : ', lapor0, laporan.id, 'nik'),
        detilData(context, 'NIK : ', lapor1, laporan.id, 'nik'),
        detilData(context, 'Pelapor : ', lapor2, laporan.id, 'pelapor'),
        detilData(context, 'Tempat Lahir : ', lapor3, laporan.id, 'tempatlahir'),
        detilData(context, 'Tanggal Lahir : ', lapor4, laporan.id, 'tanggallahir'),
        detilData(context, 'No. Handphone : ', lapor12, laporan.id, 'hppelapor'),
        detilData(context, 'E-mail : ', lapor5, laporan.id, 'email'),
        detilData(context, 'Terlapor : ', lapor6, laporan.id, 'terlapor'),
        detilData(context, 'Pangkat : ', lapor7, laporan.id, 'pangkat'),
        detilData(context, 'NRP : ', lapor10, laporan.id, 'nrp'),
        detilData(context, 'No. Handphone : ', lapor13, laporan.id, 'hpterlapor'),
        detilData(context, 'Jabatan : ', lapor8, laporan.id, 'jabatan'),
        detilData(context, 'Sub Satuan Kerja : ', lapor9, laporan.id, 'substaker'),
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            children: [
              GestureDetector(
                onTap: (){ubahAlert(context, 'Deskripsi : ', lapor11, laporan.id, 'deskripsi');},
                child: TextFormField(
                  maxLines: 4,
                  readOnly: true,
                  controller: lapor11,
                  decoration: const InputDecoration(
                    helperText: "",
                    labelText: 'Deskripsi : ',
                    labelStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            children: [
              GestureDetector(
                onTap: (){ubahAlert(context, 'Alasan Pencabutan : ', lapor14, laporan.id, 'alasan');},
                child: TextFormField(
                  maxLines: 2,
                  readOnly: true,
                  controller: lapor14,
                  decoration: const InputDecoration(
                    helperText: "",
                    labelText: 'Alasan Pencabutan : ',
                    labelStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}