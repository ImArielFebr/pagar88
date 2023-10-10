import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:p88/pages/widgets.dart';

import '../../model/model.dart';

class LaporDetail extends StatefulWidget {

  String id;
  LaporDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<LaporDetail> createState() => _LaporDetailState(id);
}

class _LaporDetailState extends State<LaporDetail> {
  String id;

  _LaporDetailState(this.id);

  late Future<ListResult> futureFile;
  late Future<ListResult> futureFiles;
  late String buktiUrl = '';
  late String ktpUrl = '';

  @override
  void initState()  {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('$id/bukti').listAll();
    futureFile = FirebaseStorage.instance.ref('$id/ktp').listAll();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10,),
                  reuseJudul(context, "Rinci Pengaduan", Colors.black),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    width: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: FutureBuilder<ListResult>(
                              future: futureFile,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final files = snapshot.data!.items;
                                  return SizedBox(
                                      height: 120,
                                      width: 300,
                                      child:ListView.builder(
                                        padding: const EdgeInsets.all(1),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: files.length,
                                        itemBuilder: (context, index) {
                                          final file = files[index];
                                          return FullScreenWidget(
                                            disposeLevel: DisposeLevel.Low,
                                            child: Center(
                                              child: SizedBox(
                                                  height: 90,
                                                  width: 150,
                                                  child:FutureBuilder<String?>(
                                                      future: getKtp(file.name, id),
                                                      builder: (context, snapshot){
                                                        if (snapshot.hasData){
                                                          final String? url = snapshot.data;
                                                          return Image(image: NetworkImage(url!));
                                                        } else {
                                                          return const Icon(Icons.image);
                                                        } }
                                                  )
                                              ),
                                            ),
                                          );
                                        },
                                      ));
                                }
                                else {
                                  return const Icon(Icons.image);
                                }
                              }
                          ),
                        )
                      ],
                    ),
                  ),
                  FutureBuilder<Laporan?>(
                    future: ambilLaporan(serial: id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final laporan = snapshot.data;
                        return isiLapor(context, laporan!);
                      } else {
                        return const Center(
                          child: SizedBox.shrink(),);
                      }
                    },
                  ),
                  const SizedBox(height: 1,),

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
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                            color: Colors.transparent,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text('Bukti : ', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black54)),
                            ),]
                      )
                  ),
                  FutureBuilder<ListResult>(
                      future: futureFiles,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final files = snapshot.data!.items;
                          return Container(
                              padding: const EdgeInsets.all(5),
                              height: 150,
                              child:ListView.builder(
                                padding: const EdgeInsets.all(1),
                                scrollDirection: Axis.horizontal,
                                itemCount: files.length,
                                itemBuilder: (context, index) {
                                  final file = files[index];
                                  return FullScreenWidget(
                                    disposeLevel: DisposeLevel.Medium,
                                    child: SizedBox(
                                        height: 100,
                                        width: 200,
                                        child: FutureBuilder<String?>(
                                            future: getImage(file.name, id),
                                            builder: (context, snapshot){
                                              if (snapshot.hasData){
                                                final String? url = snapshot.data;
                                                return Image(image: NetworkImage(url!), fit: BoxFit.contain,);
                                              } else {
                                                return const Center(
                                                  child: SizedBox.shrink(),);
                                              } }
                                        )
                                    ),
                                  );
                                },
                              ));
                        }
                        else {
                          return const Center(
                            child: SizedBox.shrink(),);
                        }
                      }
                  ),

                  const SizedBox(height: 1,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: MediaQuery.of(context).size.width / 36),
                    child:
                      ElevatedButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.lightBlueAccent),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(15)),
                            fixedSize: MaterialStateProperty.all(
                                Size(MediaQuery.of(context).size.width / 1, MediaQuery.of(context).size.width / 7)),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white),
                            elevation: MaterialStateProperty.all(10.0),
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
                                  ?.copyWith(color: Colors.black,
                                  fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                  ),
                  const SizedBox(height: 20,)
                ]
            )
        ),
      ),
    );
  }
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
  TextEditingController lapor10 = TextEditingController(text: laporan.nrp);
  TextEditingController lapor11 = TextEditingController(text: laporan.deskripsi);
  TextEditingController lapor12 = TextEditingController(text: laporan.hppelapor);
  TextEditingController lapor13 = TextEditingController(text: laporan.hpterlapor);
  return Column(
    children: [
      detilData(context, 'Nomor Seri', lapor0, laporan.id, 'id'),
      detilData(context, 'NIK', lapor1, laporan.id, 'nik'),
      detilData(context, 'Pelapor', lapor2, laporan.id, 'pelapor'),
      detilData(context, 'Tempat Lahir', lapor3, laporan.id, 'tempatlahir'),
      detilData(context, 'Tanggal Lahir', lapor4, laporan.id, 'tanggallahir'),
      detilData(context, 'No. Handphone', lapor12, laporan.id, 'hppelapor'),
      detilData(context, 'E-mail', lapor5, laporan.id, 'email'),
      detilData(context, 'Terlapor',lapor6, laporan.id, 'terlapor'),
      detilData(context, 'Pangkat', lapor7, laporan.id, 'pangkat'),
      detilData(context, 'NRP', lapor10, laporan.id, 'nrp'),
      detilData(context, 'No. Handphone', lapor13, laporan.id, 'hpterlapor'),
      detilData(context, 'Jabatan',lapor8, laporan.id, 'jabatan'),
      detilData(context, 'Sub Satuan Kerja', lapor9, laporan.id, 'substaker'),
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
                readOnly: true,
                controller: lapor11,
                decoration: const InputDecoration(
                  helperText: "",
                  labelText: 'Deskripsi',
                  labelStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      )
    ],
  );
}
