import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled1/edit.dart';
import 'package:untitled1/main.dart';

class navBar extends StatefulWidget {
  const navBar({Key? key}) : super(key: key);

  @override
  State<navBar> createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Drawer(
        backgroundColor: const Color(0xffDCDCDC),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    child: ListTile(
                      leading: const Icon(Icons.view_comfortable_sharp),
                      horizontalTitleGap: 1,
                      title: const Text('Tablo'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MyHomePage(title: "Tablo")),
                        );
                      },
                    ),
                  ),
                  Container(
                    child: ListTile(
                      leading: const Icon(Icons.edit),
                      horizontalTitleGap: 1,
                      title: const Text('Düzenle'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const editPage()),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
