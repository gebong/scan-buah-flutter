import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../components/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'server_address.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  File? _image; // Initialize with a default value of an empty file path
  File? _image2; // Initialize with a default value of an empty file path
  double _freshness = 0;
  String _fruitClass = '';
  double _price = 0;
  String _kualitas = '';
  String _errorTitle = '';
  String _errorMessage = '';
  String _status = '';

  @override
  void initState() {
    super.initState();
    testConnection();
  }

  void testConnection() async {
    Socket.connect(
            ServerAddressSettings.serverAddress, ServerAddressSettings.dbPort,
            timeout: const Duration(seconds: 5))
        .then((socket) {
      Socket.connect(
              ServerAddressSettings.serverAddress, ServerAddressSettings.mlPort,
              timeout: const Duration(seconds: 5))
          .then((socket) {
        setState(() => _status = 'ONLINE!');
        socket.destroy();
      }).catchError((error) {
        setState(() => _status = 'ML SERVER OFFLINE!');
        if (context.mounted) {
          connectionErrorDialog(context);
        }
      });
      socket.destroy();
    }).catchError((error) {
      if (context.mounted) {
        connectionErrorDialog(context);
      }
      setState(() => _status = 'DB SERVER OFFLINE!');
    });
  }

  Future<void> pickImageFromGallery(void Function(File?) setImage) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemp = File(image.path);
    setState(() => setImage(imageTemp));
  }

  Future<void> pickImageFromCamera(void Function(File?) setImage) async {
    if (Platform.isAndroid || Platform.isIOS) {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => setImage(imageTemp));
    } else {
      setState(() => {
            _errorTitle = 'Pengambilan Kamera Tidak Didukung',
            _errorMessage =
                'Mohon maaf, pengambilan melalaui kamera hanya didukung untuk platform Android dan iOS'
          });
      if (context.mounted) {
        showAlertDialog(context);
      }
    }
  }

  Future<void> sendImage() async {
    // String mlServerURL = "http://127.0.0.1:8000/predict";
    String mlServerURL =
        'http://${ServerAddressSettings.serverAddress}:${ServerAddressSettings.mlPort}/predict';
    String dbServerURL =
        "http://${ServerAddressSettings.serverAddress}:${ServerAddressSettings.dbPort}/price";

    try {
      Future<http.Response> mlRequestFunction(File? image) async {
        var mlRequest = http.MultipartRequest(
          'POST',
          Uri.parse(mlServerURL),
        );
        Map<String, String> headers = {"Content-type": "multipart/form-data"};
        mlRequest.files
            .add(await http.MultipartFile.fromPath('image', image!.path));
        mlRequest.headers.addAll(headers);
        var res = await mlRequest.send();
        http.Response mlResponse = await http.Response.fromStream(res);

        return mlResponse;
      }

      if (_image == null && _image2 == null) {
        setState(() => {
              _errorTitle = 'Tidak ada gambar!',
              _errorMessage =
                  'Mohon ambil gambar buah untuk kedua sisi terlebih dahulu'
            });
        if (context.mounted) {
          showAlertDialog(context);
        }
      } else if (_image2 == null) {
        setState(() => {
              _errorTitle = 'Tidak ada gambar buah sisi belakang!',
              _errorMessage =
                  'Mohon ambil gambar buah sisi belakang terlebih dahulu'
            });
        if (context.mounted) {
          showAlertDialog(context);
        }
      } else if (_image == null) {
        setState(() => {
              _errorTitle = 'Tidak ada gambar buah sisi depan!',
              _errorMessage =
                  'Mohon ambil gambar buah sisi depan terlebih dahulu'
            });
        if (context.mounted) {
          showAlertDialog(context);
        }
      } else {
        http.Response ml1 = await mlRequestFunction(_image);
        http.Response ml2 = await mlRequestFunction(_image2);

        if (ml1.statusCode == 200 && ml2.statusCode == 200) {
          var jsondata1 = json.decode(ml1.body); //decode json dat
          var jsondata2 = json.decode(ml2.body); //decode json dat

          var fruitName1 = jsondata1['fruit_name'];
          var fruitName2 = jsondata2['fruit_name'];

          // print("$jsondata1 and $jsondata2");

          if (fruitName1 == fruitName2) {
            var fruitQuality1 =
                double.parse(jsondata1['freshness_percentage'].toString());
            var fruitQuality2 =
                double.parse(jsondata2['freshness_percentage'].toString());

            var overralFruitQuality = ((fruitQuality1 + fruitQuality2) / 2);

            // print(fruitQuality1);
            // print(fruitQuality2);
            // print(OverlayPortalController);
            var dbResponse = await http.post(
              Uri.parse(dbServerURL),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'nama_buah': jsondata1['fruit_name'].toString(),
                'kualitas': overralFruitQuality.toString(),
              }),
            );

            if (dbResponse.statusCode == 200) {
              var dbJSONdata = json.decode(dbResponse.body);

              setState(() => {
                    _fruitClass = jsondata1['fruit_name'],
                    _freshness =
                        double.parse(overralFruitQuality.toStringAsFixed(2)),
                    _price = double.parse(dbJSONdata['harga_buah'].toString()),
                    _kualitas = dbJSONdata['kualitas']
                  });
            } else {
              var dbJSONdata = json.decode(dbResponse.body);
              setState(() => {
                    _errorTitle = 'DB Server Error!',
                    _errorMessage = dbJSONdata['msg']
                  });
              if (context.mounted) {
                showAlertDialog(context);
              }
            }
          } else {
            setState(() => {
                  _errorTitle = 'Buah Tidak Sama!',
                  _errorMessage =
                      'Buah yang anda berikan berbeda tiap sisi, pastikan buah kedua sisinya sama jenisnya'
                });
            if (context.mounted) {
              showAlertDialog(context);
            }
          }
        } else {
          var jsondata = json.decode(ml1.body);
          setState(() => {
                _errorTitle = 'ML Server Error!',
                _errorMessage = jsondata['msg']
              });
          if (context.mounted) {
            showAlertDialog(context);
          }
        }
      }
    } catch (e) {
      // print(e);
      setState(() =>
          {_errorTitle = 'Application Error!', _errorMessage = e.toString()});
      if (context.mounted) {
        showAlertDialog(context);
      }
    }
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
          'Aplikasi Pemindaian Kesegaran dan Kalkulasi Harga Buah',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _image != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        ))
                    : const SizedBox(width: 150, height: 150),
                _image2 != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.file(
                            _image2!,
                            fit: BoxFit.cover,
                          ),
                        ))
                    : const SizedBox(width: 150, height: 150),
              ],
            ),
            const SizedBox(height: 20),
            Text('Nama Buah: $_fruitClass'),
            Text('Persentase Kesegaran: $_freshness %'),
            Text('Harga: Rp. $_price'),
            Text('Kualitas: $_kualitas'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => sendImage(),
              child: const Text('Cek Kesegaran'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () =>
                  showPickImagePopup((image) => _image = image, "Depan"),
              child: const Text('Ambil Gambar Sisi Depan'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () =>
                  showPickImagePopup((image) => _image2 = image, "Belakang"),
              child: const Text('Ambil Gambar Sisi Belakang'),
            ),
            const SizedBox(height: 20),
            Text('STATUS: $_status'),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void showPickImagePopup(Function(dynamic) setImage, String nama) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return CupertinoPopupSurface(
              isSurfacePainted: true,
              child: Container(
                  padding: const EdgeInsetsDirectional.all(16),
                  color: CupertinoColors.white,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).copyWith().size.height * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                          child: Text(
                        "Pilih Sumber Gambar untuk $nama",
                        style: const TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 20,
                        ),
                      )),
                      const SizedBox(height: 20),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => {
                                pickImageFromGallery(setImage),
                                Navigator.of(context).pop()
                              },
                              child: const Text('Ambil Gambar dari Gallery'),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => {
                                pickImageFromCamera(setImage),
                                Navigator.of(context).pop()
                              },
                              child: const Text('Ambil Gambar dari Kamera'),
                            ),
                          ])
                    ],
                  )));
        });
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          _errorTitle = '';
          _errorMessage = '';
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(_errorTitle),
      content: Text(_errorMessage),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  connectionErrorDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Atur Ulang Koneksi"),
      onPressed: () {
        context.go('/server');
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text('Connection Error'),
      content:
          const Text('Pastikan settingan server sudah diatur dengan benar'),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
