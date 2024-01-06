import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'exercise_update.dart';

class ExerciseDetail extends StatefulWidget {
  final String exerciseName;
  final String userWeight;

  ExerciseDetail({required this.exerciseName, required this.userWeight});

  @override
  _ExerciseDetailState createState() => _ExerciseDetailState();
}

class _ExerciseDetailState extends State<ExerciseDetail> {
  int maxWeight = 0; // Example maximum weight
  int numSets = 0; // Example number of sets
  Map<String, dynamic> exerciseData = {};

  TextEditingController weightController = TextEditingController();
  TextEditingController setsController = TextEditingController();

  void updateExercise() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExerciseUpdate(
          exerciseName: widget.exerciseName,
        ),
      ),
    );
  }

  Map<String, String> exerciseImages = {
    'Biceps Curls': 'https://th.bing.com/th/id/OIP.mN-bffc2PBXleY_Lnkv2fQHaE5?rs=1&pid=ImgDetMain',
    'Cable Curls': 'https://th.bing.com/th/id/R.80f49e473fed09aa1a11cfa26c22a238?rik=7Bsswp8URx8WdA&pid=ImgRaw&r=0',
    'Lat Pull Downs': 'https://th.bing.com/th/id/OIP.cFc-CoOIhpZ66bTIJ0PlewHaE-?rs=1&pid=ImgDetMain',
    'Bent-over Rows': 'https://th.bing.com/th/id/OIP.G3-pTEyED1frCfZp22r2OAHaE3?rs=1&pid=ImgDetMain',
    'Squats': 'https://th.bing.com/th/id/OIP.pJYgPEojrLvS6C4PGfV7ewHaFk?rs=1&pid=ImgDetMain',
    'Leg Press': 'https://th.bing.com/th/id/R.bb5654ff8e018a32dabc0aaf20f63223?rik=7nVptfOO2ft1Lw&pid=ImgRaw&r=0',
    'Bench Press': 'https://th.bing.com/th/id/R.f6a715a9cfdaa5ec5dfb5b9e90ed058f?rik=z1yyENILgLLilg&pid=ImgRaw&r=0',
    'Cable Crossover': 'https://www.newbodyplan.co.uk/wp-content/uploads/2020/06/Standing-cable-flye-machine-chest-gym-exercise.jpg',
    'Skull Crushers': 'https://th.bing.com/th/id/OIP.MuKGYXlAZSV8KmAa5wG03gHaFD?rs=1&pid=ImgDetMain',
    'Cable Press-downs': 'https://th.bing.com/th/id/OIP.peQKGuQuCALtddmbguTrrAHaEK?rs=1&pid=ImgDetMain',
  };

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase(); // Fetch exercise data when the widget initializes
  }

  Future<void> fetchDataFromDatabase() async {
    var url = Uri.parse('https://gymtracktls.000webhostapp.com/test/getdata.php');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (var exercise in data) {
          if (exercise['exerciseName'] == widget.exerciseName) {
            setState(() {
              exerciseData = exercise;
              maxWeight = int.tryParse(exercise['weight'] ?? '0') ?? 0;
              numSets = int.tryParse(exercise['numberOfSets'] ?? '0') ?? 0;
            });
            break;
          }
        }
      }else {
        throw Exception('Failed to fetch exercise data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                exerciseImages[widget.exerciseName] ??
                    'https://via.placeholder.com/150', // Placeholder image URL if image is not found
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                'Max Weight: $maxWeight',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 10),
              Text(
                'Number of Sets: $numSets',
                style: TextStyle(fontSize: 30),
              ),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {

              Navigator.pop(context, {'maxWeight': maxWeight, 'numSets': numSets});
            },
            child: Text('Go Back'),
          ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateExercise,
                //child: const Icon(Icons.navigate_next, size: 50),
                child: Text('Update Exercise'),
              ),





            ],

          ),

        ),

      ),
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    setsController.dispose();
    super.dispose();
  }
}
