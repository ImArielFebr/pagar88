import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/hotmail.dart';
import 'package:path_provider/path_provider.dart';

import '../loading.dart';
import '../widgets.dart';
import 'admin_widget.dart';

class LimpahForm extends StatefulWidget {
  const LimpahForm({Key? key}) : super(key: key);

  @override
  State<LimpahForm> createState() => _LimpahFormState();
}

class _LimpahFormState extends State<LimpahForm> {

  PlatformFile? pickedFile;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController pengirim = TextEditingController();
  TextEditingController dari = TextEditingController();
  TextEditingController terlapor = TextEditingController();
  TextEditingController pangkat = TextEditingController();
  TextEditingController nrp = TextEditingController();
  TextEditingController jabatan = TextEditingController();
  TextEditingController substaker = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController bukti = TextEditingController();
  TextEditingController ktp = TextEditingController();
  TextEditingController ket = TextEditingController();
  TextEditingController hppelapor = TextEditingController();
  TextEditingController hpterlapor = TextEditingController();

  Future getFiles() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
      pateh.add(pickedFile!.path.toString());
    });
  }
  List<String> pateh = [];
  List<PlatformFile> files = [];
  Future getMultipleFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    setState(() {
      files = result.files.toList();
    });
  }

  Iterable<Attachment> toAt(Iterable<String>? attachments) =>
      (attachments ?? []).map((a) => FileAttachment(File(a)));

  String ss = '';
  Future sendMail() async{
    await FirebaseFirestore.instance.collection("tujuan").doc('thetujuan').get().then(
          (querySnapshot) {
        print("Successfully completed");
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
      ..subject = "Notifikasi #88"
      ..text = "Pengaduan Baru dari aplikasi #88"
      ..attachments.addAll(toAt(pateh));

    try {
      await send(message, smtpServer);
    }
    on MailerException catch (e) {
      print(e);
    }
  }

  Future<void> _attachFileFromAppDocumentsDirectoy() async {
    try {
      final appDocumentDir = await getExternalStorageDirectory();
      final pather = appDocumentDir!.path;
      var dokumen = File('$pather/surat_pelimpahan_#88.pdf').path;

      setState(() {
        pateh.add(dokumen);
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create file in applicion directory'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading? const Loading() : GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child:Scaffold(
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
                color: Theme.of(context).scaffoldBackgroundColor),
            child:
            SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                        children:[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                            child:
                            Column(
                              children: [
                                const SizedBox(height: 20,),
                                reuseJudul(context, "Identitas Pengirim", Colors.black),
                                const SizedBox(height: 20,),
                                reuseTeksField(context, "Nama Pengirim", pengirim, "", TextAlign.start, Colors.red),
                                reuseTeksField(context, "Dilimpahkan Dari", dari, "", TextAlign.start, Colors.red),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(30),
                            child:
                            Column(
                              children: [
                                const SizedBox(height: 20,),
                                reuseJudul(context, "Identitas Terlapor", Colors.black),
                                const SizedBox(height: 20,),
                                novalidTeksField(context, "Nama", terlapor, "", TextAlign.start, Colors.red),
                                novalidTeksField(context, "Pangkat", pangkat, "", TextAlign.start, Colors.red),
                                novalidTeksField(context, "NRP", nrp, "", TextAlign.start, Colors.red),
                                novalidTeksField(context, "No Handphone", hpterlapor, "Apabila Diketahui", TextAlign.start, Colors.black87),
                                novalidTeksField(context, "Jabatan", jabatan, "Apabila Diketahui", TextAlign.start, Colors.black87),
                                novalidTeksField(context, "Sub Satuan Kerja", substaker, "Apabila Diketahui", TextAlign.start, Colors.black87),
                                TextFormField(
                                  style: const TextStyle(fontSize: 18),
                                  maxLines: 4,
                                  controller: ket,
                                  decoration: const InputDecoration(
                                    helperText: "Tambahkan Keterangan Lain Bila Ada",
                                    labelText: "Keterangan Lain",
                                    labelStyle: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(30),
                            child:
                            Column(
                              children: [
                                const SizedBox(height: 20,),
                                reuseJudul(context, "Deskripsi & Bukti", Colors.black),
                                const SizedBox(height: 20,),
                                TextFormField(
                                   validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Mohon isi data';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(fontSize: 18),
                                  maxLines: 6,
                                  controller: deskripsi,
                                  decoration: const InputDecoration(
                                    helperText: "Deskripsikan Tindakan Pelanggaran",
                                    labelText: "Deskripsi",
                                    labelStyle: TextStyle(fontSize: 16),
                                  ),
                                ),
                                files != null?Wrap(
                                  children: files.map((imageone){
                                    pateh.add(imageone.path.toString());
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
                                  style: const TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                  controller: bukti,
                                  decoration: const InputDecoration(
                                    //icon of text field
                                    labelText: "Upload Bukti",
                                    labelStyle: TextStyle(fontSize: 16),
                                    icon: Icon(Icons.image),//label text of field
                                  ),
                                  readOnly: true,  //set it true, so that user will not able to edit text
                                  onTap: () async {
                                    await getMultipleFiles();
                                  },
                                ),
                              ],
                            ),
                          ),

                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                              child: Column(
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.white),
                                          padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                                          fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 14)),
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
                                        if (_formKey.currentState!.validate()) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await createLimpahan(context, terlapor.text, pangkat.text, nrp.text, hpterlapor.text,jabatan.text, substaker.text, ket.text,
                                            k3: files, pengirim: pengirim.text, dari: dari.text, deskripsi: deskripsi.text);
                                            setState(() {
                                              isLoading = false;
                                            });
                                            await _attachFileFromAppDocumentsDirectoy();
                                            await sendMail();
                                        }
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
                                          fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 14)),
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
                                          Text("Tutup", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87, fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20,),

                                  ]
                              )
                          ),
                        ]
                    )
                )
            ),
          ),
        ),
      ),
    );
  }
}
