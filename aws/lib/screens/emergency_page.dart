import 'package:flutter/material.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materi Gawat Darurat'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  SectionTitle('Pengertian tentang gawat darurat bandar udara'),
                  SectionText(
                    'Gawat darurat adalah kondisi dimana bandar udara beroperasi di luar batas normal karena adanya sesuatu hal dan memerlukan penanggulangan sesegera mungkin. Penanganan gawat darurat di bandar udara harus sesegera mungkin karena operasi penerbangan harus dikondisikan normal.',
                  ),
                  SectionTitle('Klasifikasi Gawat Darurat'),
                  SubSectionTitle('1. Melibatkan Langsung Pesawat Udara'),
                  AlphabetList([
                    'Kecelakaan / kebakaran pesawat udara di dalam kawasan bandar udara Apabila tanpa diketahui sebelumnya telah terjadi kecelakaan / kebakaran pesawat udara di dalam batas pagar (perimeter) bandar udara.',
                    'Kecelakaan / kebakaran pesawat udara di luar kawasan bandar udara Apabila tanpa diketahui sebelumnya telah terjadi kecelakaan / kebakaran pesawat udara di luar batas pagar (perimeter) bandar udara sampai dengan radius 8 km dari pusat bandar udara (aerodrome reference point).',
                    'Kecelakaan pesawat udara di perairan Apabila diketahui bahwa pesawat udara mengalami kecelakaan diluar kawasan bandar udara, di laut, danau, sungai dan rawa.',
                    'Gawat darurat penuh (full emergency) Apabila sudah diketahui sebelumnya telah terjadi kerusakan pesawat udara saat menuju suatu bandar udara dan akan melakukan pendaratan darurat yang diperkirakan akan mengalami kecelakaan.',
                    'Siaga di tempat (local standby) Apabila diketahui sebuah pesawat udara tertentu yang mengalami gangguan / kerusakan di udara, sedang menuju ke bandar udara namun tidak terlalu dikhawatirkan akan berakibat fatal pada saat melakukan pendaratan.',
                  ]),
                  SubSectionTitle('2. Tidak Melibatkan Langsung Pesawat Udara'),
                  AlphabetList([
                    'Tindakan melawan hukum Apabila diketahui atau diduga telah terjadi suatu ancaman dalam bentuk sabotase, atau tindakan melawan hukum (pembajakan, ancaman bom atau bentuk tindak kejahatan lain) terhadap:\n1) Pesawat udara tertentu dari/ke bandar udara atau pesawat udara berada di bandar udara;\n2) Gedung fasilitas bandar udara yang dikhawatirkan akan mempengaruhi keselamatan pengoperasian pesawat udara dan pengguna jasa penerbangan dan pengguna jasa bandar udara.',
                    'Kebakaran gedung fasilitas bandar udara Apabila tanpa diketahui sebelumnya telah terjadi kebakaran pada gedung, fasilitas, peralatan atau kendaraan tertentu di dalam kawasan bandar udara, dan secara tidak langsung mempengaruhi operasi penerbangan.',
                    'Siaga cuaca Apabila diketahui akan terjadi badai yang dahsyat atau diperkirakan keadaan cuaca dapat mempengaruhi keselamatan operasi penerbangan, atau secara langsung akan mempengaruhi keselamatan manusia, gedung, fasilitas dan peralatan yang ada di dalam kawasan bandar udara.',
                    'Bencana alam Apabila terjadi kondisi bandar udara tidak dapat beroperasi secara normal disebabkan antara lain banjir, gempa bumi, angin topan, badai sehingga mengancam keselamatan penerbangan.',
                    'Barang berbahaya (Dangerous Goods) Apabila diketahui bahwa pesawat udara mengalami insiden disebabkan barang berbahaya pada saat penerbangan, maupun pada saat memuat dan membongkar barang.',
                  ]),
                  SectionTitle('Tingkat Emergency Response PKP'),
                  SubSectionTitle('1. Siaga III'),
                  CapitalAlphabetList([
                    'Kecelakaan pesawat udara di dalam bandar udara Setelah menerima berita kecelakaan / kebakaran pesawat udara di dalam kawasan bandar udara PKP-PK melakukan tindakan :  ',
                  ]),

                  AlphabetList([
                    'Langsung menuju ke lokasi kecelakaan melalui access road dan memonitor informasi yang diberikan Petugas Tower,  ',
                    'Memberitahukan kepada Dinas Pemadam Kebakaran Pemda , perihal sebagai berikut : \n 1) Rendezvous point,\n 2) Staging area,\n 3) Tenaga dan peralatan yang diperlukan,\n 4) Informasi lain yang diperlukan.',
                    'Melaksanakan operasi pemadaman dan pertolongan \n 1) Segera menentukan posisi pos komando di sekitar crash area, \n 2) Menentukan Collection Area, \n 3) Membantu Tim Salvage (Bila diperlukan), \n 4) Bila tugas telah selesai dilaksanakan, segera menyerahkan tanggung jawab pengamanana crash area kepada petugas keamanan'
                  ]),

                  CapitalAlphabetList([
                    'Kecelakaan pesawat udara di luar kawasan bandara\n Menyiapkan fasilitas dan personil sesuai kesepakatan Kesepakatan yang dimaksud meliputi :  ',
                  ], startIndex: 1),

                  AlphabetList([
                    'Untuk pertolongan dan pemadaman diserahkan kepada SAR dan PK Pemda setempat;',
                    'Unit PKP-PK hanya sebagai pendukung operasi pertolongan dan pemadaman; ',
                    'Tidak dibenarkan terjadi penurunan kategori bandar udara; ',
                    'PKP-PK dapat mengirimkan kendaraan Foam Tender ke lokasi kejadian bila operasional penerbangan yang ada masih terjangkau dengan fasilitas PKP-PK yang ada dan hal ini dapat diputuskan oleh pimpinan bandar udara berdasarkan analisa pimpinan PKP-PK; ',
                  ]),

                  SubSectionTitle('2. Siaga II (Full Emergency)'),
                  BulletList([
                    'Setelah menerima berita FULL EMERGENCY, maka tindakan yang dilakukan adalah:',
                  ]),
                  AlphabetList([
                    'Personel PKP-PK langsung mengoperasikan kendaraan yang menjadi tanggung jawabnya   dengan berpakaian operasional lengkap;  ',
                    'Segera menuju lokasi Standby yang telah ditentukan yaitu suatu lokasi dekat dengan runway , tetapi tidak mengganggu pergerakan pesawat udara lainnya yang tidak mengalami darurat dan berkoordinasi dengan petugas Control Tower / ADC ; ',
                    'Menghubungi Dinas Pemadam Kebakaran Pemda untuk mempersiapkan bantuan bila diperlukan. ',
                  ]),
                  SubSectionTitle('3. Siaga I (Local Standby)'),
                  BulletList([
                    'Setelah menerima berita local standby, maka tindakan yang dilakukan adalah:',
                  ]),

                  AlphabetList([
                    'Mengumumkan keadaan Siaga di tempat (Local Standby),',
                    'Personel PKP-PK segera menghidupkan mesin kendaraan dan menyiapkan peralatan yang menjadi tanggung jawabanya,' ,
                    'Pimpinan PKP-PK memonitor perkembangan untuk menentukan langkah lebih lanjut,',
                    'Berkoordinasi dengan unit fungsional lainnya',
                  ]),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                'Sumber modul basic PKP-PK',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SubSectionTitle extends StatelessWidget {
  final String text;
  const SubSectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;
  const SectionText(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14),
      textAlign: TextAlign.justify,
    );
  }
}

class CapitalAlphabetList extends StatelessWidget {
  final List<String> items;
  final int startIndex; // Tambahkan parameter untuk menentukan huruf awal

  const CapitalAlphabetList(this.items, {this.startIndex = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        int index = entry.key + startIndex; // Mulai dari huruf yang ditentukan
        String item = entry.value;
        String prefix = String.fromCharCode(65 + index); // Mengubah indeks menjadi huruf kapital (A, B, C, ...)
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text(
            '$prefix. $item',
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }
}

class AlphabetList extends StatelessWidget {
  final List<String> items;
  const AlphabetList(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        int index = entry.key;
        String item = entry.value;
        String prefix = String.fromCharCode(97 + index); // Mengubah indeks menjadi huruf (a, b, c, ...)
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text(
            '$prefix. $item',
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }
}

class BulletList extends StatelessWidget {
  final List<String> items;
  const BulletList(this.items, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                item,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          )
          .toList(),
    );
  }
}