import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p88/pages/admin/user.dart';

import '../widgets.dart';
import 'cek_admin.dart';
import 'limpahform.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
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
          child: const Image(
            width: 50,
            height: 50,
            image: AssetImage("assets/densus.png"), fit: BoxFit.contain,),
        ),
        title: Text("#88", style: Theme
            .of(context)
            .textTheme
            .headlineMedium?.copyWith(color: Colors.black),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            child: const Icon(Icons.logout, size: 30,),
          ),
          const SizedBox(width: 20,),
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
                    image: DecorationImage(image: AssetImage("assets/provos.png"), alignment: Alignment.centerRight, opacity: 0.3, fit: BoxFit.contain),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      title: SizedBox(height: MediaQuery.of(context).size.height/32, child: const FittedBox(alignment: Alignment.centerLeft ,child: Text("Panel Admin", style: TextStyle(color: Colors.black)))),
                      subtitle:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height/22, child: const FittedBox(alignment: Alignment.centerLeft ,child: Text("Pagar88", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),))),
                            SizedBox(height: MediaQuery.of(context).size.height/32, child: const FittedBox(alignment: Alignment.centerLeft ,child: Text("Pengaduan Pelanggaran Densus 88 AT Polri", style: TextStyle(color: Colors.black))))
                          ]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/20,),
              tekan(context, const LimpahForm(), "Pelimpahan Pengaduan", Icons.add_circle_outline, Colors.lightBlue, Colors.white, Colors.black),
              SizedBox(height: MediaQuery.of(context).size.height/70,),
              tekan(context, const CekAdmin(), "Pustaka Pengaduan", Icons.list_alt_outlined, Colors.lightBlue, Colors.white, Colors.black),
              SizedBox(height: MediaQuery.of(context).size.height/70,),
              tekan(context, const Pengguna(), "Pengaturan Akun", Icons.account_circle_outlined, Colors.lightBlue, Colors.white, Colors.black),
            ],
          ),

        ),
      ),
    );
  }

}
