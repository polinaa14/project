import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const BirthdayApp());
}

class BirthdayApp extends StatefulWidget {
  const BirthdayApp({super.key});

  @override
  State<BirthdayApp> createState() => _BirthdayAppState();
}

class _BirthdayAppState extends State<BirthdayApp> {
  List birthdays = [];

  final nameController = TextEditingController();
  final dateController = TextEditingController();

  Future loadData() async {
    final response =
        await http.get(Uri.parse("http://localhost:3000/api/birthdays"));
    if (response.statusCode == 200) {
      setState(() {
        birthdays = json.decode(response.body);
      });
    }
  }

  Future addBirthday() async {
    await http.post(
      Uri.parse("http://localhost:3000/api/birthdays"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": nameController.text,
        "date": dateController.text,
      }),
    );
    nameController.clear();
    dateController.clear();
    loadData();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Birthdays")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: "Date (YYYY-MM-DD)"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: addBirthday,
                child: const Text("Add birthday"),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: birthdays.length,
                  itemBuilder: (context, index) {
                    final b = birthdays[index];
                    return ListTile(
                      title: Text(b["name"]),
                      subtitle: Text(b["date"]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}