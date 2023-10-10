import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:p88/model/model.dart';
import 'package:p88/pages/client/lapor_detail.dart';
import 'package:p88/pages/client/proses_detail.dart';
import 'package:page_route_animator/page_route_animator.dart';

import '../admin/admin_widget.dart';
import '../widgets.dart';

class cekPengaduan extends StatefulWidget {
  const cekPengaduan({Key? key}) : super(key: key);

  @override
  State<cekPengaduan> createState() => _cekPengaduanState();
}

class _cekPengaduanState extends State<cekPengaduan> {
  TextEditingController cari = TextEditingController();
  final DateFormat formatter = DateFormat('d MMMM y', 'id');

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          toolbarHeight: 75,
          shadowColor: Colors.black87,
          title: Text("#88", style: Theme
              .of(context)
              .textTheme
              .headlineMedium?.copyWith(color: Colors.black),),
          centerTitle: true,
          elevation: 0,

        ),
        body:
            Center(

          child:
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
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
                        reuseJudul(context, 'Cek Pengaduan', Colors.black),
                        const SizedBox(height: 10,),
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
                const SizedBox(height: 15,),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        PageRouteAnimator(
                          child: LaporDetail(id: cari.text),
                          routeAnimation: RouteAnimation.fadeAndScale,
                          curve: Curves.easeOut,
                        )
                    );
                  },
                  child: FutureBuilder<Laporan?>(
                    future: ambilLaporan(serial: cari.text),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        final laporan = snapshot.data;
                        if (laporan!.jenis == 'lapor'){
                          return buildLaporan(context, laporan);
                        } else if (laporan.jenis == 'limpah'){
                          return buildLimpahan(context, laporan);
                        } else if (laporan.jenis == 'batal'){
                          return buildBatal(laporan);
                        } else {
                          return const Center(child: SizedBox(),);
                        }
                      } else {
                        return const Center(child: SizedBox(),);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 15,),
                GestureDetector(
                  onTap: () {Navigator.of(context).push(
                      PageRouteAnimator(
                        child: ProsesDetail(id: cari.text),
                        routeAnimation: RouteAnimation.fadeAndScale,
                        curve: Curves.easeOut,
                      )
                  );},
                  child: FutureBuilder<Laporan?>(
                   future: ambilLaporan(serial: cari.text),
                   builder: (context, snapshot){
                     if(snapshot.hasData){
                       final proses = snapshot.data;
                       return buildProses(context, proses!);
                     } else {
                       return const Center(child: SizedBox(),);
                     }
                   },
               ),
                ),
                const SizedBox(height: 15,),
                FutureBuilder<Laporan?>(
                  future: ambilLaporan(serial: cari.text),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      final laporan = snapshot.data;
                      return buildDetailProses(context, laporan!.id);
                    } else {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                  },
                ),

                const SizedBox(height: 20,),
              ],
              ),
                  ),
            ),
      )
    )
    );
  }
  Widget buildBatal(Laporan laporan) {
    return  Column(
        children: [
          Container(
            height: 110,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration:  const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [BoxShadow(
                  color: Colors.black45,
                  offset: Offset(0, 7),
                  spreadRadius: 1,
                  blurRadius: 20,
                )]
            ),
            child: ListView(
              children: [
                Text(laporan.id, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600 ),),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Dibatalkan', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w600 )),
                  ],
                ),
              ],
            ),),
        ]
    );
  }
}
