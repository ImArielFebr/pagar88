import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

Future<void> makePdf(String terlapor, String pangkat, String nrp, String hpterlapor, String jabatan, String substaker, String ket,{required String doki, required String pelapor, required int nik,  required String tptlhr,  required String tgllhr,  required String hppelapor, required String email, required String deskripsi}) async {
  final pdf = pw.Document();
  DateTime now = DateTime.now();
  String tanggall = DateFormat('d MMMM y').format(now);
  final densusLogo = pw.MemoryImage((await rootBundle.load('assets/densus.png')).buffer.asUint8List());
  final provosLogo = pw.MemoryImage((await rootBundle.load('assets/provos.png')).buffer.asUint8List());
  pdf.addPage(
      pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(
                    height: 30,
                    width:30,
                    child: pw.Image(densusLogo),
                  ),
                  pw.Column(
                    children: [
                      pw.Text("Surat Penerimaan Surat Pengaduan Provos (SPSP2)", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                    ],
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                  ),
                  pw.SizedBox(
                    height: 30,
                    width: 30,
                    child: pw.Image(provosLogo),
                  )
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(
                height: 5,
                borderStyle: pw.BorderStyle.solid,
              ),
              pw.SizedBox(height: 30),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Nomor Seri : $doki"),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Kepada Yth."),
                  pw.Text("Kadensus 88 AT Polri"),
                  pw.Text("Di Jakarta"),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Dengan hormat,"),
                  pw.Text("Saudara/i dengan identitas di bawah ini:"),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.SizedBox(width: 120, child: pw.Text('NIK')),
                      pw.SizedBox(child: pw.Text(': $nik'))
                    ]
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 120, child: pw.Text('Nama')),
                        pw.SizedBox(child: pw.Text(': $pelapor'))
                      ]
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 120, child: pw.Text('Tempat Lahir')),
                        pw.SizedBox(child: pw.Text(': $tptlhr'))
                      ]
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 120, child: pw.Text('Tanggal Lahir')),
                        pw.SizedBox(child: pw.Text(': $tgllhr'))
                      ]
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 120, child: pw.Text('No Handphone')),
                        pw.SizedBox(child: pw.Text(': $hppelapor'))
                      ]
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 120, child: pw.Text('Email')),
                        pw.SizedBox(child: pw.Text(': $email'))
                      ]
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Column(
                children: [
                  pw.Text("Dengan ini melaporkan seseorang yang identitasnya dibawah ini :"),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 120, child: pw.Text('Nama')),
                        pw.SizedBox(child: pw.Text(': $terlapor'))
                      ]
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 120, child: pw.Text('Pangkat')),
                        pw.SizedBox(child: pw.Text(': $pangkat'))
                      ]
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 120, child: pw.Text('NRP')),
                        pw.SizedBox(child: pw.Text(': $nrp'))
                      ]
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 120, child: pw.Text('No. Handphone')),
                        pw.SizedBox(child: pw.Text(': $hpterlapor'))
                      ]
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 120, child: pw.Text('Jabatan')),
                        pw.SizedBox(child: pw.Text(': $jabatan'))
                      ]
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 120, child: pw.Text('Sub Satuan Kerja')),
                        pw.SizedBox(child: pw.Text(': $substaker'))
                      ]
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 120, child: pw.Text('Keterangan Lain')),
                        pw.SizedBox(child: pw.Text(': $ket'))
                      ]
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Text('Deskripsi Perkara'),
              pw.Text(deskripsi),
              pw.SizedBox(height: 20),
              pw.Text('Sebagai bahan bukti, berikut terlampir foto/video kejadian perkara'),
              pw.SizedBox(height: 10),
              pw.Divider(
                height: 1,
                borderStyle: pw.BorderStyle.dashed,
              ),
              pw.SizedBox(height: 20),
              pw.Text('Demikian laporan pengaduan ini dibuat untuk membantu menyelesaikan perkara yang tertera. Terima kasih atas perhatiannya.'),
              pw.SizedBox(height: 40),
              pw.Row(
                children: [
                  pw.Text(tptlhr),
                  pw.SizedBox(width: 5,),
                  pw.Text(tanggall),
                ]
              ),
              pw.SizedBox(height: 40),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(pelapor),
                  pw.Text("Pelapor"),
                ],
              ),
            ]
    );}));
  final output = (await getExternalStorageDirectory())?.path;
  final file = File("$output/surat_pengaduan_#88.pdf");
  await file.writeAsBytes(await pdf.save());
}

Future<void> limpahPdf(String terlapor, String pangkat, String nrp, String jabatan, String substaker, String hpterlapor, String ket, {required String doki, required String pengirim,  required String dari, required String deskripsi}) async {
  final pdf = pw.Document();
  DateTime now = DateTime.now();
  String tanggall = DateFormat('d MMMM y').format(now);
  final densusLogo = pw.MemoryImage((await rootBundle.load('assets/densus.png')).buffer.asUint8List());
  final provosLogo = pw.MemoryImage((await rootBundle.load('assets/provos.png')).buffer.asUint8List());
  pdf.addPage(
      pw.Page(
          build: (context) {
            return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.SizedBox(
                        height: 30,
                        width:30,
                        child: pw.Image(densusLogo),
                      ),
                      pw.Column(
                        children: [
                          pw.Text("Surat Penerimaan Surat Pengaduan Provos (SPSP2)", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                        ],
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                      ),
                      pw.SizedBox(
                        height: 30,
                        width: 30,
                        child: pw.Image(provosLogo),
                      )
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(
                    height: 5,
                    borderStyle: pw.BorderStyle.solid,
                  ),
                  pw.SizedBox(height: 30),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text("Nomor Seri : $doki"),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text("Kepada Yth."),
                      pw.Text("Kadensus 88 AT Polri"),
                      pw.Text("Di Jakarta"),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Dengan hormat,"),
                      pw.Text("Dengan diterimanya surat limpahan:"),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.SizedBox(width: 120, child: pw.Text('Pengirim')),
                            pw.SizedBox(child: pw.Text(': $pengirim'))
                          ]
                      ),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.SizedBox(width: 120, child: pw.Text('Dilimpahkan Dari')),
                            pw.SizedBox(child: pw.Text(': $dari'))
                          ]
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Column(
                    children: [
                      pw.Text("Dengan ini melaporkan seseorang yang identitasnya dibawah ini :"),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.SizedBox(width: 120, child: pw.Text('Nama')),
                            pw.SizedBox(child: pw.Text(': $terlapor'))
                          ]
                      ),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.SizedBox(width: 120, child: pw.Text('NRP')),
                            pw.SizedBox(child: pw.Text(': $nrp'))
                          ]
                      ),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.SizedBox(width: 120, child: pw.Text('Pangkat')),
                            pw.SizedBox(child: pw.Text(': $pangkat'))
                          ]
                      ),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.SizedBox(width: 120, child: pw.Text('No. Handphone')),
                            pw.SizedBox(child: pw.Text(': $hpterlapor'))
                          ]
                      ),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.SizedBox(width: 120, child: pw.Text('Jabatan')),
                            pw.SizedBox(child: pw.Text(': $jabatan'))
                          ]
                      ),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.SizedBox(width: 120, child: pw.Text('Sub Satuan Kerja')),
                            pw.SizedBox(child: pw.Text(': $substaker'))
                          ]
                      ),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.SizedBox(width: 120, child: pw.Text('Keterangan Lain')),
                            pw.SizedBox(child: pw.Text(': $ket'))
                          ]
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 30),
                  pw.Text('Deskripsi Perkara'),
                  pw.Text(deskripsi),
                  pw.SizedBox(height: 20),
                  pw.Text('Sebagai bahan bukti, berikut terlampir foto/video kejadian perkara'),
                  pw.SizedBox(height: 10),
                  pw.Divider(
                    height: 1,
                    borderStyle: pw.BorderStyle.dashed,
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text('Demikian laporan pengaduan ini dibuat untuk membantu menyelesaikan perkara yang tertera. Terima kasih atas perhatiannya.'),
                  pw.SizedBox(height: 40),
                  pw.Row(
                      children: [
                        pw.Text('Jakarta,'),
                        pw.SizedBox(width: 5,),
                        pw.Text(tanggall),
                      ]
                  ),
                  pw.SizedBox(height: 40),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(pengirim),
                      pw.Text("Pengirim"),
                    ],
                  ),
                ]
            );}));
  final output = (await getExternalStorageDirectory())?.path;
  final file = File("$output/surat_pelimpahan_#88.pdf");
  await file.writeAsBytes(await pdf.save());
}