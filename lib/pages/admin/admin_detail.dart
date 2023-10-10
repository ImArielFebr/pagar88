import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/hotmail.dart';
import 'package:p88/pages/loading.dart';
import 'package:p88/pages/widgets.dart';

import '../../model/model.dart';
import 'admin_widget.dart';

class AdminDetail extends StatefulWidget {

  String id;
  AdminDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<AdminDetail> createState() => _AdminDetailState(id);
}

class _AdminDetailState extends State<AdminDetail> {
  String id;

  _AdminDetailState(this.id);

  late Future<ListResult> futureFile;
  late Future<ListResult> futureFiles;
  late String buktiUrl = '';
  late String ktpUrl = '';
  List<String> urel = [];
  final ReceivePort _port = ReceivePort();
  List<PlatformFile> files = [];
  List<String> urles = [];
  List<String> stopUrel = [];
  TextEditingController deskripsi = TextEditingController();
  TextEditingController berkas = TextEditingController();

  Iterable<String> toAt(Iterable<String>? urls) =>
      (urls ?? []).map((a) => a);

  Future getMultipleFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    setState(() {
      files = result.files.toList();
      for (var element in files) {
        urles.add(element.path!);
      }
    });
  }
  Iterable<Attachment> toAdds(Iterable<String>? attachments) =>
      (attachments ?? []).map((a) => FileAttachment(File(a)));

  Future sendMail(Laporan laporan) async{
    var collection = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses');
    var snapshot = await collection.get();
    var doc = snapshot.docs.last;
    final String keterangan = doc.get('keterangan');
    final String deskripsi = doc.get('deskripsi');
    String emailTuju = laporan.email;
    String username = 'pagarappli88@hotmail.com';
    String password = 'prov88admin';
    final smtpServer = hotmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients = [emailTuju]
      ..subject = "Pemberitahuan Proses #88"
      ..text = "Proses berhasil dilanjutkan ke $keterangan \n\n Nomor Seri : ${laporan.id} \n Keterangan : $deskripsi"
      ..attachments.addAll(toAdds(urles));

    try {
      await send(message, smtpServer);
    }
    on MailerException catch (e) {
      SnackBar(content: Text(e.toString()),);
    }
  }

  Future sendHenti(Laporan laporan, String deskripsi) async{
    String emailTuju = laporan.email;
    String username = 'pagarappli88@hotmail.com';
    String password = 'prov88admin';
    final smtpServer = hotmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients = [emailTuju]
      ..subject = "Pemberitahuan Proses #88"
      ..text = "Proses dihentikan. \n\n Nomor Seri : ${laporan.id} \n Keterangan : $deskripsi"
      ..attachments.addAll(toAdds(stopUrel));

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
          actions: [
            GestureDetector(
              onTap: () {
                delAlert(context, id);
              },
              child: const Icon(Icons.delete, size: 30,),
            ),
            const SizedBox(width: 10,),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20,),
                    Text('Rinci Pengaduan', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black),),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: FutureBuilder<ListResult>(
                              future: futureFile,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final files = snapshot.data!.items;
                                  return SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 75,
                                      child:ListView.builder(
                                        padding: const EdgeInsets.all(1),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: files.length,
                                        itemBuilder: (context, index) {
                                          final file = files[index];
                                          return FullScreenWidget(
                                            disposeLevel: DisposeLevel.Low,
                                              child: SizedBox(
                                                  height: 90,
                                                  width: 150,
                                                  child:FutureBuilder<String?>(
                                                      future: getKtp(file.name, id),
                                                      builder: (context, snapshot){
                                                        if (snapshot.hasData){
                                                          final String? url = snapshot.data;
                                                          urel.add(url!);
                                                          return Image(image: NetworkImage(url), fit: BoxFit.contain,);
                                                        } else {
                                                          return const Icon(Icons.image);
                                                        } }
                                                  )
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FutureBuilder<Laporan?>(
                        future: ambilLaporan(serial: id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final laporan = snapshot.data;
                            if (laporan!.jenis == 'lapor'){
                              return isiLapor(context, laporan);
                            } else if (laporan.jenis == 'limpah'){
                              return isiLimpah(context, laporan);
                            } else if (laporan.jenis == 'batal'){
                              return isiBatal(context, laporan);
                            } else if (laporan.jenis == 'stop'){
                              return isiStop(context, laporan);
                            } else {
                              return const Center(
                                child: SizedBox.shrink(),);
                            }
                          } else {
                            return const Center(
                              child: SizedBox.shrink(),);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child:
                      Column(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.lightBlueAccent),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(15)),
                                fixedSize: MaterialStateProperty.all(
                                    const Size(400, 60)),
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
                  ]
              )
          ),
        ),
      ),
    );
  }

  Widget konteks(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            maxLines: 4,
            controller: deskripsi,
            decoration: const InputDecoration(
              helperText: "",
              labelText: "Deskripsi",
              labelStyle: TextStyle(fontSize: 16),
            ),
          ),
          TextFormField(
            textAlign: TextAlign.center,
            controller: berkas,
            decoration: const InputDecoration(
              //icon of text field
              labelText: "Upload Berkas",
              labelStyle: TextStyle(fontSize: 16),
              icon: Icon(Icons.upload_file_outlined),//label text of field
            ),
            readOnly: true,  //set it true, so that user will not able to edit text
            onTap: () async {
              await getMultipleFiles();
            },
          ),
        ]
      ),
    );
  }
  Widget stepProses(BuildContext context, Laporan laporan) {
    int stepIni = laporan.proses - 1;
    String aidi = laporan.id;
    int stepDB = laporan.proses;
    List<Step> getProses()=> [
      Step(title: const Text('Pengaduan Diterima'), content: konteks(), isActive: stepIni >= 0, state: stepIni >= 0? StepState.complete : StepState.disabled),
      Step(title: const Text('Pengaduan dilaporkan kepada pimpinan'), content: konteks(), isActive: stepIni >= 1, state: stepIni >= 1? StepState.complete : StepState.disabled),
      Step(title: const Text('Provos melaksanakan pemanggilan kepada yang bersangkutan'), content: konteks(), isActive: stepIni >= 2, state: stepIni >= 2? StepState.complete : StepState.disabled),
      Step(title: const Text('Provos melaporkan kepada pimpinan hasil penyelidikan dan pemeriksaan awal'), content: konteks(), isActive: stepIni >= 3, state: stepIni >= 3? StepState.complete : StepState.disabled),
      Step(title: const Text('Provos melakukan BAP terhadap saksi dan terduga pelanggar'), content: konteks(), isActive: stepIni >= 4, state: stepIni >= 4? StepState.complete : StepState.disabled),
      Step(title: const Text('Provos menerbitkan Surat Pemberitahuan Perkembangan Hasil Penyelidikan Provos (SP2HP2) kepada pelapor'), content: konteks(), isActive: stepIni >= 5, state: stepIni >= 5? StepState.complete : StepState.disabled),
      Step(title: const Text('Provos melakukan pemberkasan Daftar Pemeriksaan Pendahuluan Pelanggaran Disiplin (DP3D) untuk dikirim ke Atasan Hukum'), content: konteks(), isActive: stepIni >= 6, state: stepIni >= 6? StepState.complete : StepState.disabled),
      Step(title: const Text('Provos meminta saran pendapat hukum ke Divisi Hukum Mabes Polri'), content: konteks(), isActive: stepIni >= 7, state: stepIni >= 7? StepState.complete : StepState.disabled),
      Step(title: const Text('Proses Sidang Disiplin'), content: konteks(), isActive: stepIni >= 8, state: stepIni >= 8? StepState.complete : StepState.disabled),
      Step(title: const Text('Terhukum mengajukan banding'), content: konteks(), isActive: stepIni >= 9, state: stepIni >= 9? StepState.complete : StepState.disabled),
      Step(title: const Text('Proses sidang lanjutan'), content: konteks(), isActive: stepIni >= 10, state: stepIni >= 10? StepState.complete : StepState.disabled),
      Step(title: const Text('Terhukum menjalankan putusan'), content: konteks(), isActive: stepIni >= 11, state: stepIni >= 11? StepState.complete : StepState.disabled),

    ];
    Widget controBuilder(context, details) {
      return Column(
        children: [
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: stepIni == 0 ? null : details.onStepCancel,
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)), child: const Icon(Icons.arrow_back_ios),
              ),
              const SizedBox(width: 20,),
              ElevatedButton(
                  onPressed: stepIni == 5 ? null : details.onStepContinue,
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.lightBlue)), child: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ],
      );
    }
    return Stepper(
          type: StepperType.vertical,
          physics: const ScrollPhysics(),
          steps: getProses(),
          currentStep: stepIni,
          onStepCancel: () async {
            const snak = SnackBar(content: Text('Proses berhasil dikembalikan'), duration: Duration(milliseconds: 1000));
            final storageRef = FirebaseStorage.instance.ref();
            final arah = storageRef.child("$aidi/berkas/$stepIni");
            setState(() => stepDB -= 1);
            final docLap = FirebaseFirestore.instance.collection('laporan').doc(laporan.id);
            await docLap.update({
              'proses': stepDB
            });
            var collection = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses');
            var snapshot = await collection.get();
            var doc = snapshot.docs.last;
            await doc.reference.delete();
            arah.listAll().then((value) {
              for (var element in value.items) {
                element.delete();
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(snak);
          },

          onStepContinue: () async{
            Future uploadBerkas(String id, int proses,  PlatformFile? k2) async{
              final path = '$id/berkas/$proses/${k2!.name}';
              final file = File(k2.path!);

              final ref = FirebaseStorage.instance.ref().child(path);
              await ref.putFile(file);
            }
            Future uploadFiles(String id, int proses, List<PlatformFile?> bukti) async {
              var buktiUrls = await Future.wait(bukti.map((bukti) => uploadBerkas(id, proses, bukti)));
              return buktiUrls;
            }
            const snak = SnackBar(content: Text('Proses berhasil dilanjutkan'), duration: Duration(milliseconds: 1000));

            setState(() => stepDB += 1);
            final docLap = FirebaseFirestore.instance.collection('laporan').doc(laporan.id);
            await docLap.update({
              'proses': stepDB
            });
            final nextnum = laporan.proses + 1;
            await createLini(context, laporan, deskripsi.text);
            if (files.isEmpty) {
            } else {
              await uploadFiles(id, nextnum, files);
            }
            deskripsi.clear();
            files.clear();
            if (laporan.email == ''){
            } else {
              await sendMail(laporan);
            }
            ScaffoldMessenger.of(context).showSnackBar(snak);
            },
          controlsBuilder: controBuilder,
        );
  }

  Widget isiLapor(BuildContext context, Laporan laporan) {
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

    return Column(
      children: [
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
                  controller: lapor11,
                  decoration: const InputDecoration(
                    helperText: "",
                    labelText: 'Deskripsi : ',
                    labelStyle: TextStyle(fontSize: 18),
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text('Bukti : ', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black87)),
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
                                      urel.add(url!);
                                      return Image(image: NetworkImage(url), fit: BoxFit.contain,);
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
        const SizedBox(height: 20,),
        /*ElevatedButton(
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                  Colors.lightBlueAccent),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.all(15)),
              fixedSize: MaterialStateProperty.all(
                  const Size(400, 60)),
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
            ListResult breh;
            ListResult bruh;
            breh = await FirebaseStorage.instance.ref('$id/bukti').listAll();
            bruh = await FirebaseStorage.instance.ref('$id/ktp').listAll();
            for (var element in breh.items) {
              download(context, element, id);
            }
            for (var element in bruh.items) {
              download(context, element, id);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 10,),
              Text("Unduh Data", textAlign: TextAlign.center,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.black87,
                    fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        const SizedBox(height: 20,),*/
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Proses : ', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black87)),
              const SizedBox(height: 10,),
              Container(
                decoration:   BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.lightBlue),
                ),
                height: 500,
                width: 350,
                child: FutureBuilder<Laporan?>(
                  future: ambilLaporan(serial: id),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      final proses = snapshot.data;
                      return stepProses(context, proses!);
                    } else {
                      return const Center(child: SizedBox(),);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20,),
        ElevatedButton(
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                  Colors.lightBlueAccent),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.all(15)),
              fixedSize: MaterialStateProperty.all(
                  const Size(400, 60)),
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
          onPressed: () {
            stopAlert(context, id);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 10,),
              Text("Pemberhentian Proses", textAlign: TextAlign.center,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.red.shade800,
                    fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ],
    );
  }

  Widget isiLimpah(BuildContext context, Laporan laporan) {
    TextEditingController lapor1 = TextEditingController(text: laporan.pengirim);
    TextEditingController lapor2 = TextEditingController(text: laporan.dari);
    TextEditingController lapor3 = TextEditingController(text: laporan.terlapor);
    TextEditingController lapor4 = TextEditingController(text: laporan.pangkat);
    TextEditingController lapor5 = TextEditingController(text: '${laporan.nrp}');
    TextEditingController lapor6 = TextEditingController(text: laporan.hpterlapor);
    TextEditingController lapor7 = TextEditingController(text: laporan.jabatan);
    TextEditingController lapor8 = TextEditingController(text: laporan.substaker);
    TextEditingController lapor9 = TextEditingController(text: laporan.deskripsi);

    return Column(
      children: [
        detilData(context, 'Pengirim : ', lapor1, laporan.id, 'pengirim'),
        detilData(context, 'Dilimpahkan Dari : ', lapor2, laporan.id, 'dari'),
        detilData(context, 'Terlapor : ', lapor3, laporan.id, 'terlapor'),
        detilData(context, 'Pangkat : ', lapor4 , laporan.id, 'pangkat'),
        detilData(context, 'NRP : ', lapor5, laporan.id, 'nrp'),
        detilData(context, 'No. Handphone : ', lapor6, laporan.id, 'hpterlapor'),
        detilData(context, 'Jabatan : ', lapor7, laporan.id, 'jabatan'),
        detilData(context, 'Sub Satuan Kerja : ', lapor8, laporan.id, 'substaker'),
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
                onTap: (){ubahAlert(context, 'Deskripsi : ', lapor9, laporan.id, 'deskripsi');},
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    readOnly: true,
                    controller: lapor9,
                    decoration: const InputDecoration(
                      helperText: "",
                      labelText: 'Deskripsi : ',
                      labelStyle: TextStyle(fontSize: 18),
                    ),
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text('Bukti : ', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black87)),
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
                                      urel.add(url!);
                                      return Image(image: NetworkImage(url), fit: BoxFit.contain,);
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
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Proses : ', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black87)),
              const SizedBox(height: 10,),
              Container(
                decoration:   BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.lightBlue),
                ),
                height: 500,
                width: 350,
                child: FutureBuilder<Laporan?>(
                  future: ambilLaporan(serial: id),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      final proses = snapshot.data;
                      return stepProses(context, proses!);
                    } else {
                      return const Center(child: SizedBox(),);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20,),
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
                      side: BorderSide(
                          color: Colors.red.shade800)
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
              Text("Pemberhentian Proses", textAlign: TextAlign.center,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.red.shade800,
                    fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ],
    );
  }

  Widget isiBatal(BuildContext context, Laporan laporan) {
    TextEditingController id = TextEditingController(text: laporan.id);
    TextEditingController deskripsi = TextEditingController(text: laporan.deskripsi);
    TextEditingController alasan = TextEditingController(text: laporan.alasan);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Pengaduan Telah Dibatalkan", style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.red),),
        const SizedBox(height: 20,),
        detilData(context, 'Nomor Seri', id, laporan.id, 'id'),
        detilData(context, 'Deskripsi', deskripsi, laporan.id, 'deskripsi'),
        detilData(context, 'Alasan Pencabutan', alasan, laporan.id, 'alasan'),
        const SizedBox(height: 20,),
        FutureBuilder<Laporan?>(
          future: ambilLaporan(serial: laporan.id),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final laporan = snapshot.data;
              return buildDetailProses(context, laporan!.id);
            } else {
              return const Center(child: SizedBox(),);
            }
          },
        ),
      ],
    );
  }

  Widget isiStop(BuildContext context, Laporan laporan) {
    TextEditingController id = TextEditingController(text: laporan.id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Pengaduan Telah Dihentikan", style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.red),),
        const SizedBox(height: 20,),
        detilData(context, 'Nomor Seri', id, laporan.id, 'id'),
        const SizedBox(height: 20,),
        FutureBuilder<Laporan?>(
          future: ambilLaporan(serial: laporan.id),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final laporan = snapshot.data;
              return buildDetailProses(context, laporan!.id);
            } else {
              return const Center(child: SizedBox(),);
            }
          },
        ),
      ],
    );
  }

  Future createLini(BuildContext context, Laporan laporan, String deskripsi) async {
    final skrng = DateTime.now();
    final DateFormat formatter = DateFormat('d MMMM y', 'id').add_jm();
    final waktu = formatter.format(skrng);
    final tahap = laporan.proses;
    final nomor = laporan.proses + 1;
    if (nomor == 2){
      String keter = 'Pengaduan dilaporkan kepada pimpinan';
      final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses').doc(nomor.toString());
      final timeline = Linimasa(
        proses: nomor,
        tanggal: waktu,
        keterangan: keter,
        deskripsi: deskripsi,
      );
      final json = timeline.toJson();
      await docTim.set(json);
    }
    else if (nomor == 3){
      String keter = 'Provos melaksanakan pemanggilan kepada yang bersangkutan';
      final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses').doc(nomor.toString());
      final timeline = Linimasa(
        proses: nomor,
        tanggal: waktu,
        keterangan: keter,
        deskripsi: deskripsi,
      );
      final json = timeline.toJson();
      await docTim.set(json);
    }
    else if (nomor == 4){
      String keter = 'Provos melaporkan kepada pimpinan hasil penyelidikan dan pemeriksaan awal';
      final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses').doc(nomor.toString());
      final timeline = Linimasa(
        proses: nomor,
        tanggal: waktu,
        keterangan: keter,
        deskripsi: deskripsi,
      );
      final json = timeline.toJson();
      await docTim.set(json);
    }
    else if (nomor == 5){
      String keter = 'Provos melakukan BAP terhadap saksi dan terduga pelanggar';
      final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses').doc(nomor.toString());
      final timeline = Linimasa(
        proses: nomor,
        tanggal: waktu,
        keterangan: keter,
        deskripsi: deskripsi,
      );
      final json = timeline.toJson();
      await docTim.set(json);
    }
    else if (nomor == 6){
      String keter = 'Provos menerbitkan Surat Pemberitahuan Perkembangan Hasil Penyelidikan Provos (SP2HP2) kepada pelapor';
      final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses').doc(nomor.toString());
      final timeline = Linimasa(
        proses: nomor,
        tanggal: waktu,
        keterangan: keter,
        deskripsi: deskripsi,
      );
      final json = timeline.toJson();
      await docTim.set(json);
    }
    else if (nomor == 7){
      String keter = 'Provos melakukan pemberkasan Daftar Pemeriksaan Pendahuluan Pelanggaran Disiplin (DP3D) untuk dikirim ke Atasan Hukum';
      final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses').doc(nomor.toString());
      final timeline = Linimasa(
        proses: nomor,
        tanggal: waktu,
        keterangan: keter,
        deskripsi: deskripsi,
      );
      final json = timeline.toJson();
      await docTim.set(json);
    }
    else if (nomor == 8){
      String keter = 'Provos meminta saran pendapat hukum ke Divisi Hukum Mabes Polri';
      final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses').doc(nomor.toString());
      final timeline = Linimasa(
        proses: nomor,
        tanggal: waktu,
        keterangan: keter,
        deskripsi: deskripsi,
      );
      final json = timeline.toJson();
      await docTim.set(json);
    }
    else if (nomor == 9){
      String keter = 'Proses Sidang Disiplin';
      final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses').doc(nomor.toString());
      final timeline = Linimasa(
        proses: nomor,
        tanggal: waktu,
        keterangan: keter,
        deskripsi: deskripsi,
      );
      final json = timeline.toJson();
      await docTim.set(json);
    }
    else if (nomor == 10){
      String keter = 'Terhukum mengajukan banding';
      final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses').doc(nomor.toString());
      final timeline = Linimasa(
        proses: nomor,
        tanggal: waktu,
        keterangan: keter,
        deskripsi: deskripsi,
      );
      final json = timeline.toJson();
      await docTim.set(json);
    }
    else if (nomor == 11){
      String keter = 'Proses sidang lanjutan';
      final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses').doc(nomor.toString());
      final timeline = Linimasa(
        proses: nomor,
        tanggal: waktu,
        keterangan: keter,
        deskripsi: deskripsi,
      );
      final json = timeline.toJson();
      await docTim.set(json);
    }
    else if (nomor == 12){
      String keter = 'Terhukum menjalankan putusan';
      final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses').doc(nomor.toString());
      final timeline = Linimasa(
        proses: nomor,
        tanggal: waktu,
        keterangan: keter,
        deskripsi: deskripsi,
      );
      final json = timeline.toJson();
      await docTim.set(json);
    }
    else {
      String keter = 'Pengaduan terkirim';
      final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses').doc(nomor.toString());
      final timeline = Linimasa(
        proses: nomor,
        tanggal: waktu,
        keterangan: keter,
        deskripsi: deskripsi,
      );
      final json = timeline.toJson();
      await docTim.set(json);
    }
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
            title: const Text('Pemberhentian Proses'),
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
                      stopUrel.add(imageone.path!);
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
                          const snak = SnackBar(content: Text('Pengaduan dihentikan'));
                          Navigator.pop(context);
                          setState(() {
                            isLoading = true;
                          });
                          DateTime tanggal = DateTime.now();
                          final DateFormat formatter = DateFormat('d MMMM y', 'id').add_jm();
                          String keter = 'Proses Dihentikan';
                          final docTim = FirebaseFirestore.instance.collection('timeline').doc(laporan.id).collection('proses').doc(nextnum.toString());
                          final timeline = Linimasa(
                            proses: nextnum,
                            tanggal: formatter.format(tanggal),
                            keterangan: keter,
                            deskripsi: deskripsi.text,
                          );
                          final json = timeline.toJson();
                          await docTim.set(json);
                          final docLap = FirebaseFirestore.instance.collection('laporan').doc(id);
                          await uploadFiles(id, nextnum);
                          await docLap.update({
                            'proses' : 0,
                            'jenis' : 'stop',
                          });
                          if(laporan.email == ''){
                          } else {
                            await sendHenti(laporan, deskripsi.text);
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
                            Text('Hentikan Proses', style : TextStyle(color: Colors.red.shade800)),
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
}