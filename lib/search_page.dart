// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? secilenSehir;
  final myController = TextEditingController();
  void birFonksiyon() {
    print("fon çalıştı ");
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Girdiğiniz şehir bulunamadı"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Tekrar Deneyin Lütfen"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    birFonksiyon();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, //ekranin tamamiyle kaplamasını sağlar
            image: AssetImage("assets/n.jpg")),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                      hintText: "Lütfen Şehir Seçiniz",
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              FlatButton(
                  onPressed: () async {
                    var response = await http.get(
                        "https://www.metaweather.com/api/location/search/?query=${myController.text}");
                    jsonDecode(response.body).isEmpty
                        ? _showDialog()
                        : Navigator.pop(context, myController.text);
                  },
                  child: Text("Şehir Seç"))
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
