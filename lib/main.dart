import 'package:flutter/material.dart';
import 'package:parcial02/models/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  Future<List<api>>? _listaApi;

  Future<List<api>> _getApi() async {
    final responsive = await http
        .get(Uri.parse("https://utecclass.000webhostapp.com/post.php"));

    List<api> apis = [];
    if (responsive.statusCode == 200) {
      String cuerpo = utf8.decode(responsive.bodyBytes);
      final jsonData = jsonDecode(cuerpo);

      for (var item in jsonData) {
        apis.add(api(item["id"], item["title"], item["status"], item["content"],
            item["user_id"]));
      }

      return apis;
    } else {
      throw Exception("No se puede conectar");
    }
  }

  @override
  void initState() {
    super.initState();
    _listaApi = _getApi();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mi aplicacion",
      home: Scaffold(
        backgroundColor: Colors.purple.shade100,
        appBar: AppBar(
          title: Text(
            "PARCIAL 2",
          ),
          backgroundColor: Colors.purple.shade100,
          leading: Icon(Icons.arrow_left, color: Colors.white, size: 50.0),
        ),
        body: FutureBuilder(
          future: _listaApi,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: _lista(snapshot.data),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text("Error");
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _lista(data) {
    List<Widget> datos = [];
    for (var itemg in data) {
      datos.add(Card(
        color: Colors.white70,
        child: Column(
          children: [
            Text(itemg.content,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(itemg.title,
                  style: TextStyle(color: Colors.black54, fontSize: 16.0)),
            ),
          ],
        ),
      ));
    }
    return datos;
  }
}
