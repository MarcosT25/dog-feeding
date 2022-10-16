import 'package:dog_feeding/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Feeding',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Dog Feeding'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> getMealTime() async {
    final response =
        await http.get(Uri.parse(apiController.url + "getLunchTime"));
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    TextEditingController path = TextEditingController();
    TextEditingController hour = TextEditingController();
    TextEditingController minute = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFF326789),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              padding: const EdgeInsets.only(left: 10),
              width: size.width * 0.6,
              height: size.height * 0.06,
              decoration: BoxDecoration(
                color: Color(0xFF78A6C8),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: TextFormField(
                controller: path,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  label: Text(
                    "IP do Arduino",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => {apiController.setPath(path.text)},
              child: const Text("Enviar IP"),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFFE65C4F)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Color(0xFFE65C4F)),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              padding: const EdgeInsets.only(left: 10),
              width: size.width * 0.3,
              height: size.height * 0.06,
              decoration: BoxDecoration(
                color: Color(0xFF78A6C8),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: TextFormField(
                controller: hour,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  label: Text(
                    "Hora",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              padding: const EdgeInsets.only(left: 10),
              width: size.width * 0.3,
              height: size.height * 0.06,
              decoration: BoxDecoration(
                color: Color(0xFF78A6C8),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: TextFormField(
                controller: minute,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  label: Text(
                    "Minuto",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => {
                http.get(Uri.parse(apiController.url +
                    "setLunchTime?hour=" +
                    hour.text +
                    "&minute=" +
                    minute.text))
              },
              child: const Text("Enviar Horário"),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFFE65C4F)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Color(0xFFE65C4F)),
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: getMealTime(),
              builder: ((context, snapshot) {
                final currentMealTime = snapshot.data as String;
                return Center(
                  child: Text(
                    "A próxima refeição está programada para: ${currentMealTime}",
                    style: TextStyle(fontSize: 14),
                  ),
                );
              }),
            ),
            ElevatedButton(
              onPressed: () =>
                  {http.get(Uri.parse(apiController.url + "giveFood"))},
              child: const Text("Abrir reservatório"),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFFE65C4F)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Color(0xFFE65C4F)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
