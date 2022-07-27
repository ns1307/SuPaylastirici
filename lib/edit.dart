import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:path_provider/path_provider.dart';

import 'navBar.dart';

class editPage extends StatefulWidget {
  const editPage({Key? key}) : super(key: key);

  @override
  State<editPage> createState() => _editPageState();
}

class _editPageState extends State<editPage> {
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
  TextEditingController _controller1 = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();
  bool _isLoading = false;
  double tonFiyat = 15.33;
  double fatura = 1000;

  @override
  initState() {
    super.initState();
    dataLoadFunction();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: const Color(0xffDCDCDC)),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Endeks Düzenleme         "),
          ),
        ),
        drawer: const navBar(),
        floatingActionButton: SpeedDial(
          overlayColor: const Color(0xffDCDCDC),
          icon: Icons.arrow_upward,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.save_as),
              label: 'Kaydet ve Hesapla',
              backgroundColor: Colors.lightGreen,
              onTap: () async {
                await calculate();
                await calculateAll();
                await calculateBirim();
                await updateTotal();
                await write(daireler);
              },
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.mode_edit_outline_outlined,
              ),
              label: 'Ton Fiyatı ve Toplam Fatura Gir',
              backgroundColor: Colors.lightBlue,
              onTap: () {
                updateTonFaturaAlertDialog(context);
              },
            ),
          ],
        ),
        body: _isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ) // this will show when loading is true
            : ListView(
                children: ListTile.divideTiles(context: context, tiles: [
                  getListTile(0),
                  getListTile(1),
                  getListTile(2),
                  getListTile(3),
                  getListTile(4),
                  getListTile(5),
                  getListTile(6),
                  getListTile(7),
                  getListTile(8),
                  getListTile(9),
                ]).toList(),
              ),
      ),
    );
  }

  ListTile getListTile(int index) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          daireler[index][0].toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xffAE0000),
      ),
      title: Text('Daire ${index + 1}'),
      subtitle: Row(
        children: [
          Text("İlk Endeks:${daireler[index][1].toString()}"),
          Text(", Son Endeks:${daireler[index][2].toString()}"),
          Text(", Fark:${daireler[index][3].toString()}"),
        ],
      ),
      /*trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          updateEndexAlertDialog(context,index);
        },
      ),*/
      onTap: () {
        _controller1.text = daireler[index][1];
        if (daireler[index][2] != "0") {
          _controller2.text = daireler[index][2];
        }

        updateEndexAlertDialog(context, index);
      },
    );
  }

  void updateTonFaturaAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ton fiyatı ve Fatura"),
          content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.input),
                    labelText: "Ton Fiyatı",
                    hintText: "",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  controller: _controller1,
                ),
                TextFormField(
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.output),
                    labelText: "Fatura",
                    hintText: "",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  controller: _controller2,
                ),
              ]),
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
              label: const Text("Kaydet"),
              onPressed: () {
                try {
                  tonFiyat = double.parse(_controller1.text);
                  fatura = double.parse(_controller2.text);
                  _controller1.clear();
                  _controller2.clear();
                  Navigator.of(context).pop();
                  setState(() {});
                } catch (e) {
                  displayMessage("HATA", context,
                      'Hatalı giriş sadece sayı girin. Küsürat için "," yerine "." kullanın.');
                }
              },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {});
    });
  }

  void updateEndexAlertDialog(BuildContext contexti, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Endeksleri Düzenle"),
          content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.input),
                    labelText: "İlk Endeks",
                    hintText: "",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  controller: _controller1,
                ),
                TextFormField(
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.output),
                    labelText: "Son Endeks",
                    hintText: "",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  controller: _controller2,
                ),
              ]),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel),
              label: const Text("İptal"),
              onPressed: () {
                _controller1.clear();
                _controller2.clear();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Kaydet"),
              onPressed: () {
                int ilkIndex = int.parse(_controller1.text);
                int sonIndex = int.parse(_controller2.text);
                if (ilkIndex > sonIndex) {
                  displayMessage("HATA", context,
                      "Son indeks ilk indeksten küçük olamaz.");
                } else if (sonIndex - ilkIndex > 99) {
                  displayMessage("HATA", context, "Ton farkı 100'den fazla.");
                } else {
                  updateTable(_controller1.text, _controller2.text, index);
                  _controller1.clear();
                  _controller2.clear();
                  Navigator.of(context).pop();
                  setState(() {});
                }
              },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {});
    });
  }

  void displayMessage(String title, BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text("$message."),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
    File file = File(await getFilePath());
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
    // print(daireler);
  }

  calculate() {
    for (int i = 0; i < 10; i++) {
      double su = double.parse(daireler[i][3]) * tonFiyat.toDouble();
      daireler[i][4] = su.toStringAsFixed(2);
      //print(su);
    }
  }

  updateTable(String ilkInd, String sonInd, int index) async {
    daireler[index][1] = ilkInd;
    daireler[index][2] = sonInd;
    daireler[index][3] = (int.parse(sonInd) - int.parse(ilkInd)).toString();
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

  calculateAll() {
    int farkToplam = 0;
    double suToplam = 0;
    for (int i = 0; i < 10; i++) {
      farkToplam = farkToplam + int.parse(daireler[i][3]);
      suToplam = suToplam + double.parse(daireler[i][4]);
    }
    daireler[10][3] = farkToplam.toString();
    daireler[10][4] = suToplam.toStringAsFixed(2);
  }

  calculateBirim() {
    double suToplam = double.parse(daireler[10][4]);
    int count = 0;
    for (int i = 0; i < 10; i++) {
      if (daireler[i][3] != "0") {
        count++;
      }
    }
    if (count == 0) {
      displayMessage("Hata", context, "Su kullanan daire sayısı 0");
    } else {
      double birimFiyat = (fatura - suToplam) / count;
      birimFiyat = double.parse(birimFiyat.toStringAsFixed(2));
      for (int i = 0; i < 10; i++) {
        if (daireler[i][3] != "0") {
          double top = double.parse(daireler[i][4]) + birimFiyat;
          daireler[i][5] = top.toStringAsFixed(2);
        }
      }
      displayMessage(
          "Birim Fiyat",
          context,
          "Su kullanan daire sayısı: $count"
              "\nDaire başı fark ücreti: $birimFiyat");
    }
  }

  updateTotal() {
    double total = 0;
    for (int i = 0; i < 10; i++) {
      total = total + double.parse(daireler[i][5]);
    }
    daireler[10][5] = total.toStringAsFixed(2);
  }
}
