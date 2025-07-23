const ExerciseService = require('../services/exerciseService');

exports.getExercisesByWorkout = async (req, res) => {
  const { workoutId } = req.params;
  console.log(`📥 [GET] /exercises/workout/${workoutId}`);

  if (!workoutId) return res.status(400).json({ message: 'Missing workoutId' });

  const exercises = await ExerciseService.getExercisesByWorkout(workoutId);
  console.log('📤 Returning exercises:', exercises);
  res.json(exercises);
};
