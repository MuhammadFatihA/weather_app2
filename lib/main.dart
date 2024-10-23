import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'wilayah_model.dart';
import 'dart:math'; // To generate random weather icons

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: WilayahListScreen(),
    );
  }
}

class WilayahListScreen extends StatefulWidget {
  @override
  _WilayahListScreenState createState() => _WilayahListScreenState();
}

class _WilayahListScreenState extends State<WilayahListScreen> {
  late Future<List<Wilayah>> wilayahList;
  List<Wilayah> allWilayah = []; // To store all data
  List<Wilayah> filteredWilayah = [];
  String searchQuery = '';

  Future<List<Wilayah>> fetchWilayah() async {
    final response = await http.get(
      Uri.parse('https://ibnux.github.io/BMKG-importer/cuaca/wilayah.json'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Wilayah.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    wilayahList = fetchWilayah();
    wilayahList.then((data) {
      setState(() {
        allWilayah = data; // Store all data
        filteredWilayah = data; // Initially display all data
      });
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;

      if (query.isEmpty) {
        // If search query is empty, reset the list to all data
        filteredWilayah = allWilayah;
      } else {
        // Filter the list based on the query
        filteredWilayah = allWilayah.where((wilayah) {
          final lowerQuery = query.toLowerCase();
          final wilayahName = '${wilayah.kota}, ${wilayah.propinsi}'.toLowerCase();
          return wilayahName.contains(lowerQuery);
        }).toList();
      }
    });
  }

  // Function to randomly select a weather icon
  IconData getWeatherIcon() {
    final List<IconData> weatherIcons = [
      Icons.wb_sunny, // Sunny
      Icons.cloud, // Cloudy
      Icons.beach_access, // Rainy
      Icons.flash_on, // Thunderstorm
      Icons.ac_unit, // Snowy
      Icons.foggy, // Foggy
    ];
    Random random = Random();
    return weatherIcons[random.nextInt(weatherIcons.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black45,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image from Network
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://t4.ftcdn.net/jpg/02/66/38/15/360_F_266381525_alVrbw15u5EjhIpoqqa1eI5ghSf7hpz7.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 30, left: 20, right: 20),
            child: Column(
              children: [
                // Welcome Message
                Text(
                  'Selamat Datang di Weather App!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                // Search Bar
                TextField(
                  onChanged: updateSearchQuery,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Cari kota...',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Weather List
                Expanded(
                  child: FutureBuilder<List<Wilayah>>(
                    future: wilayahList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: Colors.white));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.redAccent)),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('No data available', style: TextStyle(color: Colors.white70)),
                        );
                      } else {
                        List<Wilayah> data = filteredWilayah;
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final wilayah = data[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                leading: Icon(getWeatherIcon(), color: Colors.orangeAccent, size: 40),
                                title: Text(
                                  '${wilayah.kota}, ${wilayah.propinsi}',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Text('Kecamatan: ${wilayah.kecamatan}', style: TextStyle(color: Colors.black54)),
                                    Text('Lat: ${wilayah.lat}, Lon: ${wilayah.lon}', style: TextStyle(color: Colors.black54)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}