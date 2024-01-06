import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'exercise_detail.dart';

class ExerciseList extends StatefulWidget {
  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  List<String> exercises = [];
  String userWeight = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise List'),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                _showWeightInputDialog(context);
              },
              child: Icon(Icons.person),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(exercises[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseDetail(
                    exerciseName: exercises[index],
                    userWeight: userWeight,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> fetchExercises() async {
    var url = Uri.parse('https://gymtracktls.000webhostapp.com/test/getdata.php');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          exercises = List<String>.from(jsonDecode(response.body));
        });
      } else {
        throw Exception('Failed to fetch exercises');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchExercises();
  }

  Future<void> _showWeightInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Your Body Weight'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                userWeight = value;
              });
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter your body weight in kg',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}



