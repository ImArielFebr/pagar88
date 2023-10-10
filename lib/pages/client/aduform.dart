
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:p88/pages/loading.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/model.dart';
import '../pdf_laporan.dart';
import '../widgets.dart';


class Aduform extends StatefulWidget {
  const Aduform({Key? key}) : super(key: key);

  @override
  State<Aduform> createState() => _AduformState();
}

class _AduformState extends State<Aduform> {
  PlatformFile? pickedFile;

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  TextEditingController pelapor = TextEditingController();
  TextEditingController nik = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController tempatlahir = TextEditingController();
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
    ..subject = "Pengaduan Baru #88"
    ..text = "Pemberitahuan Pengaduan Baru aplikasi #88"
    ..attachments.addAll(toAt(pateh));
    
    try {
      await send(message, smtpServer);
    }
    on MailerException catch (e) {
      SnackBar(content: Text(e.toString()),);
    }
  }

  Future<void> _attachFileFromAppDocumentsDirectoy() async {
    try {
      final appDocumentDir = await getExternalStorageDirectory();
      final pather = appDocumentDir!.path;
      var dokumen = File('$pather/surat_pengaduan_#88.pdf').path;

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
              height: MediaQuery.of(context).size.height*2.5,
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
                          const SizedBox(height: 10,),
                          reuseJudul(context, "Identitas Pelapor", Colors.black),
                          const SizedBox(height: 20,),
                          reuseTeksField(context, "NIK", nik, "", TextAlign.start, Colors.red),
                          reuseTeksField(context, "Nama", pelapor, "", TextAlign.start, Colors.red),
                          reuseTeksField(context, "Tempat Lahir", tempatlahir, "", TextAlign.start, Colors.red),
                          TextFormField(
                            style: const TextStyle(fontSize: 18),
                            controller: dateinput, //editing controller of this TextField
                            decoration: const InputDecoration(
                                 //icon of text field
                                labelText: "Tanggal Lahir",
                                labelStyle: TextStyle(fontSize: 16),
                              icon: Icon(Icons.calendar_today),//label text of field
                            ),
                            readOnly: true,  //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context, initialDate: DateTime.now(),
                                  firstDate: DateTime(1900), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101)
                              );
                              if(pickedDate != null ){
                                setState(() {
                                  dateinput.text = DateFormat('d MMMM y', 'id').format(pickedDate); //set output date to TextField value.
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 10,),
                          reuseTeksField(context, "No. Handphone", hppelapor, "", TextAlign.start, Colors.red),
                          reuseTeksField(context, "Email", email, "", TextAlign.start, Colors.red),
                          if (pickedFile != null)
                            SizedBox(
                                height: 50,
                                width: 100,
                                child:
                                  Image.file(File(pickedFile!.path!), fit: BoxFit.cover,
                              )
                            ),
                          TextFormField(
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                            controller: ktp,
                            decoration: const InputDecoration(
                              //icon of text field
                              labelText: "Upload KTP / SIM",
                              labelStyle: TextStyle(fontSize: 16),
                              icon: Icon(Icons.image),//label text of field
                            ),
                            readOnly: true,
                            onTap: () async {
                              getFiles();
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(30),
                      child:
                      Column(
                        children: [
                          const SizedBox(height: 10,),
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
                          const SizedBox(height: 10,),
                          reuseJudul(context, "Deskripsi & Bukti", Colors.black),
                          const SizedBox(height: 20,),
                          TextFormField(
                            style: const TextStyle(fontSize: 18),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Mohon isi data';
                              }
                              return null;
                            },
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
                                await createLaporan(context, terlapor.text, pangkat.text, nrp.text, hpterlapor.text, jabatan.text,
                                    substaker.text, ket.text,
                                    k1: pickedFile,
                                    k3: files,
                                    pelapor: pelapor.text,
                                    nik: int.parse(nik.text),
                                    email: email.text,
                                    tptlhr: tempatlahir.text,
                                    tgllhr: dateinput.text,
                                    hppelapor: hppelapor.text,
                                    deskripsi: deskripsi.text, );
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
                                Text("Tutup", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),),
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

  Future createLaporan(BuildContext context, String terlapor, String pangkat, String nrp, String hpterlapor, String jabatan, String substaker, String ket, {required List<PlatformFile?> k3, required PlatformFile? k1, required String pelapor, required int nik,  required String tptlhr,  required String tgllhr,  required String email, required String hppelapor, required String deskripsi}) async {
    int nom = 1;
    String namba = NumberFormat("000").format(nom);
    DateTime now = DateTime.now();
    String l12 = DateFormat('d MMMM y').add_jm().format(now);
    String harini = DateFormat('ddMMyy').format(now);
    String doki = '$harini$namba';
    const nomor = 1;

    Future uploadKTP(String id, PlatformFile? k1) async{
      final path = '$id/ktp/${k1!.name}';
      final file = File(k1.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
    }
    Future uploadBukti(String id, PlatformFile? k2) async {
      final path = '$id/bukti/${k2!.name}';
      final file = File(k2.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
    }
    Future uploadBuktis(String id, List<PlatformFile?> bukti) async {
      var buktiUrls = await Future.wait(
          bukti.map((bukti) => uploadBukti(id, bukti)));
      return buktiUrls;
    }

    Future uploadPDF(String id) async {

      try {
        final appDocumentDir = await getExternalStorageDirectory();
        final pather = appDocumentDir!.path;
        final file = File('$pather/surat_pengaduan_#88.pdf');
        final path = '$id/pdf/surat_pengaduan_#88.pdf';

        final ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(file);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create file in applicion directory'),
          ),
        );
      }
    }
    int pgrs = 1;

    try {
       await FirebaseFirestore.instance.doc("laporan/$doki").get().then((doc) async {
        if(doc.exists){
          var mm = await FirebaseFirestore.instance.collection("laporan").get();
          var nn = mm.docs.last.id;
          int nudoki = int.parse(nn);
          int doku = nudoki + 1;
          String yoda = NumberFormat("000000000").format(doku);
          final laporan = Laporan(
            id : yoda,
            pelapor: pelapor,
            nik: nik,
            hppelapor: hppelapor,
            email: email,
            tempatlahir: tptlhr,
            tanggallahir: tgllhr,
            terlapor: terlapor,
            pangkat: pangkat,
            nrp: nrp,
            hpterlapor: hpterlapor,
            jabatan: jabatan,
            substaker: substaker,
            deskripsi: deskripsi,
            keterangan: ket,
            tgllapor: l12,
            proses: pgrs,
            jenis: 'lapor',
          );
          final timeline = Linimasa(
            proses: nomor,
            tanggal: l12,
            keterangan: 'Pengaduan Terkirim',
          );
          final docLpr = FirebaseFirestore.instance.collection('laporan').doc(yoda);
          final docTim = FirebaseFirestore.instance.collection('timeline').doc(
              yoda).collection('proses').doc(nomor.toString());
          final json = laporan.toJson();
          final jason = timeline.toJson();
          await makePdf(terlapor, pangkat, nrp, hpterlapor, jabatan, substaker, ket, doki: yoda, pelapor: pelapor, nik: nik, tptlhr: tptlhr, tgllhr: tgllhr, hppelapor: hppelapor, email: email, deskripsi: deskripsi);
          await docLpr.set(json);
          await docTim.set(jason);
          await uploadKTP(yoda, k1);
          await uploadBuktis(yoda, k3);
          await uploadPDF(yoda);
          laporanAlert(context, yoda);
        }
        else {
          final laporan = Laporan(
            id : doki,
            pelapor: pelapor,
            nik: nik,
            hppelapor: hppelapor,
            email: email,
            tempatlahir: tptlhr,
            tanggallahir: tgllhr,
            terlapor: terlapor,
            pangkat: pangkat,
            nrp: nrp,
            hpterlapor: hpterlapor,
            jabatan: jabatan,
            substaker: substaker,
            deskripsi: deskripsi,
            keterangan: ket,
            tgllapor: l12,
            proses: pgrs,
            jenis: 'lapor',
          );
          final timeline = Linimasa(
            proses: nomor,
            tanggal: l12,
            keterangan: 'Pengaduan Terkirim',
          );
          final docLpr = FirebaseFirestore.instance.collection('laporan').doc(doki);
          final docTim = FirebaseFirestore.instance.collection('timeline').doc(
              doki).collection('proses').doc(nomor.toString());
          final json = laporan.toJson();
          final jason = timeline.toJson();
          await makePdf(terlapor, pangkat, nrp, hpterlapor, jabatan, substaker, ket, doki: doki, pelapor: pelapor, nik: nik, tptlhr: tptlhr, tgllhr: tgllhr, hppelapor: hppelapor, email: email, deskripsi: deskripsi);
          await docLpr.set(json);
          await docTim.set(jason);
          await uploadKTP(doki, k1);
          await uploadBuktis(doki, k3);
          await uploadPDF(doki);
          laporanAlert(context, doki);
        }
      });
    } catch (e) {
      // If any error
      return false;
    }
  }

  void laporanAlert(BuildContext context, String id){
    TextEditingController hasil = TextEditingController(text: id);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Pengaduan Berhasil Dikirim!', textAlign: TextAlign.center,),
            content: Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  <Widget>[
                  const Text('Nomor Seri pengaduan'),
                  TextField(textAlign: TextAlign.center, readOnly: true, controller: hasil, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 20,),
                  Text('Tangkap Layar / Simpan nomor seri di atas untuk cek progres pengaduan', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),),
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
        });
  }
}


