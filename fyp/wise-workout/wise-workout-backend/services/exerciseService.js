const ExerciseModel = require('../models/exerciseModel');

class ExerciseService {
  static async getExercisesByWorkout(workoutId) {
    return await ExerciseModel.getExercisesByWorkoutId(workoutId);
  }

  static async getExercisesByNames(names) {
    return await ExerciseModel.getExercisesByNames(names);
  }
}

module.exports = ExerciseService;
