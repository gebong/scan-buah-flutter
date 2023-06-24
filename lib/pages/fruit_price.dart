import 'package:flutter/material.dart';
import '../components/nav_bar.dart';

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

class FruitPricePage extends StatefulWidget {
  const FruitPricePage({super.key, required this.title});

  final String title;

  @override
  State<FruitPricePage> createState() => _FruitPriceState();
}

class _FruitPriceState extends State<FruitPricePage> {
  @override
  void initState() {
    super.initState();
  }

  // Initial Selected Value
  String dropdownvalue = 'Pisang';

  // List of items in our dropdown menu
  var items = [
    'Pisang',
    'Apel',
    'Jeruk',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Cek Harga Buah',
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
            DropdownButton(

                // Initial Value
                value: dropdownvalue,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                }),
            const SizedBox(height: 20),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Input harga buah',
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => '',
              child: const Text('Ubah Harga'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
