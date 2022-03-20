// ignore_for_file: deprecated_member_use, import_of_legacy_library_into_null_safe

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'search_page.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String sehir = "İstanbul";
  dynamic sicaklik;
  var locationData;
  var kimlik;
  var locationTemp;
  var derece;
  String abbr = "c";
  dynamic position;
  List temp = [20, 23, 31, 14, 12];
  List image = ["c", "h", "hc", "lr", "c"];
  List date = ["a", "b", "c", "d", "e"];
  dynamic i;

  Future<void> getKonum() async {
    print("iş başladi");
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.lowest);
    } catch (e) {
      print("hata oluştu $e");
    }
    print("iş Bitti");
    print(position);
  }

  Future<void> getLocationData() async {
    locationData = await http
        .get("https://www.metaweather.com/api/location/search/?query=$sehir");
    //var locationDateParsed = jsonDecode(locationData.body);
    var locationDateParsed = jsonDecode(utf8.decode(locationData.bodyBytes));

    kimlik = locationDateParsed[0]["woeid"];
  }

  Future<void> getLocationTemp() async {
    locationTemp =
        await http.get("https://www.metaweather.com/api/location/$kimlik/");
    var sicaklik1 = jsonDecode(locationTemp.body);

    setState(() {
      sicaklik = sicaklik1["consolidated_weather"][0]["the_temp"].toInt();

      for (i = 0; i < temp.length; i++) {
        temp[i] = sicaklik1["consolidated_weather"][i + 1]["the_temp"].toInt();
      }
      for (i = 0; i < image.length; i++) {
        image[i] =
            sicaklik1["consolidated_weather"][i + 1]["weather_state_abbr"];
      }
      for (i = 0; i < date.length; i++) {
        date[i] = sicaklik1["consolidated_weather"][i + 1]["applicable_date"];
      }
      abbr = sicaklik1["consolidated_weather"][0]["weather_state_abbr"];

      print(sicaklik);
    });
  }

  Future<void> getLocationEnlem() async {
    locationData = await http.get(
        "https://www.metaweather.com/api/location/search/?lattlong=${position.latitude},${position.longitude}");
    var locationDateParsed = jsonDecode(locationData.body);

    kimlik = locationDateParsed[0]["woeid"];
    sehir = locationDateParsed[0]["title"];
  }

  void cagrilanfon() async {
    await getKonum();
    await getLocationEnlem();
    getLocationTemp();
  }

  void cagrilanfon1() async {
    await getLocationData();
    getLocationTemp();
  }

  @override
  void initState() {
    cagrilanfon();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, //ekranin tamamiyle kaplamasını sağlar
            image: AssetImage("assets/c.jpg")),
      ),
      child: sicaklik == null
          ? Center(
              child: SpinKitCubeGrid(
                color: Colors.black,
                size: 70,
              ),
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 100,
                      child: Image.network(
                        "https://www.metaweather.com/static/img/weather/png/$abbr.png",
                      ),
                    ),
                    Text(
                      "$sicaklik° C ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 70,
                          color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          sehir,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.amber,
                          ),
                          onPressed: () async {
                            sehir = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage()));

                            cagrilanfon1();
                            setState(() {
                              sehir = sehir;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    SonrakiGunler(),
                  ],
                ),
              ),
            ),
    );
  }

  Container SonrakiGunler() {
    return Container(
      height: 120,
      //width: MediaQuery.of(context).size.width * 0.9,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            HavaSimgesi(
              date: date[0],
              image: image[0],
              temp: temp[0].toString(),
            ),
            HavaSimgesi(
              date: date[1],
              image: image[1],
              temp: temp[1].toString(),
            ),
            HavaSimgesi(
              date: date[2],
              image: image[2],
              temp: temp[2].toString(),
            ),
            HavaSimgesi(
              date: date[3],
              image: image[3],
              temp: temp[3].toString(),
            ),
            HavaSimgesi(
              date: date[4],
              image: image[4],
              temp: temp[4].toString(),
            )
          ],
        ),
      ),
    );
  }
}

class HavaSimgesi extends StatelessWidget {
  final String image;
  final String temp;
  final String date;
  const HavaSimgesi(
      {required this.image, required this.temp, required this.date});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 2,
      child: Container(
        height: 120,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://www.metaweather.com/static/img/weather/png/$image.png",
              height: 50,
              width: 40,
            ),
            Text("$temp° C"),
            Text("$date"),
          ],
        ),
      ),
    );
  }
}
