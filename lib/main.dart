import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Property> fetchProperty() async {
  final response = await http
      .get(Uri.parse('https://localhost:7046/Property/GetProperty/19'));
  print(response.body);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Property.fromJson(jsonDecode(response.body));

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.

    throw Exception('Failed to load album');
  }

}

class MyHttpoverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class Property {
  // final int PropertyId;
  // final int phoneNum;
  //final Map<String ,List>? dealType;
  final String sellerName;

  const Property({
    // required this.PropertyId,
    // required this.phoneNum,
    //required this.dealType,
    required this.sellerName,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    var x =  json['dealType']['properties'][0]['seller']['sellerName'];
    //var y = x['properties'];
    //print(y[0]['seller']['sellerName']);
    return Property(
      // PropertyId: json['PropertyId'],
      // phoneNum: json['phoneNum'],
      sellerName: x,

    );
  }
}


void main() {
  HttpOverrides.global = MyHttpoverrides();
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Property> futureProperty;



  @override
  void initState() {
    super.initState();
    futureProperty = fetchProperty();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Property>(
            future: futureProperty,
            builder: (context, snapshot) {
              //print(snapshot.data!.sellerName!);
              if (snapshot.hasData) {
                print("has dataaaa");

                return Text(snapshot.data!.sellerName!);
              } else if (snapshot.hasError) {
                print("erorrrrr");
                return Text('${snapshot.error}');

              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}