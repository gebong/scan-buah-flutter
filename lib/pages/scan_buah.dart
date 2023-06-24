import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  File? _image; // Initialize with a default value of an empty file path
  final double _freshness = 0;
  final String _fruitClass = '';

  @override
  void initState() {
    super.initState();
  }

  Future pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemp = File(image.path);
    setState(() => _image = imageTemp);
  }

  Future pickImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    final imageTemp = File(image.path);
    setState(() => _image = imageTemp);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Aplikasi Scan Kesegaran Buah',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w200,
              fontSize: 20,
              letterSpacing: 0.8),
        ),
      ),
      drawer: const NavBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null ? Image.file(_image!) : Container(),
            const SizedBox(height: 20),
            Text('Fruit Name: $_fruitClass'),
            Text('Freshness: $_freshness'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => '',
              child: const Text('Cek Kesegaran'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => pickImageFromGallery(),
              child: const Text('Ambil Gambar dari Gallery'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => pickImageFromCamera(),
              child: const Text('Ambil Gambar dari Kamera'),
            ),
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
