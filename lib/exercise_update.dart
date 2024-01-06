import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExerciseUpdate extends StatefulWidget {
  final String exerciseName;

  ExerciseUpdate({required this.exerciseName});

  @override
  _ExerciseUpdateState createState() => _ExerciseUpdateState();
}

class _ExerciseUpdateState extends State<ExerciseUpdate> {
  TextEditingController weightController = TextEditingController();
  TextEditingController setsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Maximum Weight',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: setsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Number of Sets',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateExerciseData();
              },
              child: Text('Update Progress'),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text('Go to Home'),
            ),


          ],
        ),
      ),
    );
  }

  Future<void> updateExerciseData() async {
    String weight = weightController.text;
    String sets = setsController.text;

    var url = Uri.parse('https://gymtracktls.000webhostapp.com/test/updatedata.php');

    try {
      var response = await http.put(
        url,
        body: {
          'exerciseName': widget.exerciseName,
          'maxWeight': weight,
          'numSets': sets,
        },
      );

      if (response.statusCode == 200) {
        // Handle success, e.g., show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exercise progress updated successfully!'),
            duration: Duration(seconds: 5),
          ),
        );

        // Clear text fields after successful update
        weightController.clear();
        setsController.clear();
      } else {
        // Handle failure, e.g., show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update exercise progress.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
