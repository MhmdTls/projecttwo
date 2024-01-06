import 'package:flutter/material.dart';
import 'exercise_detail.dart';

class ExerciseList extends StatefulWidget {
  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  final Map<String, List<String>> exercisesByMuscleGroup = {
    'Biceps': ['Biceps Curls', 'Cable Curls'],
    'Chest': ['Bench Press', 'Cable Crossover'],
    'Triceps': ['Skull Crushers', 'Cable Press-downs'],
    'Back': ['Lat Pull Downs', 'Bent-over Rows'],
    'Legs': ['Squats', 'Leg Press'],
  };

  String selectedMuscleGroup = '';
  List<String> selectedExercises = [];

  String userWeight = '';

  @override
  void initState() {
    super.initState();

    selectedMuscleGroup = exercisesByMuscleGroup.keys.first;
    selectedExercises = exercisesByMuscleGroup[selectedMuscleGroup] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    List<String> muscleGroups = exercisesByMuscleGroup.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise List'),
        backgroundColor: Colors.black38,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Body Weight (kg)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  userWeight = value;
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<String>(
            hint: Text('Select Muscle Group'),
            value: selectedMuscleGroup,
            onChanged: (String? selectedGroup) {
              setState(() {
                selectedMuscleGroup = selectedGroup ?? '';
                selectedExercises = exercisesByMuscleGroup[selectedMuscleGroup] ?? [];
              });
            },
            items: muscleGroups.map((String group) {
              return DropdownMenuItem<String>(
                value: group,
                child: Text(group),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Text(
            'Exercises:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedExercises.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(selectedExercises[index]),
                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseDetail(exerciseName: selectedExercises[index], userWeight: userWeight),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
