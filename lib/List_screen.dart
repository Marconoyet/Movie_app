import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List> fetchAlbum() async {
  Uri path = Uri.https("api.themoviedb.org", "3/movie/popular",
      {"api_key": "eb03df251074313f6e24c705f23a1cdc"});
  http.Response response = await http.get(path);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var data = jsonDecode(response.body);
    return data["results"];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class ListScreen extends StatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tired = fetchAlbum();
    return Scaffold(
      body: Center(
        child: FutureBuilder<List>(
          future: tired,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) => Card(
                  child: Container(
                    child: Column(
                      children: [
                        Image.network(
                          "https://image.tmdb.org/t/p/w500/${snapshot.data![index]["poster_path"]}",
                          width: 200,
                          height: 400,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 40.0, left: 20, right: 80),
                              child: Text(
                                "${snapshot.data![index]["original_title"]}",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 40.0, right: 4),
                              child: Text(
                                "${snapshot.data![index]["vote_average"]}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 40.00),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount: snapshot.data!.length,
                padding: EdgeInsets.all(20),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
