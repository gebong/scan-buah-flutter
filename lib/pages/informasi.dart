import 'package:flutter/material.dart';
import '../components/nav_bar.dart';

class Information extends StatelessWidget {
  const Information({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Informasi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InformationPage(
          title: 'Informasi dan Panduan Penggunaan Aplikasi'),
    );
  }
}

class InformationPage extends StatefulWidget {
  const InformationPage({super.key, required this.title});

  final String title;

  @override
  State<InformationPage> createState() => _InformationState();
}

class _InformationState extends State<InformationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Informasi dan Panduan',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w200,
              fontSize: 20,
              letterSpacing: 0.8),
        ),
      ),
      drawer: const NavBar(),
      body: Center(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: const [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        "“Aplikasi Pemindai Kesegaran Buah” merupakan aplikasi yang bekerja dengan memindai dan membagi kesegaran buah berdasarkan tingkat kesegarannya menggunakan metode Deep Learning. Tingkat kesegaran buah ini dibagi berdasarkan range persentase kesegarannya, dengan tujuan untuk melakukan kalkulasi terhadap harga buah. Berikut merupakan petunjuk penggunaan aplikasi ini :",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 16),
                        child: Text(
                            "1. Pemilihan Buah : Buah-buahan yang dapat digunakan pada aplikasi ini hanyalah buah apel merah, apel hijau, jeruk keprok, jeruk manis, pisang ambon, pisang batu, pisang raja, serta jenis buah apel, pisang, dan jeruk yang memiliki karakteristik fisik yang persis seperti jenis-jenis buah yang telah disebutkan.")),
                    SizedBox(height: 12),
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 16),
                        child: Text(
                            "2. Penempatan Buah : Tempatkan buah yang akan dipindai di tempat yang memiliki cahaya yang cukup, yaitu tidak terlalu terang dan tidak terlalu gelap serta tidak menghasilkan terlalu banyak bayangan. Pastikan buah terlihat jelas dalam kamera.")),
                    SizedBox(height: 12),
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 16),
                        child: Text(
                            "3. Pemindaian : Dapat dilakukan dengan memotret langsung buah-buahan dari kamera dan mengunggah data dari penyimpanan internal perangkat android. Diperlukan gambar dari sisi depan dan belakang buah agar kalkulasi kesegaran dan harga dapat dilakukan dengan baik.")),
                    SizedBox(height: 12),
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 16),
                        child: Text(
                            "4. Proses pemindaian : Aplikasi akan mengirim gambar buah yang diambil ke model deep learning yang telah dilatih sebelumnya. Model akan menganalisis gambar dan menentukan tingkat kesegaran buah berdasarkan ciri-ciri visual yang terkait dengan kesegaran, seperti warna, tekstur, dan keutuhan kulit buah.")),
                    SizedBox(height: 12),
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 16),
                        child: Text(
                            "5. Hasil pemindaian : Setelah pemindaian selesai, aplikasi akan menampilkan hasil tingkat kesegaran buah. Anda akan melihat informasi tentang apakah buah tersebut segar (fresh), sebagian besar segar (mostly fresh), sebagian besar busuk (mostly rotten), atau sudah tidak segar lagi/busuk (rotten). Selain itu, aplikasi juga dapat memberikan penilaian dalam bentuk persentase yang menunjukkan tingkat kesegaran buah serta harga yang merupakan hasil kalkulasi dari persentase kesegaran buah tersebut.")),
                    SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        "Penting untuk diingat bahwa aplikasi ini menggunakan teknologi deep learning dan klasifikasi gambar untuk menentukan tingkat kesegaran buah dalam bentuk persentase kesegaran. Meskipun aplikasi ini dapat memberikan estimasi yang cukup akurat, tetapi hasilnya masih harus diverifikasi secara visual oleh pengguna. Jika ada keraguan tentang kesegaran buah, disarankan untuk melakukan pengecekan manual lebih lanjut.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        "Selamat menggunakan aplikasi Pemindaian Kesegaran Buah! Semoga aplikasi ini dapat membantu Anda dalam menentukan tingkat kesegaran buah dengan lebih mudah dan cepat.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
