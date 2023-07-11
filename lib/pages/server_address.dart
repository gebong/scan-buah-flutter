// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../components/nav_bar.dart';
import 'dart:io';

class ServerAddressSettings {
  static String serverAddress = '127.0.0.1';
  static int mlPort = 8000;
  static int dbPort = 3000;

  static void updateSettings(String address, int setDbPort, int setMlPort) {
    serverAddress = address;
    mlPort = setDbPort;
    dbPort = setMlPort;
  }
}

class ServerSettingsPage extends StatefulWidget {
  const ServerSettingsPage({super.key});

  @override
  State<ServerSettingsPage> createState() => _ServerSettingsState();
}

class _ServerSettingsState extends State<ServerSettingsPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dbPortController = TextEditingController();
  final TextEditingController mlPortController = TextEditingController();

  String _errorTitle = '';
  String _errorMessage = '';
  String _dbStatus = '';
  String _mlStatus = '';

  @override
  void initState() {
    super.initState();
  }

  void testDBConnection() async {
    Socket.connect(
            ServerAddressSettings.serverAddress, ServerAddressSettings.dbPort,
            timeout: const Duration(seconds: 5))
        .then((socket) {
      setState(() => _dbStatus = 'Connected!');
      socket.destroy();
    }).catchError((error) {
      setState(() => _dbStatus = error.toString());
      // setState(() => _dbStatus = 'Connection refused!');
      // print(error);
    });
  }

  void testMLConnection() async {
    Socket.connect(
            ServerAddressSettings.serverAddress, ServerAddressSettings.mlPort,
            timeout: const Duration(seconds: 5))
        .then((socket) {
      setState(() => _mlStatus = 'Connected!');
      socket.destroy();
    }).catchError((error) {
      setState(() => _mlStatus = error.toString());
      // setState(() => _mlStatus = 'Connection refused!');
    });
  }

  @override
  Widget build(BuildContext context) {
    addressController.text = ServerAddressSettings.serverAddress;
    dbPortController.text = ServerAddressSettings.dbPort.toString();
    mlPortController.text = ServerAddressSettings.mlPort.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Konfigurasi Server',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w200,
              fontSize: 20,
              letterSpacing: 0.8),
        ),
      ),
      drawer: const NavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Server Address'),
            ),
            TextFormField(
              controller: mlPortController,
              decoration: const InputDecoration(labelText: 'ML Server Port'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: dbPortController,
              decoration: const InputDecoration(labelText: 'DB Server Port'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _mlStatus = 'Loading..';
                  _dbStatus = 'Loading..';
                });
                String address = addressController.text;
                int mlPort = int.tryParse(mlPortController.text) ?? 0;
                int dbPort = int.tryParse(dbPortController.text) ?? 0;

                ServerAddressSettings.updateSettings(address, mlPort, dbPort);

                testDBConnection();
                testMLConnection();
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 10),
            Text('ML Server Status: $_mlStatus'),
            Text('DB Server Status: $_dbStatus'),
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
}
