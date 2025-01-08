import 'package:flutter/material.dart';

class TambahLaporanScreen extends StatefulWidget {
  const TambahLaporanScreen({Key? key}) : super(key: key);

  @override
  State<TambahLaporanScreen> createState() => _TambahLaporanScreenState();
}

class _TambahLaporanScreenState extends State<TambahLaporanScreen> {
  final _formKey = GlobalKey<FormState>();
  String? tingkatSiaga;
  String statusAncaman = 'Aktif';
  bool setujuPernyataan = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0097B2),
        title: const Text('Formulir Laporan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Tingkat Siaga',
                    border: OutlineInputBorder(),
                  ),
                  items: ['1', '2', '3'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      tingkatSiaga = value;
                    });
                  },
                  validator: (value) => value == null ? 'Pilih tingkat siaga' : null,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Masukkan Deskripsi Laporan',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Deskripsi harus diisi' : null,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Masukkan Lokasi Kejadian',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Lokasi harus diisi' : null,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Masukkan Jumlah Penumpang',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Jumlah penumpang harus diisi' : null,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Masukkan Jenis Pesawat',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Jenis pesawat harus diisi' : null,
                ),
                const SizedBox(height: 16.0),
                const Text('Status Ancaman:'),
                RadioListTile(
                  title: const Text('Aktif'),
                  value: 'Aktif',
                  groupValue: statusAncaman,
                  onChanged: (value) {
                    setState(() {
                      statusAncaman = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('Terkendali'),
                  value: 'Terkendali',
                  groupValue: statusAncaman,
                  onChanged: (value) {
                    setState(() {
                      statusAncaman = value.toString();
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Logic untuk unggah foto
                        },
                        child: const Text('Upload Foto'),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Logic untuk ambil foto
                        },
                        child: const Text('Ambil Foto'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                CheckboxListTile(
                  title: const Text(
                    'Saya Bertanggung Jawab Atas Laporan yang saya tulis adalah kebenaran dan benar',
                  ),
                  value: setujuPernyataan,
                  onChanged: (value) {
                    setState(() {
                      setujuPernyataan = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && setujuPernyataan) {
                      // Logic untuk menyimpan laporan
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Laporan berhasil disimpan!')),
                      );
                    } else if (!setujuPernyataan) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Anda harus menyetujui pernyataan')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text('Laporkan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
