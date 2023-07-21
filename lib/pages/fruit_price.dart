import 'package:flutter/material.dart';
import 'dart:convert';
import '../components/nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'server_address.dart';
import 'dart:io';

class FruitPrice extends StatelessWidget {
  const FruitPrice({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cek Harga Buah',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const FruitPricePage(title: 'Scan Kesegaran Buah'),
    );
  }
}

class Item {
  final int id;
  final String nama;
  final double harga;

  Item({required this.id, required this.nama, required this.harga});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      nama: json['nama'],
      harga: json['harga'].toDouble(),
    );
  }
}

class FruitPricePage extends StatefulWidget {
  const FruitPricePage({super.key, required this.title});

  final String title;

  @override
  State<FruitPricePage> createState() => _FruitPriceState();
}

class _FruitPriceState extends State<FruitPricePage> {
  // Initial Selected Value
  Item? dropdownvalue;
  int? id;
  double price = 0;
  String fruit = '';
  List<Item> fruitList = [];
  bool isFunctionTriggered = false;

  String _errorTitle = '';
  String _errorMessage = '';
  String _status = '';

  String url =
      "http://${ServerAddressSettings.serverAddress}:${ServerAddressSettings.dbPort}";

  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    testConnection();

    if (isFunctionTriggered == true) {
      loadData();
      setState(() {
        isFunctionTriggered == false;
      });
      // print(isFunctionTriggered);
      // print('its triggered');
    }
    loadData();
  }

  // List of items in our dropdown menu

  void testConnection() async {
    Socket.connect(
            ServerAddressSettings.serverAddress, ServerAddressSettings.dbPort,
            timeout: const Duration(seconds: 5))
        .then((socket) {
      setState(() => _status = 'ONLINE!');
      socket.destroy();
    }).catchError((error) {
      setState(() => _status = 'DB SERVER OFFLINE!');
      if (context.mounted) {
        connectionErrorDialog(context);
      }
    });
  }

  Future<List<Item>> showAllData() async {
    String dbServerURL =
        "http://${ServerAddressSettings.serverAddress}:${ServerAddressSettings.dbPort}";

    final dbResponse = await http.get(
      Uri.parse(dbServerURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // print(dbResponse.statusCode);

    if (dbResponse.statusCode == 200) {
      final dbJSONdata = json.decode(dbResponse.body);
      List<dynamic> itemsData = dbJSONdata;
      return itemsData.map((item) => Item.fromJson(item)).toList();
    } else {
      // print(dbResponse.body);
      setState(() => {
            _errorTitle = 'API Error!',
            _errorMessage = 'Failed to fetch data from API'
          });
      if (context.mounted) {
        showAlertDialog(context);
      }
      throw "Failed to fetch data from API";
    }
  }

  void loadData() async {
    try {
      List<Item> data = await showAllData();
      setState(() {
        fruitList = data;
      });
    } catch (e) {
      // print('Error fetching data: $e');
    }
  }

  Future<void> setPricing(int? i) async {
    String dbServerURL =
        "http://${ServerAddressSettings.serverAddress}:${ServerAddressSettings.dbPort}/$i";

    try {
      int updatedPrice = int.parse(priceController.text);
      var dbResponse = await http.put(
        Uri.parse(dbServerURL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'harga': updatedPrice,
        }),
      );

      // print(dbResponse.statusCode);

      if (dbResponse.statusCode == 200 || dbResponse.statusCode == 201) {
        List<Item> data = await showAllData();

        setState(() => {
              _errorTitle = 'Update Harga Berhasil',
              _errorMessage = 'Berhasil merubah harga buah',
              isFunctionTriggered = true,
              dropdownvalue = null,
              priceController.text = '',
              fruitList = data
            });

        // print(isFunctionTriggered);
        // await showAllData();
        if (context.mounted) {
          showAlertDialog(context);
          context.go('/fruit_price');
        }
      } else {
        var dbJSONdata = json.decode(dbResponse.body);

        setState(() => {
              _errorTitle = 'DB Server Error!',
              _errorMessage = dbJSONdata['msg']
            });
        if (context.mounted) {
          showAlertDialog(context);
        }

        // showAlertDialog();
      }
    } catch (e) {
      setState(
          () => {_errorTitle = 'App Error!', _errorMessage = e.toString()});
      showAlertDialog(context);
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Pengaturan Harga Buah',
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
            DropdownButton<Item>(
                value: dropdownvalue,
                hint: const Text("Pilih buah"),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: fruitList.map((Item items) {
                  return DropdownMenuItem<Item>(
                    value: items,
                    child: Text(items.nama),
                  );
                }).toList(),
                onChanged: (Item? newValue) {
                  setState(() {
                    dropdownvalue = newValue;
                    id = dropdownvalue!.id;
                    priceController.text =
                        dropdownvalue!.harga.toStringAsFixed(0);
                    fruit = dropdownvalue!.nama;
                  });
                }),
            const SizedBox(height: 20),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: SizedBox(
                  width: 200,
                  child: TextField(
                    enabled: (dropdownvalue != null ? true : false),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: priceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Input harga buah',
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {
                if (id == null)
                  {
                    setState(() => {
                          _errorTitle = 'Tidak ada buah yang dipilih!',
                          _errorMessage = 'Mohon pilih buah terlebih dahulu!'
                        }),
                    showAlertDialog(context)
                  }
                else
                  {showConfirmationDialog(context)}
              },
              child: const Text('Ubah Harga'),
            ),
            const SizedBox(height: 20),
            Text('STATUS: $_status'),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          setState(() {
            _errorTitle = '';
            _errorMessage = '';
          });
        }
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

  showConfirmationDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Tidak"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Iya"),
      onPressed: () {
        setPricing(id);
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Konfirmasi"),
      content: const Text("Apakah anda yakin mengubah harga buah ini?"),
      actions: [
        cancelButton,
        continueButton,
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
