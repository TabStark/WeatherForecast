import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
          useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? stringResponse;

  @override
  // void initState() {
  //   apiCall();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // child: Center(
        //     child: mapResponse == null
        //         ? Text("Loading Data")
        //         : Text(mapResponse!['name'].toString())),
        body: Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.blue,
                  const Color.fromRGBO(117, 138, 243, 0.8)
                ])),
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 80),
                child: Text(
                  "Weather ForeCast",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 150),
                child: Image.asset("assets/images/sun.png"),
              )
            ]),
          ),
          Positioned(
              top: 130,
              child: Container(
                height: 740,
                width: 412,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50)),
                    border: Border.all(color: Colors.white, width: 5),
                    color: Colors.transparent),
                padding: const EdgeInsets.only(top: 10),
                child: const Column(
                  children: [MainBody()],
                ),
              ))
        ],
      ),
    ));
  }
}

// Split Body

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  var CityName = TextEditingController();
  var general;
  var forwind;
  var windSpeed = 3;
  var currentTemp = 30;
  var humidity = 57;
  var location = "Ambur";

  void weatherAPI() {
    apiCall(CityName.text);
  }

  Map<String, dynamic>? mapResponse;
  var api_key = "7017e0559046146716f7ed1712011566";
  Future apiCall(place) async {
    http.Response response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${place}&appid=${api_key}"));
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        general = mapResponse!['main'];
        currentTemp = (general['temp'] * 0.1).round();
        humidity = general['humidity'];
        forwind = mapResponse!['wind'];
        windSpeed = ((forwind['speed']).round());
        location = mapResponse!['name'];
        print(currentTemp);
        print(humidity);
        print(windSpeed);
      });
    }
  }

  @override
  // void initState() {
  //   CityName = "Ambur" as TextEditingController;
  //   apiCall(CityName.text);
  //   super.initState();
  // }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 350,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(color: Colors.black)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                    height: 100,
                    width: 250,
                    child: TextField(
                      controller: CityName,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 5, right: 5),
                        hintText: "Search City",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      keyboardType: TextInputType.name,
                      style: TextStyle(fontSize: 18),
                    )),
              ),
              SizedBox(
                child: TextButton(
                  child: Icon(
                    Icons.search,
                    size: 30,
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 254, 255, 254)),
                  onPressed: weatherAPI,
                  // apiCall,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 180),
          height: 230,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${currentTemp}°C",
                style: TextStyle(fontSize: 70, color: Colors.white),
              ),
              Text(
                "${location}",
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.water, size: 30, color: Colors.white),
                        Text(
                          "Humidity: ${humidity}%",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.air, size: 30, color: Colors.white),
                        Text(
                          "Wind: ${windSpeed}km/h",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
