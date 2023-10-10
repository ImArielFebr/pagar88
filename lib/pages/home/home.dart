import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p88/pages/client/batal.dart';
import 'package:p88/pages/client/cek.dart';
import 'package:p88/pages/client/informasi.dart';

import '../widgets.dart';
import '../client/aduform.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        toolbarHeight: 75,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,),
          child: Image(
            width: MediaQuery.of(context).size.width/11,
            height: MediaQuery.of(context).size.width/11,
            image: const AssetImage("assets/densus.png"), fit: BoxFit.contain,),
        ),
        title: SizedBox(height: MediaQuery.of(context).size.height/16, child: const FittedBox(child: Text("#88", style: TextStyle(fontWeight: FontWeight.bold),))),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          GestureDetector(
            onTap: (){
              loginAlert(context);
            },
            child:
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,),
              child: Image(
                width: MediaQuery.of(context).size.width/11,
                height: MediaQuery.of(context).size.width/11,
                image: const AssetImage("assets/provos.png"),),
            )
          ),

        ],
      ),
      body:
          SingleChildScrollView(
            child:
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.lightBlue
                ),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height/4.5,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration:  const BoxDecoration(
                          boxShadow: [BoxShadow(color: Colors.black54,
                            offset: Offset(0, 5),
                            spreadRadius: 1,
                            blurRadius: 20,)],
                          color: Colors.white,
                          image: DecorationImage(image: AssetImage("assets/polisi.png"), alignment: Alignment.centerRight, opacity: 0.3, fit: BoxFit.fitHeight),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            title: SizedBox(height: MediaQuery.of(context).size.height/32, child: const FittedBox(alignment: Alignment.centerLeft ,child: Text("Selamat Datang di", style: TextStyle(color: Colors.black)))),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height/22, child: const FittedBox(alignment: Alignment.centerLeft ,child: Text("Pagar88", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),))),
                                  SizedBox(height: MediaQuery.of(context).size.height/32, child: const FittedBox(alignment: Alignment.centerLeft ,child: Text("Pengaduan Pelanggaran Densus 88 AT Polri", style: TextStyle(color: Colors.black))))
                                ]),)
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/20,),
                    tekan(context, const Aduform(), "Buat Pengaduan", Icons.add_circle_outline, Colors.lightBlue, Colors.white, Colors.black),
                    SizedBox(height: MediaQuery.of(context).size.height/70,),
                    tekan(context, const cekPengaduan(), "Cek Pengaduan", Icons.check_circle_outline, Colors.lightBlue, Colors.white, Colors.black),
                    SizedBox(height: MediaQuery.of(context).size.height/70,),
                    tekan(context, const BatalPage(), "Cabut Pengaduan", Icons.do_disturb, Colors.lightBlue, Colors.white, Colors.black),
                    SizedBox(height: MediaQuery.of(context).size.height/70,),
                    tekan(context, const Informasi(), "Panduan", Icons.info_outline, Colors.lightBlue, Colors.white, Colors.black)
                  ],
                ),
              ),
          ),
      );
  }

}