import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double countrygdp = 0.0, population = 0.0, gdpPerCapita = 0.0;
  String currencyCode = "",
      currencyName = "",
      capital = "",
      countryName = "",
      countryCode = "";
  String desc = "Please search for a country.";
  String selectCountry = 'Malaysia';
  List<String> countryList = [
    'ABCD',
    'Bangladesh',
    'United States',
    'China',
    'Australia',
    'Singapore',
    'Malaysia',
    'Indonesia',
    'Brunei'
  ];
  // ignore: prefer_typing_uninitialized_variables
  var countryFlag;
  // ignore: prefer_typing_uninitialized_variables
  var image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Country Seeker App v1.0"),
      ),
      backgroundColor: Color.fromARGB(255, 253, 242, 250),
      body: Center(
        heightFactor: 1.5,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Text("Search for Country: ",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(95, 52, 164, 243),
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton(
                  itemHeight: 60,
                  value: selectCountry,
                  items: countryList.map((selectCountry) {
                    return DropdownMenuItem(
                      value: selectCountry,
                      child: Text(
                        selectCountry,
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectCountry = newValue.toString();
                    });
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: _getCountry, child: const Text("Load Country")),
              SizedBox(
                width: 350,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  color: const Color.fromARGB(255, 103, 243, 248),
                  child: Stack(children: <Widget>[
                    Center(child: (countryFlag)),
                    Center(
                        heightFactor: 1.5,
                        child: Text(desc,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)))
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getCountry() async {
    //Http request for ApiNinja
    Uri url =
        Uri.parse('https://api.api-ninjas.com/v1/country?name=$selectCountry');
    var response = await http.get(url,
        headers: {'X-Api-Key': 'it2u4Cf6TdlD2rfMB4M97aPxI6JHMx6l7qOwi7ix'});
    String jsonData = response.body;
    var parsedJson = json.decode(jsonData);
    if (response.statusCode == 200) {
      if (parsedJson.isNotEmpty) {
        countryName = parsedJson[0]['name'];
        countryCode = parsedJson[0]['iso2'];
        capital = parsedJson[0]['capital'];
        currencyCode = parsedJson[0]["currency"]["code"];
        currencyName = parsedJson[0]["currency"]["name"];
        countrygdp = parsedJson[0]['gdp'];
        population = parsedJson[0]['population'];
        gdpPerCapita = parsedJson[0]['gdp_per_capita'];
        setState(() {
          desc =
              'Country Name: $countryName\n\nCapital: $capital\n\nCurrency: $currencyName\n\nCurrency Code: $currencyCode\n\nCountry GDP: $countrygdp\n\nPopulation: $population\n\nGDP per capita: $gdpPerCapita';
        });
      } else {
        setState(() {
          desc = 'Country Not Found.';
        });
      }
    } else {
      setState(() {
        desc = 'Country Not Found.';
      });
    }

    //Http request from flagsapi
    Uri url1 = Uri.parse('https://flagsapi.com/$countryCode/shiny/64.png');
    var response1 = await http.get(url1);

    if (response1.statusCode == 200) {
      if (parsedJson.isNotEmpty) {
        image = Image(
            image:
                NetworkImage('https://flagsapi.com/$countryCode/shiny/64.png'));

        setState(() {
          countryFlag = image;
        });
      } else {
        image = null;
        setState(() {
          countryFlag = image;
        });
      }
    } else {
      image = null;
      setState(() {
        countryFlag = image;
      });
    }
  }
}
