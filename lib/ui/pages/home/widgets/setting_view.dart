import 'package:flutter/material.dart';

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
          padding: const EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(children: [
            ListView(
              shrinkWrap: true,
              children: [
                Card(
                    shadowColor: Colors.transparent,
                    child: ListTile(
                        onTap: () async {},
                        title: const Text("Sao lưu dữ liệu"))),
                Card(
                    shadowColor: Colors.transparent,
                    child: ListTile(
                        onTap: () async {}, title: const Text("Nhập dữ liệu"))),
              ],
            )
          ]));
    });
  }
}
