import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TutorialCek extends StatefulWidget {
  const TutorialCek({Key? key}) : super(key: key);

  @override
  State<TutorialCek> createState() => _TutorialCekState();
}

class _TutorialCekState extends State<TutorialCek> {
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
            setState(() => isLastPage = index == 4);
          },
          children: [
            buildPage('assets/cek1.gif', 'Cek Pengaduan', 'Tekan tombol Cek Pengaduan untuk membuka halaman cari pengaduan'),
            buildPage('assets/cek2.gif', 'Cari', 'Isi kotak dengan nomor seri, maka detail pengaduan dan status pengaduan akan ditampilkan'),
            buildPage('assets/cek3.gif', 'Detail Pengaduan', 'Periksa detail pengaduan untuk memastikan isi pengaduan'),
            buildPage('assets/cek4.jpg', 'Lihat Status', 'Gulung layar ke bawah untuk melihat detail status pengaduan'),
            buildPage('assets/cek5.gif', 'Lihat Detail Proses', 'Klik status pengaduan untuk melihat detail proses'),
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
                  count: 5,
                  effect: const WormEffect(
                      activeDotColor: Colors.black,
                      offset: 20,
                      strokeWidth: 10,
                      type: WormType.normal,
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
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/24 ),
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
