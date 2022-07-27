import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:path_provider/path_provider.dart';

import 'navBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Su Paylaştırıcı',
      home: const MyHomePage(title: 'Su Paylaştırıcı'),
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
  bool _isLoading = false; // This is initially false where no loading state
  int d1_ilk_end = 0;
  List<List<String>> daireler = [
    ["D1", "5", "10", "5", "8", "9"],
    ["D2", "2", "0", "0", "0", "0"],
    ["D3", "3", "0", "0", "0", "0"],
    ["D4", "4", "0", "0", "0", "0"],
    ["D5", "05", "5", "0", "0", "0"],
    ["D6", "0", "0", "0", "0", "0"],
    ["D7", "72", "0", "6", "0", "0"],
    ["D8", "0", "0", "0", "0", "0"],
    ["D9", "0", "0", "0", "0", "0"],
    ["D10", "0", "0", "0", "0", "0"],
    ["TOP", "-", "-", "0", "0", "0"]
  ];

  @override
  initState() {
    super.initState();
    dataLoadFunction();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xffDCDCDC),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Tablo          ",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        drawer: const navBar(),
        floatingActionButton: SpeedDial(
          overlayColor: const Color(0xffDCDCDC),
          icon: Icons.arrow_upward,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.edit_calendar_outlined),
              label: 'Sonraki ay için güncelle',
              backgroundColor: Colors.lightGreen,
              onTap: () {
                updateForNextMonthMessage(context);
              },
            ),
          ],
        ),
        body: _isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : DataTable2(
                columnSpacing: 2,
                horizontalMargin: 10,
                minWidth: 10,
                columns: [
                  DataColumn2(
                      label: Text('D', style: TextStyle(fontSize: 20)),
                      size: ColumnSize.S),
                  DataColumn2(
                      label: Text('İlk End', style: TextStyle(fontSize: 17)),
                      size: ColumnSize.L),
                  DataColumn2(
                      label: Text('Son End', style: TextStyle(fontSize: 17)),
                      size: ColumnSize.L),
                  DataColumn2(
                      label: Text('Fark', style: TextStyle(fontSize: 20)),
                      size: ColumnSize.M),
                  DataColumn2(
                      label: Text('Su', style: TextStyle(fontSize: 20)),
                      size: ColumnSize.M),
                  DataColumn2(
                      label: Text('TOTAL', style: TextStyle(fontSize: 20)),
                      size: ColumnSize.L),
                ],
                rows: [
                  getDataRow(0),
                  getDataRow(1),
                  getDataRow(2),
                  getDataRow(3),
                  getDataRow(4),
                  getDataRow(5),
                  getDataRow(6),
                  getDataRow(7),
                  getDataRow(8),
                  getDataRow(9),
                  getDataRow(10)
                ],
              ),
      ),
    );
  }

  getDataRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            daireler[index][0],
            style: TextStyle(fontSize: 15),
          ),
        ),
        DataCell(
          Text(
            daireler[index][1],
            style: TextStyle(fontSize: 15),
          ),
        ),
        DataCell(
          Text(
            daireler[index][2],
            style: TextStyle(fontSize: 15),
          ),
        ),
        DataCell(
          Text(
            daireler[index][3],
            style: TextStyle(fontSize: 15),
          ),
        ),
        DataCell(
          Text(
            daireler[index][4],
            style: TextStyle(fontSize: 15),
          ),
        ),
        DataCell(
          Text(
            daireler[index][5],
            style: TextStyle(fontSize: 15),
          ),
        )
      ],
    );
  }

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/storedData.txt'; // 3

    return filePath;
  }

  write(List<List<String>> list) async {
    // print(list);

    final data = await rootBundle.load('assets/sda.txt');
    final directory = (await getTemporaryDirectory()).path;
    List<String> lines = [];
    list.forEach((element) {
      String strList = element.join(";");
      lines.add(strList);
    });
    //final contents = await file.readAsString();
    //print("ŞU AN:"+contents);
    String readytowrite = lines.join(",");
    // print(readytowrite);
    File file = File(await getFilePath()); // 1

    await file.writeAsString(readytowrite);
  }

  read() async {
    final file = await File(await getFilePath());
    final contents = await file.readAsString();
    List<List<String>> tablo = [[], [], [], [], [], [], [], [], [], [], []];
    int counter = 0;
    //print(contents);
    List<String> lines = contents.split(",");
    //print(lines);
    lines.forEach((element) {
      List<String> values = element.split(";");
      List<String> newValues = [];
      values.forEach((value) {
        if (value != "") {
          newValues.add(value);
        }
      });
      tablo[counter] = newValues;
      counter++;
    });
    this.daireler = tablo;
    //print(daireler);
  }

  dataLoadFunction() async {
    setState(() {
      _isLoading = true;
    });
    await read();
    setState(() {
      _isLoading = false;
    });
  }

  updateForNextMonth() async {
    for (int i = 0; i < 11; i++) {
      daireler[i][1] = daireler[i][2];
      daireler[i][4] = "0";
      daireler[i][5] = "0";
      daireler[i][3] = "0";
    }
    await write(daireler);
    setState(() {});
  }

  void updateForNextMonthMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("DİKKAT"),
          content: Text(
              "Devam ederseniz bu ayın son endeksleri, önümüzdeki ayın ilk endeksi olarak ayarlanacak. BUu işlem geri alınamaz. Devam etmek istiyor musunuz?"),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel),
              label: const Text("İptal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Devam"),
              onPressed: () {
                updateForNextMonth();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
