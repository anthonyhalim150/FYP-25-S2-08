const WorkoutPlanService = require('../services/workoutPlanService');

exports.saveWorkoutPlan = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { planTitle, days } = req.body;

    const planId = await WorkoutPlanService.saveWorkoutPlan(userId, planTitle, days);
    res.status(201).json({ message: 'Workout plan saved', planId });
  } catch (err) {
    const map = {
      MISSING_DATA: 400
    };
    res.status(map[err.message] || 500).json({ message: err.message });
  }
};

exports.getWorkoutPlansByUser = async (req, res) => {
  try {
    const userId = req.user?.id;
    const plans = await WorkoutPlanService.getWorkoutPlansByUser(userId);
    res.status(200).json(plans);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
