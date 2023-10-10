import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:p88/pages/admin/admin_detail.dart';
import 'package:page_route_animator/page_route_animator.dart';

import '../../model/model.dart';
import '../widgets.dart';
import 'admin_widget.dart';
import 'batal_detail.dart';

class CekAdmin extends StatefulWidget {
  const CekAdmin({Key? key}) : super(key: key);

  @override
  State<CekAdmin> createState() => _CekAdminState();
}

class _CekAdminState extends State<CekAdmin> with TickerProviderStateMixin{
  TextEditingController cari = TextEditingController(text: '');
  int stepSkrng = 1;

  onSteped(int value){
    setState(() {
      stepSkrng = value;
    });
  }

  Future<String> jabut() async {
    final docs1 = await FirebaseFirestore.instance.collection('laporan').where('jenis', isEqualTo: 'batalkan').get();
    final int docs = docs1.docs.length;
    return docs.toString();
  }

  Future<String> tahap1() async {
    final docs1 = await FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: 1).get();
    final int docs = docs1.docs.length;
    return docs.toString();
  }
  Future<String> tahap2() async {
    final docs1 = await FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: 2).get();
    final int docs = docs1.docs.length;
    return docs.toString();
  }
  Future<String> tahap3() async {
    final docs1 = await FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: 3).get();
    final int docs = docs1.docs.length;
    return docs.toString();
  }
  Future<String> tahap4() async {
    final docs1 = await FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: 4).get();
    final int docs = docs1.docs.length;
    return docs.toString();
  }
  Future<String> tahap5() async {
    final docs1 = await FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: 5).get();
    final int docs = docs1.docs.length;
    return docs.toString();
  }
  Future<String> tahap6() async {
    final docs1 = await FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: 6).get();
    final int docs = docs1.docs.length;
    return docs.toString();
  }
  Future<String> tahap7() async {
    final docs1 = await FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: 7).get();
    final int docs = docs1.docs.length;
    return docs.toString();
  }
  Future<String> tahap8() async {
    final docs1 = await FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: 8).get();
    final int docs = docs1.docs.length;
    return docs.toString();
  }
  Future<String> tahap9() async {
    final docs1 = await FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: 9).get();
    final int docs = docs1.docs.length;
    return docs.toString();
  }
  Future<String> tahap10() async {
    final docs1 = await FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: 10).get();
    final int docs = docs1.docs.length;
    return docs.toString();
  }
  Future<String> tahap11() async {
    final docs1 = await FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: 11).get();
    final int docs = docs1.docs.length;
    return docs.toString();
  }
  Future<String> tahap12() async {
    final docs1 = await FirebaseFirestore.instance.collection('laporan').where('proses', isEqualTo: 12).get();
    final int docs = docs1.docs.length;
    return docs.toString();
  }

  @override
  void initState() {
    super.initState();
    tabAtas = TabController(vsync: this, length: myTabs.length);
  }
  late List<Tab> myTabs = <Tab>[
    const Tab(icon: Icon(Icons.search), text: 'Cari Pengaduan',),
    const Tab(icon: Icon(Icons.list), text: 'Semua Pengaduan',),
    Tab(icon: Badge(alignment: const AlignmentDirectional(30, -10),
        largeSize: 18, backgroundColor: Colors.black54, label: labbel(jabut()), child: const Icon(Icons.do_disturb)), text: 'Cabut Pengaduan',),
  ];
  late TabController tabAtas;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        toolbarHeight: 75,
        shadowColor: Colors.black87,
        title: Text("#88", style: Theme
            .of(context)
            .textTheme
            .headlineMedium?.copyWith(color: Colors.black),),
        centerTitle: true,
        elevation: 5,
        bottom: TabBar(
          labelStyle: const TextStyle(fontSize: 13),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          controller: tabAtas,
          indicatorColor: Colors.white,
          indicatorWeight: 2,
          tabs: myTabs,
        ),
      ),
          body:
          Container(
            color: Colors.white,
            child:
          TabBarView(
              controller: tabAtas,
              children: [
                cekPage(),
                semuaPage(context),
                cabutPage(context),
              ],
      ),
          ),)
    );
  }
  Widget cekPage(){
    return Center(
      child : Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: LiquidPullToRefresh(
          onRefresh: () {
            setState(() {
            });
            return Future<void>.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                const SizedBox(height: 20,),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      boxShadow: [BoxShadow(color: Colors.black54,
                        offset: Offset(0, 5),
                        spreadRadius: 1,
                        blurRadius: 20,)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        reuseJudul(context, 'Cari Pengaduan', Colors.black),
                        const SizedBox(height: 20,),
                        reuseTeksField(context, 'Masukkan Nomor Seri', cari, '', TextAlign.center, Colors.black87),
                        ElevatedButton(
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(Colors.white),
                                fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 15)),
                                backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                                elevation: MaterialStateProperty.all(10),
                                animationDuration: const Duration(milliseconds: 500),
                                shadowColor: MaterialStateProperty.all(Colors.black),
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
                          child:Row( mainAxisAlignment: MainAxisAlignment.center, children: const [
                            FittedBox(child: Icon(Icons.search, size: 20, color: Colors.white)),
                            SizedBox(width: 5,),
                            FittedBox(child: Text('Cari', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))
                          ])
                        )
                      ],
                    )
                ),
                const SizedBox(height: 15,),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AdminDetail(id: cari.text)));
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
                        } else if (laporan.jenis == 'stop'){
                          return buildHenti(laporan);
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
                FutureBuilder<Laporan?>(
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
                const SizedBox(height: 15,),
                FutureBuilder<Laporan?>(
                  future: ambilLaporan(serial: cari.text),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      final laporan = snapshot.data;
                      return buildDetailProses(context, laporan!.id);
                    } else {
                      return const Center(child: SizedBox(),);
                    }
                  },
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget judulExpans(String teks, int thp){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ExpansionTile(
        textColor: Colors.lightBlue,
        collapsedTextColor: Colors.black,
        title: Text(
            teks,
            textAlign: TextAlign.start,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        children: [
          ExpansionTile(
            textColor: Colors.lightBlue,
            collapsedTextColor: Colors.black,
            title: Row(children : const [
              SizedBox(width: 20,),
              Text('Pengaduan', style: TextStyle(fontSize: 20))]),
            children: [
              laporProsesLoad(context, thp, 'lapor'),
            ],
          ),
          ExpansionTile(
            textColor: Colors.lightBlue,
            collapsedTextColor: Colors.black,
            title: Row(children : const [
              SizedBox(width: 20,),
              Text('Pelimpahan', style: TextStyle(fontSize: 20))]),
            children: [
              limpahProsesLoad(context, thp, 'limpah'),
            ],
          ),
        ],
      ),
    );
  }

  Widget labbel(Future<String> tahhap) {
    return FutureBuilder(
        future: tahhap,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return Text(data!, style: const TextStyle(fontSize: 14),);
          } else {
            return const Text('');
          }
        }
    );
  }

  Widget semuaPage(BuildContext context) {
    return LiquidPullToRefresh(
      showChildOpacityTransition: false,
      onRefresh: () {
        setState(() {
        });
        return Future<void>.delayed(const Duration(seconds: 1));
        },
      child: ListView(
          children: [
            const SizedBox(height: 10,),
            Badge(
                alignment: AlignmentDirectional(MediaQuery.of(context).size.width/1.2, MediaQuery.of(context).size.width/20),
                largeSize: 20,
                label: labbel(tahap1()),
                backgroundColor: Colors.lightBlue,
                textColor: Colors.white,
                child: judulExpans('Pengaduan Diterima', 1)
            ),
            const Divider(color: Colors.lightBlue,),
            Badge(alignment: AlignmentDirectional(MediaQuery.of(context).size.width/1.2, MediaQuery.of(context).size.width/20),
                largeSize: 20,
                label: labbel(tahap2()), backgroundColor: Colors.lightBlue, textColor: Colors.white, child: judulExpans('Pengaduan dilaporkan kepada pimpinan', 2)),
            const Divider(color: Colors.lightBlue,),
            Badge(alignment: AlignmentDirectional(MediaQuery.of(context).size.width/1.2, MediaQuery.of(context).size.width/20),
                largeSize: 20,
                label: labbel(tahap3()), backgroundColor: Colors.lightBlue, textColor: Colors.white, child: judulExpans('Provos melaksanakan pemanggilan kepada yang bersangkutan', 3)),
            const Divider(color: Colors.lightBlue,),
            Badge(alignment: AlignmentDirectional(MediaQuery.of(context).size.width/1.2, MediaQuery.of(context).size.width/20),
                largeSize: 20,
                label: labbel(tahap4()), backgroundColor: Colors.lightBlue, textColor: Colors.white, child: judulExpans('Provos melaporkan kepada pimpinan hasil penyelidikan dan pemeriksaan awal', 4)),
            const Divider(color: Colors.lightBlue,),
            Badge(alignment: AlignmentDirectional(MediaQuery.of(context).size.width/1.2, MediaQuery.of(context).size.width/20),
                largeSize: 20,
                label: labbel(tahap5()), backgroundColor: Colors.lightBlue, textColor: Colors.white, child: judulExpans('Provos melakukan BAP terhadap saksi dan terduga pelanggar', 5)),
            const Divider(color: Colors.lightBlue,),
            Badge(alignment: AlignmentDirectional(MediaQuery.of(context).size.width/1.2, MediaQuery.of(context).size.width/20),
                largeSize: 20,
                label: labbel(tahap6()), backgroundColor: Colors.lightBlue, textColor: Colors.white, child: judulExpans('Provos menerbitkan Surat Pemberitahuan Perkembangan Hasil Penyelidikan Provos (SP2HP2) kepada pelapor', 6)),
            const Divider(color: Colors.lightBlue,),
            Badge(alignment: AlignmentDirectional(MediaQuery.of(context).size.width/1.2, MediaQuery.of(context).size.width/20),
                largeSize: 20,
                label: labbel(tahap7()), backgroundColor: Colors.lightBlue, textColor: Colors.white, child: judulExpans('Provos melakukan pemberkasan Daftar Pemeriksaan Pendahuluan Pelanggaran Disiplin (DP3D) untuk dikirim ke Atasan Hukum', 7)),
            const Divider(color: Colors.lightBlue,),
            Badge(alignment: AlignmentDirectional(MediaQuery.of(context).size.width/1.2, MediaQuery.of(context).size.width/20),
                largeSize: 20,
                label: labbel(tahap8()), backgroundColor: Colors.lightBlue, textColor: Colors.white, child: judulExpans('Provos meminta saran pendapat hukum ke Divisi Hukum Mabes Polri', 8)),
            const Divider(color: Colors.lightBlue,),
            Badge(alignment: AlignmentDirectional(MediaQuery.of(context).size.width/1.2, MediaQuery.of(context).size.width/20),
                largeSize: 20,
                label: labbel(tahap9()), backgroundColor: Colors.lightBlue, textColor: Colors.white, child: judulExpans('Proses Sidang Disiplin', 9)),
            const Divider(color: Colors.lightBlue,),
            Badge(alignment: AlignmentDirectional(MediaQuery.of(context).size.width/1.2, MediaQuery.of(context).size.width/20),
                largeSize: 20,
                label: labbel(tahap10()), backgroundColor: Colors.lightBlue, textColor: Colors.white, child: judulExpans('Terhukum mengajukan banding', 10)),
            const Divider(color: Colors.lightBlue,),
            Badge(alignment: AlignmentDirectional(MediaQuery.of(context).size.width/1.2, MediaQuery.of(context).size.width/20),
                largeSize: 20,
                label: labbel(tahap11()), backgroundColor: Colors.lightBlue, textColor: Colors.white, child: judulExpans('Proses sidang lanjutan', 11)),
            const Divider(color: Colors.lightBlue,),
            Badge(
                alignment: AlignmentDirectional(MediaQuery.of(context).size.width/1.2, MediaQuery.of(context).size.width/20),
                largeSize: 20,
                label: labbel(tahap12()), backgroundColor: Colors.lightBlue, textColor: Colors.white, child: judulExpans('Terhukum menjalankan putusan', 12)),
            const SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget cabutPage(BuildContext context){
    return
      LiquidPullToRefresh(
        onRefresh: (){
          setState(() {
          });
          return Future<void>.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ExpansionTile(
                  textColor: Colors.lightBlue,
                  collapsedTextColor: Colors.black,
                  title: const Text(
                      'Permintaan Cabut Pengaduan',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22)
                  ),
                  children: [
                    batalkanProsesLoad(context, 'batalkan'),
                  ],
                ),
              ),
              const Divider(color: Colors.lightBlue,),
              Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ExpansionTile(
                textColor: Colors.lightBlue,
                collapsedTextColor: Colors.black,
                title: const Text(
                    'Arsip Cabut Pengaduan',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22)
                ),
                children: [
                  batalProsesLoad(context, 'batal')
                ],
              ),
    ),
            ],
          ),
        ),
      );
  }

  Widget laporProsesLoad(BuildContext context, int pr, String kr){
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
       child:
           StreamBuilder<List<Laporan>>(
               stream: ambilTahap(t: pr, k: kr),
               builder: (context, snapshot){
                 if(snapshot.hasData){
                   final laporan = snapshot.data!;
                   return Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: laporan.map(buildLapor).toList(),
                   );
                 }
                 else {
                   return const Center(child: SizedBox(),);
                 }
               }),
    );
  }
  Widget limpahProsesLoad(BuildContext context, int pr, String kr){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child:
      StreamBuilder<List<Laporan>>(
          stream: ambilTahap(t: pr, k: kr),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final laporan = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: laporan.map(buildLimpah).toList(),
              );
            }
            else {
              return const Center(child: SizedBox(),);
            }
          }),
    );
  }

  Widget batalProsesLoad(BuildContext context, String kr){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child:
      StreamBuilder<List<Laporan>>(
          stream: ambilBatal(k: kr),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final laporan = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: laporan.map(buildBatal).toList(),
              );
            }
            else {
              return const Center(child: SizedBox(),);
            }
          }),
    );
  }

  Widget batalkanProsesLoad(BuildContext context, String kr){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child:
      StreamBuilder<List<Laporan>>(
          stream: ambilBatal(k: kr),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final laporan = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: laporan.map(batalkan).toList(),
              );
            }
            else {
              return const Center(child: SizedBox(),);
            }
          }),
    );
  }

  Widget buildLapor(Laporan laporan) {
    return GestureDetector(
        onTap: (){
          if(laporan.jenis == 'batal'){
            Navigator.of(context).push(
                PageRouteAnimator(
                  child: BatalDetail(id: laporan.id),
                  routeAnimation: RouteAnimation.fadeAndScale,
                  curve: Curves.easeOut,
                )
            );
          }else {
            Navigator.of(context).push(
                PageRouteAnimator(
                  child: AdminDetail(id: laporan.id),
                  routeAnimation: RouteAnimation.fadeAndScale,
                  curve: Curves.easeOut,
                )
            );
          }
        }, child:
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/6.5,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical:MediaQuery.of(context).size.height/44),
              decoration:   BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: Colors.black),
              ),
              child: ListView(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height/36,
                      child: FittedBox(alignment: Alignment.centerLeft, child: Text(laporan.id, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)))),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/40,
                    child: FittedBox( alignment: Alignment.centerLeft,
                      child: Row(children: [
                        const Text('Pelapor : ', style: TextStyle(color: Colors.black)),
                        Text(laporan.pelapor, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/40,
                    child: FittedBox( alignment: Alignment.centerLeft,
                      child: Row(children: [
                        const Text('Terlapor : ', style: TextStyle(color: Colors.black)),
                        Text(laporan.terlapor, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/40,
                    child: FittedBox( alignment: Alignment.centerLeft,
                      child: Row(children: [
                        const Text('Tanggal Pengaduan : ', style: TextStyle(color: Colors.black)),
                        Text(laporan.tgllapor, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                ],
              ),),
            const SizedBox(height: 20,)
          ]
        ));
    }

  Widget buildLimpah(Laporan laporan) {
    return GestureDetector(
        onTap: (){
          if(laporan.jenis == 'batal'){
            Navigator.of(context).push(
                PageRouteAnimator(
                  child: BatalDetail(id: laporan.id),
                  routeAnimation: RouteAnimation.fadeAndScale,
                  curve: Curves.easeOut,
                )
            );
          }else {
            Navigator.of(context).push(
                PageRouteAnimator(
                  child: AdminDetail(id: laporan.id),
                  routeAnimation: RouteAnimation.fadeAndScale,
                  curve: Curves.easeOut,
                )
            );
          }
        }, child:
    Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height/6.5,
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical:MediaQuery.of(context).size.height/44),
            decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: Colors.black),
            ),
            child: ListView(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height/36,
                    child: FittedBox(alignment: Alignment.centerLeft, child: Text(laporan.id, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)))),
                SizedBox(
                  height: MediaQuery.of(context).size.height/40,
                  child: FittedBox( alignment: Alignment.centerLeft,
                    child: Row(children: [
                      const Text('Dilimpahkan dari : ', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal ),),
                      Text(laporan.dari, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600 ),),
                    ]),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/40,
                  child: FittedBox( alignment: Alignment.centerLeft,
                    child: Row(children: [
                      const Text('Terlapor : ', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal ),),
                      Text(laporan.terlapor, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600 ),),
                    ]),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/40,
                  child: FittedBox( alignment: Alignment.centerLeft,
                    child: Row(children: [
                      const Text('Tanggal Pengaduan : ', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal ),),
                      Text(laporan.tgllapor, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600 ),),
                    ]
                    ),
                  ),
                ),
              ],
            ),),
          const SizedBox(height: 20,)
        ]
    ));
  }

  Widget buildBatal(Laporan laporan) {
    return
      GestureDetector(
        onTap: (){
          Navigator.of(context).push(
            PageRouteAnimator(
              child: AdminDetail(id: laporan.id),
              routeAnimation: RouteAnimation.fadeAndScale,
              curve: Curves.easeOut,
            )
          );
        }, child:
      Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height/10,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration:   BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: Colors.black),
            ),
            child: ListView(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height/36,
                    child: FittedBox(alignment: Alignment.centerLeft, child: Text(laporan.id, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)))),
                SizedBox(
                  height: MediaQuery.of(context).size.height/40,
                  child: FittedBox( alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Dibatalkan', style: TextStyle(color: Colors.red.shade800, fontSize: 18, fontWeight: FontWeight.w600 )),
                      ],
                    ),
                  ),
                ),

              ],
            ),),
          const SizedBox(height: 20,)
        ]
    ));
  }

  Widget batalkan(Laporan laporan) {
    return GestureDetector(
        onTap: (){
          Navigator.of(context).push(
              PageRouteAnimator(
                child: BatalDetail(id: laporan.id),
                routeAnimation: RouteAnimation.fadeAndScale,
                curve: Curves.easeOut,
              )
          );
        }, child:
    Column(
        children: [
          Container(
            height: 110,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: Colors.red.shade800),
            ),
            child: ListView(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height/36,
                    child: FittedBox(alignment: Alignment.centerLeft, child: Text(laporan.id, style: TextStyle(color: Colors.red.shade800, fontSize: 20, fontWeight: FontWeight.w600 ),),)),
                SizedBox(
                  height: MediaQuery.of(context).size.height/40,
                  child: FittedBox( alignment: Alignment.centerLeft,
                    child: Row(children: [
                      const Text('Pelapor : ', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal ),),
                      Text(laporan.pelapor, style:  TextStyle(color: Colors.red.shade800, fontSize: 16, fontWeight: FontWeight.w600 ),),
                    ]),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/40,
                  child: FittedBox( alignment: Alignment.centerLeft,
                    child: Row(children: [
                      const Text('Terlapor : ', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal ),),
                      Text(laporan.terlapor, style:  TextStyle(color: Colors.red.shade800, fontSize: 16, fontWeight: FontWeight.w600 ),),
                    ]),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/40,
                  child: FittedBox( alignment: Alignment.centerLeft,
                    child: Row(children: [
                      const Text('Tanggal Pengaduan : ', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal ),),
                      Text(laporan.tgllapor, style:  TextStyle(color: Colors.red.shade800, fontSize: 16, fontWeight: FontWeight.w600 ),),
                    ]
                    ),
                  ),
                ),
              ],
            ),),
          const SizedBox(height: 20,)
        ]
    ));
  }

  Widget buildHenti(Laporan laporan) {
    return GestureDetector(
        onTap: (){
          Navigator.of(context).push(
              PageRouteAnimator(
                child: AdminDetail(id: laporan.id),
                routeAnimation: RouteAnimation.fadeAndScale,
                curve: Curves.easeOut,
              )
          );
        }, child:
    Column(
        children: [
          Container(
            height: 130,
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
                Text(laporan.id, style: TextStyle(color: Colors.red.shade800, fontSize: 20, fontWeight: FontWeight.w600 ),),
                Row(children: [
                  const Text('Pelapor : ', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal ),),
                  Text(laporan.pelapor, style:  TextStyle(color: Colors.red.shade800, fontSize: 16, fontWeight: FontWeight.w600 ),),
                ]),
                Row(children: [
                  const Text('Terlapor : ', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal ),),
                  Text(laporan.terlapor, style:  TextStyle(color: Colors.red.shade800, fontSize: 16, fontWeight: FontWeight.w600 ),),
                ]),
                Row(children: [
                  const Text('Tanggal Pengaduan : ', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal ),),
                  Text(laporan.tgllapor, style:  TextStyle(color: Colors.red.shade800, fontSize: 16, fontWeight: FontWeight.w600 ),),
                ]
                ),
              ],
            ),),
        ]
    ));
  }
}

