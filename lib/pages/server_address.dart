import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../components/nav_bar.dart';

class ServerAddressSettings {
  static String serverAddress = 'http://127.0.0.1';
  static int mlPort = 8000;
  static int dbPort = 3000;

  static void updateSettings(String address, int setDbPort, int setMlPort) {
    serverAddress = address;
    mlPort = setDbPort;
    dbPort = setMlPort;
  }
}

class ServerSettingsPage extends StatelessWidget {
  ServerSettingsPage({super.key});
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dbPortController = TextEditingController();
  final TextEditingController mlPortController = TextEditingController();

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
                String address = addressController.text;
                int mlPort = int.tryParse(mlPortController.text) ?? 0;
                int dbPort = int.tryParse(dbPortController.text) ?? 0;

                ServerAddressSettings.updateSettings(address, mlPort, dbPort);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
