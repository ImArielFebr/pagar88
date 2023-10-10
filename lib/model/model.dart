import 'package:cloud_firestore/cloud_firestore.dart';

class Laporan {
  late String id;
  late final String pelapor;
  late final String pengirim;
  late final String dari;
  late final int nik;
  late final String email;
  late final String hppelapor;
  late final String tempatlahir;
  late final String tanggallahir;
  late final String terlapor;
  late final String pangkat;
  late final String nrp;
  late final String hpterlapor;
  late final String jabatan;
  late final String substaker;
  late final String deskripsi;
  late final String alasan;
  late final String tgllapor;
  late final int proses;
  late final String jenis;
  late final String keterangan;

  Laporan({
    this.id = '',
    this.pengirim = '',
    this.dari = '',
    this.pelapor = '',
    this.nik = 1,
    this.hppelapor = '',
    this.email = '',
    this.tempatlahir = '',
    this.tanggallahir = '',
    this.terlapor = '',
    this.pangkat = '',
    this.nrp = '',
    this.hpterlapor = '',
    this.jabatan = '',
    this.substaker = '',
    required this.deskripsi,
    this.alasan = '',
    this.tgllapor = '',
    this.keterangan = '',
    required this.proses,
    required this.jenis,
  });
  Map<String, dynamic> toJson() => {
    'id' : id,
    'pelapor' : pelapor,
    'pengirim' : pengirim,
    'dari' : dari,
    'nik' : nik,
    'hppelapor' : hppelapor,
    'email' : email,
    'tempatlahir' : tempatlahir,
    'tanggalahir' : tanggallahir,
    'terlapor' : terlapor,
    'pangkat' : pangkat,
    'nrp' : nrp,
    'hpterlapor' : hpterlapor,
    'jabatan': jabatan,
    'substaker' : substaker,
    'keterangan' : keterangan,
    'deskripsi' : deskripsi,
    'alasan' : alasan,
    'tgllapor' : tgllapor,
    'proses' : proses,
    'jenis' : jenis,
  };

  static Laporan fromJson(Map<String, dynamic> json) => Laporan(
    id: json['id'],
    tgllapor: json['tgllapor'],
    pelapor: json['pelapor'],
    nik: json['nik'],
    email: json['email'],
    hppelapor: json['hppelapor'],
    pengirim: json['pengirim'],
    dari: json['dari'],
    tempatlahir: json['tempatlahir'],
    tanggallahir: json['tanggalahir'],
    terlapor: json['terlapor'],
    pangkat: json['pangkat'],
    nrp: json['nrp'],
    hpterlapor: json['hpterlapor'],
    jabatan: json['jabatan'],
    substaker: json['substaker'],
    keterangan: json['keterangan'],
    deskripsi: json['deskripsi'],
    alasan: json['alasan'],
    proses: json['proses'],
    jenis: json['jenis'],
  );
  factory Laporan.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return Laporan(
      id: data!["id"],
      nik: data["nik"],
      pelapor: data["pelapor"],
      tempatlahir: data["tempatlahir"],
      tanggallahir: data["tanggallahir"],
      email: data["email"],
      pengirim: data['pengirim'],
      dari: data['dari'],
      terlapor: data["terlapor"],
      pangkat: data["pangkat"],
      nrp: data["nrp"],
      jabatan: data["jabatan"],
      substaker: data["substaker"],
      keterangan: data["keterangan"],
      deskripsi: data["deskripsi"],
      alasan: data["alasan"],
      tgllapor: data["tgllapor"],
      proses: data["proses"],
      jenis: data["jenis"],
    );
  }
}

class Tujuan{
  final String email;

  const Tujuan({
    required this.email,
});
  Map<String, dynamic> toJson() => {
    'email' : email,
  };

  static Tujuan fromJson(Map<String, dynamic> json) => Tujuan(
    email: json['email'],
  );

}

class Linimasa{
  late final int proses;
  late final String tanggal;
  late final String keterangan;
  late final String deskripsi;

  Linimasa({
    this.proses = 1,
    this.tanggal = '',
    this.keterangan = '',
    this.deskripsi = ''
  });

  Map<String, dynamic> toJson() => {
    'proses' : proses,
    'tanggal' : tanggal,
    'keterangan': keterangan,
    'deskripsi': deskripsi,
  };

  static Linimasa fromJson(Map<String, dynamic> json) => Linimasa(
    proses: json['proses'],
    tanggal: json['tanggal'],
    keterangan: json['keterangan'],
    deskripsi: json['deskripsi'],
  );
}