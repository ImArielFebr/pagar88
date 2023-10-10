import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TutorialBuat extends StatefulWidget {
  const TutorialBuat({Key? key}) : super(key: key);

  @override
  State<TutorialBuat> createState() => _TutorialBuatState();
}

class _TutorialBuatState extends State<TutorialBuat> {
  final PageController _pageController = PageController();
  bool isLastPage = false;

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 75,
        shadowColor: Colors.black87,
        title: Text("#88", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 3);
          },
          children: [
            buildPage('assets/buat1.gif', 'Buat Pengaduan', 'Tekan tombol Buat Pengaduan untuk membuka halaman pengisian formulir Pengaduan'),
            buildPage('assets/buat2.gif', 'Isi Formulir', 'Isi formulir dengan lengkap untuk memudahkan kelancaran proses pengaduan'),
            buildPage('assets/buat3.gif', 'Kirim Pengaduan', 'Tekan tombol kirim, dan tunggu hingga nomor seri diterbitkan'),
            buildPage('assets/buat4.gif', 'Simpan Nomor Seri', 'Selamat! nomor seri berhasil diterbitkan dan dapat digunakan untuk Cek Pengaduan'),
          ],
        ),
      ),
          bottomSheet: isLastPage? 
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlue,
                  minimumSize: Size.fromHeight(MediaQuery.of(context).size.height / 10),
                ),
                  onPressed: () {
                  Navigator.pop(context);
                  },
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height/40,
                      child: const FittedBox(child: Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)))
              )
          :
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height / 10,
                color: Colors.lightBlue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(style: ButtonStyle(elevation: MaterialStateProperty.all(10),
                        overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        animationDuration: const Duration(milliseconds: 400),
                        shadowColor: MaterialStateProperty.all(Colors.black87),
                        foregroundColor: MaterialStateProperty.all(Colors.black),),
                        onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut), child: const Icon(Icons.arrow_back_ios_rounded)),
                    Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: 4,
                          effect: const JumpingDotEffect(
                            activeDotColor: Colors.black,
                            verticalOffset: 20,
                            dotColor: Colors.white
                          ),
                          onDotClicked: (index) => _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeOut),
                        )
                    ),
                    ElevatedButton(
                        style: ButtonStyle(elevation: MaterialStateProperty.all(10),
                          overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent),
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          animationDuration: const Duration(milliseconds: 400),
                          shadowColor: MaterialStateProperty.all(Colors.black87),
                          foregroundColor: MaterialStateProperty.all(Colors.black),),
                        onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut), child: const Icon(Icons.arrow_forward_ios_rounded))
                  ],
                ),
        ),
    );
  }
  Widget buildPage(String gambar, String titel, String desc){
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height / 1.7,
              width: MediaQuery.of(context).size.width / 1.5,
              child: Image(image: AssetImage(gambar), fit: BoxFit.contain,)),
          SizedBox(height: MediaQuery.of(context).size.height / 60,),
          Text(titel, style: const TextStyle(fontSize:20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          SizedBox(height: MediaQuery.of(context).size.height / 100,),
          Text(desc, style: const TextStyle(fontSize:16), textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}
