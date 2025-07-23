const db = require('../config/db');

class ExerciseModel {
  static async getExercisesByWorkoutId(workoutId) {
    const [rows] = await db.execute(`
      SELECT
        exercise_id AS exerciseId,
        exercise_key AS exerciseKey,
        exercise_name AS exerciseName,
        exercise_description AS exerciseDescription,
        exercise_sets AS exerciseSets,
        exercise_reps AS exerciseReps,
        exercise_instructions AS exerciseInstructions,
        exercise_level AS exerciseLevel,
        exercise_equipment AS exerciseEquipment,
        exercise_duration AS exerciseDuration,
        youtube_url AS youtubeUrl,
        workout_id AS workoutId
      FROM exercises
      WHERE workout_id = ?
    `, [workoutId]);

    return rows;
  }
}

module.exports = ExerciseModel;
