import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:p88/pages/admin/admin.dart';

import 'package:p88/pages/pdf_laporan.dart';

import 'package:p88/model/model.dart';
import 'package:path_provider/path_provider.dart';

Future createLimpahan(BuildContext context, String terlapor, String pangkat, String nrp, String hpterlapor, String jabatan, String substaker, String ket, {required List<PlatformFile?> k3, required String pengirim, required String dari, required String deskripsi}) async {
  int nom = 1;
  String namba = NumberFormat("000").format(nom);
  DateTime now = DateTime.now();
  String l12 = DateFormat('d MMMM y').add_jm().format(now);
  String harini = DateFormat('ddMMyy').format(now);
  String doki = '$harini$namba';
  const nomor = 1;

  Future _uploadBukti(String id, PlatformFile? k2) async{
    final path = '$id/bukti/${k2!.name}';
    final file = File(k2.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
  }
  Future _uploadFiles(String id, List<PlatformFile?> bukti) async {
    var buktiUrls = await Future.wait(bukti.map((bukti) => _uploadBukti(id, bukti)));
    return buktiUrls;
  }
  Future uploadPDF(String id) async {
    try {
      final appDocumentDir = await getExternalStorageDirectory();
      final pather = appDocumentDir!.path;
      final file = File('$pather/surat_pelimpahan_#88.pdf');
      final path = '$id/pdf/surat_pelimpahan_#88.pdf';

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
          pengirim: pengirim,
          dari: dari,
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
          jenis: 'limpah',
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
        await limpahPdf(terlapor, pangkat, nrp, jabatan, substaker, hpterlapor,ket, doki: yoda, pengirim: pengirim, dari: dari, deskripsi: deskripsi, );
        await docLpr.set(json);
        await docTim.set(jason);
        await _uploadFiles(yoda, k3);
        await uploadPDF(yoda);
        limpahanAlert(context, yoda);
      }
      else {
        final docLpr = FirebaseFirestore.instance.collection('laporan').doc(doki);
        final docTim = FirebaseFirestore.instance.collection('timeline').doc(
            doki).collection('proses').doc(nomor.toString());
        final laporan = Laporan(
          id : doki,
          pengirim: pengirim,
          dari: dari,
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
          jenis: 'limpah',
        );
        final timeline = Linimasa(
          proses: nomor,
          tanggal: l12,
          keterangan: 'Pengaduan Terkirim',
        );
        final json = laporan.toJson();
        final jason = timeline.toJson();
        await limpahPdf(terlapor, pangkat, nrp, jabatan, substaker, hpterlapor,ket, doki: doki, pengirim: pengirim, dari: dari, deskripsi: deskripsi, );
        await docLpr.set(json);
        await docTim.set(jason);
        await _uploadFiles(doki, k3);
        await uploadPDF(doki);
        limpahanAlert(context, docLpr.id);
      }
    });
  } catch (e) {
    // If any error
    return false;
  }
}

void limpahanAlert(BuildContext context, String id){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Pelimpahan Berhasil Dikirim!', textAlign: TextAlign.center,),
          content: Container(
            height: MediaQuery.of(context).size.height / 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  <Widget>[
                const Text('Nomor Seri pengaduan'),
                Text(id, style: Theme.of(context).textTheme.headlineSmall,),
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

Widget buildLimpahan(BuildContext context, Laporan laporan) {
  return Container(
    height: MediaQuery.of(context).size.height/6.5,
    padding: const EdgeInsets.all(20),
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
        Text(laporan.id, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black)),
        Row(children: [
          Text('Dilimpahkan Dari :', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87)),
          Text(laporan.dari, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black)),
        ]),
        Row(children: [
          Text('Terlapor :', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87)),
          Text(laporan.terlapor, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black)),
        ]),
        Row(children: [
          Text('Tanggal Pengaduan : ', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87)),
          Text(laporan.tgllapor, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black)),
        ]),
      ],
    ),);
}

void delAlert(BuildContext context, String id){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Apakah anda yakin ingin menghapus pengaduan ini?'),
          content: Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.lightBlueAccent),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.all(15)),
                      fixedSize: MaterialStateProperty.all(
                          const Size(400, 45)),
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
                      const snak = SnackBar(content: Text('Pengaduan Dihapus'), duration: Duration(milliseconds: 1000));
                      var collectionl = FirebaseFirestore.instance.collection('laporan').doc(id);
                      await collectionl.update({
                        'jenis': 'hapus',
                        'proses' : 0,
                      });
                      var collection = FirebaseFirestore.instance.collection('timeline').doc(id).collection('proses');
                      var snapshot = await collection.get();
                      var doc = snapshot.docs.toList();
                      for (var element in doc) {
                        await element.reference.delete();
                      }

                      final storageRef = FirebaseStorage.instance.ref();
                      final berkas1 = storageRef.child('$id/berkas/1');
                      final berkas2 = storageRef.child('$id/berkas/2');
                      final berkas3 = storageRef.child('$id/berkas/3');
                      final berkas4 = storageRef.child('$id/berkas/4');
                      final berkas5 = storageRef.child('$id/berkas/5');
                      final berkas6 = storageRef.child('$id/berkas/6');
                      final berkas7 = storageRef.child('$id/berkas/7');
                      final berkas8 = storageRef.child('$id/berkas/8');
                      final berkas9 = storageRef.child('$id/berkas/9');
                      final berkas10 = storageRef.child('$id/berkas10');
                      final berkas11 = storageRef.child('$id/berkas/11');
                      final berkas12 = storageRef.child('$id/berkas/12');
                      final pdf = storageRef.child('$id/pdf');
                      final bukti = storageRef.child('$id/bukti');
                      final ktp = storageRef.child('$id/ktp');
                      final batal = storageRef.child('$id/batal');

                      berkas1.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      berkas2.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      berkas3.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      berkas4.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      berkas5.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      berkas6.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      berkas7.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      berkas8.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      berkas9.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      berkas10.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      berkas11.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      berkas12.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      pdf.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      bukti.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      batal.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });
                      ktp.listAll().then((value) {
                        for (var element in value.items) {
                          element.delete();
                        }
                      });

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(snak);
                      },
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Hapus', style : TextStyle(color: Colors.red.shade800)),
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
                          const Size(400, 45)),
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


