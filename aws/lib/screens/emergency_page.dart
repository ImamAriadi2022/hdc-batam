import 'package:flutter/material.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materi Gawat Darurat Bandara'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            SectionTitle('Pengertian Gawat Darurat'),
            SectionText(
              'Gawat darurat adalah kondisi di mana bandara beroperasi di luar batas normal karena sesuatu hal dan memerlukan penanggulangan segera.',
            ),
            SectionTitle('Klasifikasi Gawat Darurat'),
            SubSectionTitle('1. Melibatkan Langsung Pesawat Udara'),
            BulletList([
              'Kecelakaan/kebakaran di dalam kawasan bandara.',
              'Kecelakaan/kebakaran di luar kawasan bandara (radius 8 km).',
              'Kecelakaan di perairan.',
              'Gawat darurat penuh (full emergency).',
              'Siaga di tempat (local standby).',
            ]),
            SubSectionTitle('2. Tidak Melibatkan Langsung Pesawat Udara'),
            BulletList([
              'Tindakan melawan hukum (pembajakan, ancaman bom, dll).',
              'Kebakaran gedung fasilitas bandara.',
              'Siaga cuaca.',
              'Bencana alam (banjir, gempa, badai).',
              'Barang berbahaya (dangerous goods).',
            ]),
            SectionTitle('Tingkat Emergency Response PKP'),
            SubSectionTitle('Siaga III'),
            SectionText(
              'Kecelakaan di dalam kawasan bandara: Langkah segera menuju lokasi, koordinasi dengan pemadam kebakaran, operasi pemadaman dan pertolongan.\n'
              'Kecelakaan di luar kawasan bandara: Koordinasi dengan SAR dan Pemda setempat.',
            ),
            SubSectionTitle('Siaga II (Full Emergency)'),
            SectionText(
              'Langkah: Personel operasional, standby dekat runway, koordinasi dengan tower dan pemadam kebakaran.',
            ),
            SubSectionTitle('Siaga I (Local Standby)'),
            SectionText(
              'Langkah: Pengumuman siaga, persiapan kendaraan, monitor kondisi, koordinasi unit lain.',
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(fontSize: 14)),
                  Expanded(
                    child: Text(item, style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
