
import 'dart:isolate';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:p88/model/model.dart';
import 'package:p88/pages/widgets.dart';

class ProsesDetail extends StatefulWidget {
  String id;
  ProsesDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<ProsesDetail> createState() => _ProsesDetailState(id);
}

class _ProsesDetailState extends State<ProsesDetail> {
  String id;
  _ProsesDetailState(this.id);

  late Future<ListResult> futureFiles;
  final ReceivePort _port = ReceivePort();

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
          child: StreamBuilder<List<Linimasa>>(
              stream: ambilLini(id: id),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  final linimasa = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: linimasa.map(buildLini).toList(),
                  );
                }
                else {
                  return const Center(child: SizedBox(),);
                }
              }),
        ),
      ),
    );
  }
  Widget buildLini(Linimasa linimasa) {
    TextEditingController ket = TextEditingController(text: linimasa.keterangan);
    TextEditingController tgl = TextEditingController(text: linimasa.tanggal);
    TextEditingController deskripsi = TextEditingController(text: linimasa.deskripsi);
    TextEditingController nomor = TextEditingController(text: linimasa.proses.toString());
    futureFiles = FirebaseStorage.instance.ref('$id/berkas/${nomor.text}').listAll();

    return Column(
      children: [
        const SizedBox(height: 20,),
        TextField(
          controller: ket,
          decoration: const InputDecoration(
            border: InputBorder.none,
            helperText: "",
            labelText: 'Proses',
            labelStyle: TextStyle(fontSize: 18),
          ),
        ),
        TextField(
          controller: tgl,
          decoration: const InputDecoration(
            border: InputBorder.none,
            helperText: "",
            labelText: 'Tanggal',
            labelStyle: TextStyle(fontSize: 18),
          ),
        ),
        TextField(
          controller: deskripsi,
          decoration: const InputDecoration(
            border: InputBorder.none,
            helperText: "",
            labelText: 'Keterangan',
            labelStyle: TextStyle(fontSize: 18),
          ),
        ),
        const Text('Berkas :'),
        const SizedBox(height: 10,),
        FutureBuilder(
            future: futureFiles,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final files = snapshot.data!.items;
                return SizedBox(
                    height: 200,
                    width: 300,
                    child:ListView.builder(
                      padding: const EdgeInsets.all(1),
                      scrollDirection: Axis.horizontal,
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final file = files[index];
                        return Column(
                          children: [
                            FullScreenWidget(
                              disposeLevel: DisposeLevel.Low,
                              child: Center(
                                child: SizedBox(
                                    height: 130,
                                    width: 150,
                                    child:Column(
                                      children: [
                                        FutureBuilder<String?>(
                                            future: getBerkas(file.name, id, linimasa.proses.toString()),
                                            builder: (context, snapshot){
                                              if (snapshot.hasData){
                                                final String? url = snapshot.data;
                                                return Column(
                                                  children: [
                                                    const Icon(Icons.file_copy, size: 90,),
                                                    const SizedBox(height:5),
                                                    Text(file.name),
                                                  ],
                                                );
                                              } else {
                                                return const Icon(Icons.image);
                                              } }
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            ),
                            /*const SizedBox(height: 5,),
                            ElevatedButton(
                              style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.lightBlueAccent),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(2)),
                                  fixedSize: MaterialStateProperty.all(
                                      const Size(150, 30)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.white),
                                  elevation: MaterialStateProperty.all(0),
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
                                const snak = SnackBar(content: Text('Berkas berhasil diunduh'));
                                ListResult breh;
                                breh = await FirebaseStorage.instance.ref('$id/berkas/${nomor.text}').listAll();
                                for (var element in breh.items){
                                  await download(context, element, id);
                                };
                                ScaffoldMessenger.of(context).showSnackBar(snak);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  const SizedBox(width: 10,),
                                  Text("Unduh", textAlign: TextAlign.center,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: Colors.black,
                                        fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),*/
                          ],
                        );
                      },
                    ));
              }
              else {
                return const Icon(Icons.image);
              }
            }

        ),
        const Divider(thickness: 1, color: Colors.black54,)
      ],
    );
  }
}

