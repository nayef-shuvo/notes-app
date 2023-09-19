import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes_app/person.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final rootAddress = 'http://10.0.2.2:5000/api/Person';
  var people = List<Person>.empty();

  final nameController = TextEditingController();
  final ageController = TextEditingController();

  void loadPeople() async {
    final response = await http.get(Uri.parse(rootAddress));
    if (response.statusCode == 200) {
      List<dynamic> jsonPeople = jsonDecode(response.body);
      setState(() {
        people = jsonPeople.map((json) => Person.fromJson(json)).toList();
      });
    }
  }

  void addPerson(Person person) async {
    var body = jsonEncode(person.toJson());
    final response = await http.post(
      Uri.parse(rootAddress),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
      loadPeople();
    }
  }

  @override
  void initState() {
    loadPeople();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Person List'),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 250,
              margin: const EdgeInsets.all(5),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                    label: Text('Name'),
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2))),
              ),
            ),
            Container(
              width: 250,
              margin: const EdgeInsets.all(5),
              child: TextFormField(
                controller: ageController,
                decoration: const InputDecoration(
                    label: Text('Age'),
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2))),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                var person = Person(
                    name: nameController.text,
                    age: int.parse(ageController.text));

                addPerson(person);
              },
              child: const Text('Create'),
            ),
            const Divider(),
            for (var person in people)
              Container(
                margin: const EdgeInsets.all(5),
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(person.age.toString()),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
