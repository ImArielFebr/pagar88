import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/hotmail.dart';

import '../../model/model.dart';
import '../loading.dart';
import '../widgets.dart';

class BatalPage extends StatefulWidget {
  const BatalPage({Key? key}) : super(key: key);

  @override
  State<BatalPage> createState() => _BatalPageState();
}

class _BatalPageState extends State<BatalPage> {
  bool isLoading = false;
  late List<PlatformFile> pickedFiles;
  final Key _formKey = GlobalKey<FormState>();
  TextEditingController alasan = TextEditingController();
  TextEditingController cari = TextEditingController();

  List<String> urel = [
    'assets/surat_pernyataan_pribadi.docx',
    'assets/surat_pernyataan_bersama.docx',
    'assets/surat_permohonan_pencabutan.docx'
  ];

  List<String> pateh = [];

  final ReceivePort _port = ReceivePort();

  Iterable<String> toAt(Iterable<String>? urls) =>
      (urls ?? []).map((a) => a);

  TextEditingController dokumen = TextEditingController();

  Future getMultipleFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    setState(() {
      pickedFiles = result.files.toList();
      for (var element in pickedFiles) {
        pateh.add(element.path!);
      }
    });
  }

  Iterable<Attachment> toAddd(Iterable<String>? attachments) =>
      (attachments ?? []).map((a) => FileAttachment(File(a)));

  String ss = '';
  Future sendMail(String id, String alasan) async{
    await FirebaseFirestore.instance.collection("tujuan").doc('thetujuan').get().then(
          (querySnapshot) {
        if (querySnapshot.exists) {
          setState(() {
            ss = querySnapshot.data()!.values.first.toString();
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    String emailTuju = ss;
    String username = 'pagarappli88@hotmail.com';
    String password = 'prov88admin';
    final smtpServer = hotmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients = [emailTuju]
      ..subject = "Permintaan Cabut Pengaduan #88"
      ..text = "Permintaan Cabut Pengaduan dari aplikasi #88. \n\n Nomor Seri : $id \n Alasan Pencabutan : $alasan"
      ..attachments.addAll(toAddd(pateh));

    try {
      await send(message, smtpServer);
    }
    on MailerException catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return isLoading? const Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 75,
        shadowColor: Colors.black87,
        title: Text("#88", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor),
          child:
          SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child:
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          boxShadow: [BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0, 7),
                            spreadRadius: 1,
                            blurRadius: 20,
                          )]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          reuseJudul(context, 'Cabut Pengaduan', Colors.black),
                          const SizedBox(height: 20,),
                          reuseTeksField(context, 'Masukkan Nomor Seri', cari, '', TextAlign.center, Colors.black87),
                          ElevatedButton(
                              style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(Colors.white),
                                  fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 15)),
                                  backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                                  elevation: MaterialStateProperty.all(10.0),
                                  animationDuration: const Duration(milliseconds: 500),
                                  shadowColor: MaterialStateProperty.all(Colors.black87),
                                  alignment: Alignment.centerLeft,
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                      )
                                  )
                              ), onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            await ambilLaporan(serial: cari.text);
                            setState(() { });
                          },
                              child:Row( mainAxisAlignment: MainAxisAlignment.center, children: [
                                const Icon(Icons.search, size: 20, color: Colors.white,),
                                const SizedBox(width: 5,),
                                Text('Cari', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),)

                              ]))
                        ],
                      )
                  ),
                  const SizedBox(height: 20,),
                  FutureBuilder<Laporan?>(
                    future: ambilLaporan(serial: cari.text),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final laporan = snapshot.data;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              boxShadow: [BoxShadow(
                                color: Colors.black45,
                                offset: Offset(0, 7),
                                spreadRadius: 1,
                                blurRadius: 20,
                              )]
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10,),
                              TextFormField(
                                readOnly: true,
                                initialValue: laporan!.id,
                                decoration: const InputDecoration(
                                  labelText: "Nomor Seri",
                                  labelStyle: TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              TextFormField(
                                readOnly: true,
                                maxLines: 6,
                                initialValue: laporan.deskripsi,
                                decoration: const InputDecoration(
                                  labelText: "Deskripsi",
                                  labelStyle: TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              TextFormField(
                                style: const TextStyle(fontSize: 18),
                                maxLines: 6,
                                controller: alasan,
                                decoration: const InputDecoration(
                                  helperText: "Jelaskan Alasan Pencabutan",
                                  labelText: "Alasan",
                                  labelStyle: TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 10,),
                                TextFormField(
                                  style: const TextStyle(fontSize: 18),
                                  textAlign: TextAlign.start,
                                  decoration: const InputDecoration(
                                    labelText: "Unggah Dokumen Persyaratan",
                                    labelStyle: TextStyle(fontSize: 14),
                                    icon: Icon(Icons.upload_file_outlined),//label text of field
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    getMultipleFiles();
                                  },
                                ),
                              const SizedBox(height: 15,),
                              const Text('Unggah 3 dokumen persyaratan untuk cabut pengaduan (.pdf), cabut pengaduan tidak akan diproses apabila dokumen belum lengkap. Silahkan lihat contoh dokumen persyaratan di bawah', style: TextStyle(color: Colors.grey, fontSize: 15),),
                              const SizedBox(height: 30,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FullScreenWidget(
                                        disposeLevel: DisposeLevel.Low,
                                        child: Container(
                                          height: MediaQuery.of(context).size.height / 6.5,
                                          width: MediaQuery.of(context).size.width / 5,
                                          decoration: BoxDecoration(
                                            border:Border.all(color: Colors.black),
                                          ),
                                          child: Image(image: AssetImage('assets/surat_pernyataan_pribadi-1.png'),
                                          ),
                                        ),
                                      ),
                                      FullScreenWidget(
                                        disposeLevel: DisposeLevel.Low,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:Border.all(color: Colors.black),
                                          ),
                                          height: MediaQuery.of(context).size.height / 6.5,
                                          width: MediaQuery.of(context).size.width / 5,
                                          child: const Image(image: AssetImage('assets/surat_pernyataan_bersama-1.png')),),
                                      ),
                                      FullScreenWidget(
                                        disposeLevel: DisposeLevel.Low,
                                        child: Container(
                                        decoration: BoxDecoration(
                                          border:Border.all(color: Colors.black),
                                        ),
                                          height: MediaQuery.of(context).size.height / 6.5,
                                          width: MediaQuery.of(context).size.width / 5,
                                        child: const Image(image: AssetImage('assets/surat_permohonan_pencabutan-1.png')),),)
                                    ],
                                ),
                              ),
                              /*const SizedBox(height: 10,),
                              GestureDetector(
                                onTap: () async {
                                  ListResult futureDocs;
                                  futureDocs = await FirebaseStorage.instance.ref('assets').listAll();
                                  for (var element in futureDocs.items) {
                                    download(context, element, cari.text);
                                  }
                                },
                                child: const Text('Unduh contoh surat pernyataan', style: TextStyle(color: Colors.lightBlue, fontSize: 18, fontStyle: FontStyle.italic),),
                              ),*/
                              const SizedBox(height: 30,),
                              Container(
                                  child: Column(
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              overlayColor: MaterialStateProperty.all(Colors.white),
                                              fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.width / 7)),
                                              backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                                              elevation: MaterialStateProperty.all(10.0),
                                              animationDuration: const Duration(milliseconds: 500),
                                              shadowColor: MaterialStateProperty.all(Colors.black87),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(50.0),
                                                  )
                                              )
                                          ),
                                          onPressed: () async {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await createBatal(
                                              context,
                                              k1: pickedFiles,
                                              id: cari.text,
                                              alasan: alasan.text,
                                            );
                                            setState(() {
                                              isLoading = false;
                                            });
                                            batalAlert();
                                            await sendMail(cari.text, alasan.text);
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              const SizedBox(width: 10,),
                                              Text("Kirim", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20,),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent),
                                              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                                              fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.width / 7)),
                                              backgroundColor: MaterialStateProperty.all(Colors.white),
                                              elevation: MaterialStateProperty.all(10.0),
                                              animationDuration: const Duration(milliseconds: 500),
                                              shadowColor: MaterialStateProperty.all(Colors.black87),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(50.0),
                                                      side: const BorderSide(color: Colors.black)
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
                                              Text("Tutup", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20,),
                                      ]
                                  )
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                          child: SizedBox.shrink(),);
                      }
                    },
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
  Future createBatal(BuildContext context, {required List<PlatformFile> k1, required String id, required String alasan}) async {
    Future uploadBukti(PlatformFile? k) async{
      final path = '$id/batal/${k!.name}';
      final file = File(k.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
    }
    Future uploadFiles(List<PlatformFile?> bukti) async {
      var buktiUrls = await Future.wait(bukti.map((bukti) => uploadBukti(bukti)));
      return buktiUrls;
    }
    final docLpr = FirebaseFirestore.instance.collection('laporan').doc(id);

    try {
      await docLpr.update({
        'alasan': alasan,
        'jenis': 'batalkan',
      });
      await uploadFiles(k1);

    } catch (e) {
      // If any error
      return false;
    }
  }

  void batalAlert(){
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Permintaan Terkirim!', textAlign: TextAlign.center,),
            content: Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  <Widget>[
                  Text('Permintaan Cabut Pengaduan akan ditindak lanjuti', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center,),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text('Tutup'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }, context: context);
  }
}
