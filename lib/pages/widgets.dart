import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_route_animator/page_route_animator.dart';
import 'package:p88/pages/admin/admin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:timelines/timelines.dart';

import '../model/model.dart';

final DateFormat formatter = DateFormat('d MMMM y', 'id').add_jm();

Stream<List<Linimasa>> ambilLini({required String id}){
  final mp = FirebaseFirestore.instance.collection('timeline').doc(id).collection('proses');
  final gh = mp.snapshots().map((snapshot) => snapshot.docs.map((doc) => Linimasa.fromJson(doc.data())).toList());
  return gh;
}

Stream<List<Laporan>> ambilTahap({required int t, required String k}){
  if (k == 'lapor'){
    final mp = FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: t).where('jenis', isEqualTo: 'lapor');
    final gh = mp.snapshots().map((snapshot) => snapshot.docs.map((doc) => Laporan.fromJson(doc.data())).toList());
    return gh;
  } else if (k == 'batal') {
    final mp = FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: t).where('jenis', isEqualTo: 'batal');
    final gh = mp.snapshots().map((snapshot) => snapshot.docs.map((doc) => Laporan.fromJson(doc.data())).toList());
    return gh;
  } else if (k == 'batalkan') {
    final mp = FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: t).where('jenis', isEqualTo: 'batalkan');
    final gh = mp.snapshots().map((snapshot) => snapshot.docs.map((doc) => Laporan.fromJson(doc.data())).toList());
    return gh;
  } else {
    final mp = FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: t).where('jenis', isEqualTo: 'limpah');
    final gh = mp.snapshots().map((snapshot) => snapshot.docs.map((doc) => Laporan.fromJson(doc.data())).toList());
    return gh;
  }
}
Stream<List<Laporan>> ambilBatal({required String k}){
  final mp = FirebaseFirestore.instance.collection('laporan').where('jenis', isEqualTo: k);
  final gh = mp.snapshots().map((snapshot) => snapshot.docs.map((doc) => Laporan.fromJson(doc.data())).toList());
  return gh;
}

Future<Laporan?> ambilLaporan({required String serial}) async {
  final docLaporan = FirebaseFirestore.instance.collection('laporan').doc(serial);
  final snapshot = await docLaporan.get();
  if (snapshot.exists){
    return Laporan.fromJson(snapshot.data()!);
  }
}

Future<Tujuan?> emailTujuan() async {
  final docLaporan = FirebaseFirestore.instance.collection('tujuan').doc('thetujuan');
  final snapshot = await docLaporan.get();
  if (snapshot.exists){
    return Tujuan.fromJson(snapshot.data()!);
  }
}

Widget buildLaporan(BuildContext context, Laporan laporan) {
  return Container(
    height: MediaQuery.of(context).size.height/6.5,
    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical:MediaQuery.of(context).size.height/44),
    decoration:  const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [BoxShadow(
          color: Colors.black45,
          offset: Offset(0, 5),
          spreadRadius: 1,
          blurRadius: 20,
        )]
    ),
    child: ListView(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height/36,
            child: FittedBox(alignment: Alignment.centerLeft, child: Text(laporan.id, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)))),
        SizedBox(
          height: MediaQuery.of(context).size.height/40,
          child: FittedBox( alignment: Alignment.centerLeft,
            child: Row(children: [
              const Text('Pelapor : ', style: TextStyle(color: Colors.black)),
              Text(laporan.pelapor, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height/40,
          child: FittedBox( alignment: Alignment.centerLeft,
            child: Row(children: [
              const Text('Terlapor : ', style: TextStyle(color: Colors.black)),
              Text(laporan.terlapor, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height/40,
          child: FittedBox( alignment: Alignment.centerLeft,
            child: Row(children: [
              const Text('Tanggal Pengaduan : ', style: TextStyle(color: Colors.black)),
              Text(laporan.tgllapor, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
      ],
    ),);
}

Widget tekan(BuildContext context, rute, String nama, IconData ikon, Color warnaOverlay, Color warnaTombol, Color warnaTeks) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: ElevatedButton(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(10),
          overlayColor: MaterialStateProperty.all(warnaOverlay),
          padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
          fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.width / 6)),
          backgroundColor: MaterialStateProperty.all(warnaTombol),
          animationDuration: const Duration(milliseconds: 500),
          shadowColor: MaterialStateProperty.all(Colors.black87),
          alignment: Alignment.centerLeft,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
              )
          )
      ),
      onPressed: () {
        Navigator.of(context).push(
            PageRouteAnimator(
              child: rute,
              routeAnimation: RouteAnimation.rightToLeftWithFade,
              curve: Curves.easeOut,
            ),
        );
      },
      child: Row(
        children: <Widget>[
          const SizedBox(width: 10,),
          SizedBox(
              height: MediaQuery.of(context).size.height/28,
              child: FittedBox(child: Icon(ikon, fill: 1, size: 35, color: Colors.black,))),
          const SizedBox(width: 10,),
          SizedBox(
            height: MediaQuery.of(context).size.height/40,
            child: FittedBox(
              child: Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget reuseJudul(BuildContext context, String judul, Color warna){
  return Center(
    child: SizedBox(
      height: MediaQuery.of(context).size.height/28,
      child: FittedBox(
        child: Text(judul, style: const TextStyle(fontWeight: FontWeight.bold), softWrap: true,
        ),
      ),
    ),
  );
}

Widget reuseTeksField(BuildContext context, String teks, kontrol, String helper, TextAlign alain, Color? warna){
  return TextFormField(
    style: const TextStyle(fontSize: 18),
    textAlign: alain,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Mohon isi data';
      }
      return null;
    },
    textCapitalization: TextCapitalization.sentences,
    decoration: InputDecoration(
      helperText: helper,
      helperStyle: TextStyle(color: warna),
      labelText: teks,
      labelStyle: const TextStyle(fontSize: 16),
    ),
    controller: kontrol,
  );
}

Widget novalidTeksField(BuildContext context, String teks, kontrol, String helper, TextAlign alain, Color? warna){
  return TextFormField(
    style: const TextStyle(fontSize: 18),
    textAlign: alain,
    textCapitalization: TextCapitalization.sentences,
    decoration: InputDecoration(
        helperText: helper,
        helperStyle: TextStyle(color: warna),
        labelText: teks,
        labelStyle: const TextStyle(fontSize: 16)
    ),
    controller: kontrol,
  );
}

Widget detilData(BuildContext context, String label, TextEditingController data, String id, String lapang){
  return Container(
    decoration: const BoxDecoration(
      color: Colors.transparent,
    ),
    width: MediaQuery
        .of(context)
        .size
        .width,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: (){
            ubahAlert(context, label, data, id, lapang);
            },
          child: SizedBox(
            width: MediaQuery.of(context).size.width/1.15,
            child: TextFormField(
              readOnly: true,
              controller: data,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                helperText: "",
                labelText: label,
                labelStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

void ubahAlert(BuildContext context, String label, TextEditingController data, String id, String lapang){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: SizedBox(
              height: MediaQuery.of(context).size.height/28,
              child: FittedBox(child: Text('Ubah $label'))),
          content: Container(
            height: MediaQuery.of(context).size.height / 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  <Widget>[
                TextField(
                  controller: data,),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    const snak = SnackBar(content: Text('Data berhasil diubah'));
                    final docLap = FirebaseFirestore.instance.collection('laporan').doc(id);
                    docLap.update({
                      lapang: data.text
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(snak);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text('Simpan', style : TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void loginAlert(BuildContext context){
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Future masuk() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim()
    );
  }
  Widget mlebu(){
    Text m = Text("Email / Password Kurang Tepat");
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if (snapshot.hasData){
          return const Admin();
        } else {
          return m;
        }
      },
    );
  }

  showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: SizedBox(
          height: MediaQuery.of(context).size.height/28,
          child: const FittedBox(child: Text('Login Admin'))),
      content: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
            TextField(
              controller: email,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(

              controller: password,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                await masuk();
                mlebu();
                Navigator.pop(context);
                },
                child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: MediaQuery.of(context).size.height/50,
                      child: const FittedBox(child: Text('Masuk', style : TextStyle(color: Colors.white)))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });
}

Future<String?> getImage(String imgName, String id) async {
  if(imgName == null){
    return null;
  }
  try {
    var urlRef = FirebaseStorage.instance.ref()
        .child('$id/bukti')
        .child(imgName.toLowerCase());
    var imgUrl = urlRef.getDownloadURL();
    return imgUrl;
  } catch (e){
    return null;
  }
}
Future<String?> getBerkas(String imgName, String id, String proses) async {
  if(imgName == null){
    return null;
  }
  try {
    var urlRef = FirebaseStorage.instance.ref()
        .child('$id/berkas/$proses')
        .child(imgName.toLowerCase());
    var imgUrl = urlRef.getDownloadURL();
    return imgUrl;
  } catch (e){
    return null;
  }
}
Future<String?> getKtp(String imgName, String id) async {
  if(imgName == null){
    return null;
  }
  try {
    var urlRef = FirebaseStorage.instance.ref()
        .child('$id/ktp')
        .child(imgName.toLowerCase());
    var imgUrl = urlRef.getDownloadURL();
    return imgUrl;
  } catch (e){
    return null;
  }
}
Future<String?> getDocx(String docName, String id) async {
  if(docName == null){
    return null;
  }
  try {
    var urlRef = FirebaseStorage.instance.ref()
        .child('$id/assets')
        .child(docName.toLowerCase());
    var docUrl = urlRef.getDownloadURL();
    return docUrl;
  } catch (e){
    return null;
  }
}

Future<String?> getBatal(String imgName, String id) async {
  if(imgName == null){
    return null;
  }
  try {
    var urlRef = FirebaseStorage.instance.ref()
        .child('$id/batal')
        .child(imgName.toLowerCase());
    var imgUrl = urlRef.getDownloadURL();
    return imgUrl;
  } catch (e){
    return null;
  }
}

Widget haha(BuildContext context, int wk) {
  final List<Map<String, dynamic>> prs = [
    {"id": "0", "tahap": "Proses Dihentikan"},
    {"id": "1", "tahap": "Pengaduan terkirim"},
    {"id": "2", "tahap": "Pengaduan dilaporkan kepada pimpinan"},
    {"id": "3", "tahap": "Provos melaksanakan pemanggilan kepada yang bersangkutan"},
    {"id": "4", "tahap": "Provos melaporkan kepada pimpinan hasil penyelidikan dan pemeriksaan awal"},
    {"id": "5", "tahap": "Provos melakukan BAP terhadap saksi dan terduga pelanggar"},
    {"id": "6", "tahap": "Provos menerbitkan Surat Pemberitahuan Perkembangan Hasil Penyelidikan Provos (SP2HP2) kepada pelapor"},
    {"id": "7", "tahap": "Provos melakukan pemberkasan Daftar Pemeriksaan Pendahuluan Pelanggaran Disiplin (DP3D) untuk dikirim ke Atasan Hukum"},
    {"id": "8", "tahap": "Provos meminta saran pendapat hukum ke Divisi Hukum Mabes Polri"},
    {"id": "9", "tahap": "Proses Sidang Disiplin"},
    {"id": "10", "tahap": "Terhukum mengajukan banding"},
    {"id": "11", "tahap": "Proses sidang lanjutan"},
    {"id": "12", "tahap": "Terhukum menjalankan putusan"},
  ];
  var element = prs.elementAt(wk);
  return Text(element['tahap'], textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black));
}
Widget buildProses(BuildContext context, Laporan laporan){
  return Center(
      child:
      Container(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical:MediaQuery.of(context).size.height/44),
          decoration:  const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 5),
                spreadRadius: 1,
                blurRadius: 20,
              )]
          ),
          child :
          Column(
              children: [
                reuseJudul(context, 'Status Pengaduan', Colors.black),
                const SizedBox(height: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularStepProgressIndicator(
                        totalSteps: 12,
                        currentStep: laporan.proses,
                        stepSize: 5,
                        selectedColor: Colors.lightBlue,
                        unselectedColor: Colors.grey[200],
                        padding: 0,
                        width: 50,
                        height: 50,
                        selectedStepSize: 7,
                        roundedCap: (_, __) => true,
                        child: const SizedBox(),
                    ),
                    const SizedBox(width: 10,),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: haha(context, laporan.proses))
                  ],
                )
              ]
          )
      ));
}

Future<Linimasa?> ambilTimeline({required String serial, required int nomor}) async {
  final docTimeline = FirebaseFirestore.instance.collection('timeline').doc(
      serial).collection('proses').doc(nomor.toString());
  final snapshot = await docTimeline.get();
  if (snapshot.exists){
    return Linimasa.fromJson(snapshot.data()!);
  }
}

Widget buildDetailProses(BuildContext context, String id){
  return Center(
      child:
      Container(
        padding: const EdgeInsets.all(20),
        decoration:  const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 5),
            spreadRadius: 1,
            blurRadius: 20,
          )]
        ),
        child: Column(
          children: [
            reuseJudul(context, 'Detail Status Pengaduan', Colors.black),
            SizedBox(height: MediaQuery.of(context).size.height/50),
            isiLini(id, 1),
            isiLini(id, 2),
            isiLini(id, 3),
            isiLini(id, 4),
            isiLini(id, 5),
            isiLini(id, 6),
            isiLini(id, 7),
            isiLini(id, 8),
            isiLini(id, 9),
            isiLini(id, 10),
            isiLini(id, 11),
            isiLini(id, 12),
          ]
        ),
      )
  );
}

Widget isiLini(String id, int no){
  return FutureBuilder<Linimasa?>(
      future: ambilTimeline(serial: id, nomor: no),
      builder: (context, snapshot){
        if (snapshot.hasData){
          final linimasa = snapshot.data;
          return TimelineTile(
            oppositeContents: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height/35,
                  child: FittedBox(child: Text(linimasa!.tanggal, style: const TextStyle(fontSize: 18),))),
            ),
            contents: Card(
              color: Colors.lightBlue,
              child: Container(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height/30,
                    child: FittedBox(child: Text(linimasa.keterangan, style: const TextStyle(fontSize: 16, color: Colors.white),))),
              ),
            ),
            node: const TimelineNode(
              indicator: DotIndicator(),
              startConnector: SolidLineConnector(),
              endConnector: SolidLineConnector(),
            ),
          );
        } else {
          return const SizedBox();
        }
      }
  );
}

Future download(BuildContext context, Reference ref, String id) async {
  DateTime now = DateTime.now();
  String harini = DateFormat('ddMMyyhhmm').format(now);
  final directs = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS);
  final url = await ref.getDownloadURL();
  final path = '$directs/#88/$harini/${ref.name}';
  var status = await Permission.storage.request();
  var status1 = await Permission.accessMediaLocation.request();
  var status2 = await Permission.manageExternalStorage.request();
  if (status.isGranted && status2.isGranted && status1.isGranted) {
    var snak = SnackBar(content: Text('${ref.name} Berhasil Diunduh'));
    await Dio().download(url, path);

    ScaffoldMessenger.of(context).showSnackBar(snak);
  }
}