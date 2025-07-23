const ExerciseModel = require('../models/exerciseModel');

class ExerciseService {
  static async getExercisesByWorkout(workoutId) {
    return await ExerciseModel.getExercisesByWorkoutId(workoutId);
  }
}

module.exports = ExerciseService;
