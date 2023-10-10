import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../loading.dart';

class Pengguna extends StatefulWidget {
  const Pengguna({Key? key}) : super(key: key);

  @override
  State<Pengguna> createState() => _PenggunaState();
}

class _PenggunaState extends State<Pengguna> {
  final user = FirebaseAuth.instance.currentUser!;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading? const Loading() : Scaffold(
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
        color: Colors.lightBlue,
        padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
              height: 100,
              width: 100,
              child: Image(image: AssetImage('assets/densus.png'), fit: BoxFit.contain,),
            ),
              SizedBox(width: 20,),
              SizedBox(
                height: 100,
                width: 100,
                child: Image(image: AssetImage('assets/provos.png'), fit: BoxFit.contain,),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Text(user.email!, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black),),
          SizedBox(height: MediaQuery.of(context).size.height/15),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.lightBlue),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                  fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 12)),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  animationDuration: const Duration(milliseconds: 500),
                  elevation: MaterialStateProperty.all(10),
                  shadowColor: MaterialStateProperty.all(Colors.black),
                  alignment: Alignment.centerLeft,
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      )
                  )
              ),
              onPressed: () {
                tambahAlert(context);
              },
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 10,),
                  Icon(Icons.account_box_outlined, fill: 1, size: MediaQuery.of(context).size.height/20, color: Colors.black,),
                  const SizedBox(width: 10,),
                  Text('Tambah Admin', style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.lightBlue),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                  fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 12)),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  animationDuration: const Duration(milliseconds: 500),
                  elevation: MaterialStateProperty.all(10),
                  shadowColor: MaterialStateProperty.all(Colors.black),
                  alignment: Alignment.centerLeft,
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      )
                  )
              ),
              onPressed: () {
                resetPassword(user.email!);
              },
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 10,),
                  Icon(Icons.password_outlined, fill: 1, size: MediaQuery.of(context).size.height/20, color: Colors.black,),
                  const SizedBox(width: 10,),
                  Text('Ubah Kata Sandi', style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.lightBlue),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                  fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 12)),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  animationDuration: const Duration(milliseconds: 500),
                  elevation: MaterialStateProperty.all(10),
                  shadowColor: MaterialStateProperty.all(Colors.black),
                  alignment: Alignment.centerLeft,
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      )
                  )
              ),
              onPressed: () {
                emailNotifikasi(context);
              },
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 10,),
                  Icon(Icons.email_outlined, fill: 1, size: MediaQuery.of(context).size.height/20, color: Colors.black,),
                  const SizedBox(width: 10,),
                  Text('Ubah Email Notifikasi', style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height/20,),
          Container(
            height: MediaQuery.of(context).size.height / 6,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                      fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 12)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      animationDuration: const Duration(milliseconds: 500),
                      elevation: MaterialStateProperty.all(10),
                      shadowColor: MaterialStateProperty.all(Colors.black87),
                      alignment: Alignment.centerLeft,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: const BorderSide(color: Colors.black, width: 2),
                          )
                      )
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Tutup', style: Theme
                          .of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
    )
    );
  }

  void tambahAlert(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    Future tambahUser(String email, String password) async {
      const snak = SnackBar(content: Text('Admin baru berhasil ditambahkan'));
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email, password: password);

        return ScaffoldMessenger.of(context).showSnackBar(snak);
      } on FirebaseAuthException catch (e) {
        return print(e);
      }
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Tambah Admin'),
            content: Container(
              height: MediaQuery.of(context).size.height / 3,
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
                      setState(() {
                        isLoading = true;
                      });
                      await tambahUser(email.text, password.text);
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: const <Widget>[
                        Text('Tambahkan'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
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
  Future resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return passwordEmail;
  }
  void passwordEmail(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Periksa inbox / spam email anda dan klik link yang tertera untuk mengubah kata sandi'),
            content: Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  <Widget>[
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
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
  
  void emailNotifikasi(BuildContext context){
    TextEditingController bruh = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Ubah Email Notifikasi Tujuan'),
            content: Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  <Widget>[
                  TextField(
                    controller: bruh,),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () {
                      const snak = SnackBar(content: Text('Email berhasil diubah'));
                      final docLap = FirebaseFirestore.instance.collection('tujuan').doc('thetujuan');
                      docLap.update({
                        'email': bruh
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(snak);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text('Ubah'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
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
