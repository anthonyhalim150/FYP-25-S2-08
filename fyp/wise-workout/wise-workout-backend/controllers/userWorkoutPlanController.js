const UserWorkoutPlanService = require('../services/userWorkoutPlanService');

exports.getMyPlans = async (req, res) => {
  const userId = req.user.id;
  const plans = await UserWorkoutPlanService.getPlans(userId);
  res.json(plans);
};

exports.createPlan = async (req, res) => {
  const userId = req.user.id;
  const { plan_title } = req.body;
  if (!plan_title) return res.status(400).json({ message: 'plan_title is required' });

  const planId = await UserWorkoutPlanService.createPlan(userId, plan_title);
  res.status(201).json({ plan_id: planId });
};

exports.getItemsByPlan = async (req, res) => {
  const { planId } = req.params;
  const items = await UserWorkoutPlanService.getItems(planId);
  res.json(items);
};

exports.deletePlan = async (req, res) => {
  const userId = req.user.id;
  const { planId } = req.params;
  const deleted = await UserWorkoutPlanService.deletePlan(planId, userId);
  if (!deleted) return res.status(404).json({ message: 'Plan not found' });
  res.json({ message: 'Plan deleted' });
};

exports.addOneItem = async (req, res) => {
  try {
    const userId = req.user.id || req.user.userId;
    const { planId } = req.params;

    const {
      exercise_name,
      exercise_reps = null,
      exercise_sets = null,
      exercise_duration = null,
      // allow camelCase too (from Flutter)
      exerciseName,
      exerciseReps,
      exerciseSets,
      exerciseDuration,
    } = req.body;

    const payload = {
      exercise_name: exercise_name || exerciseName,
      exercise_reps: exercise_reps ?? exerciseReps ?? null,
      exercise_sets: exercise_sets ?? exerciseSets ?? null,
      exercise_duration: exercise_duration ?? exerciseDuration ?? null,
    };

    if (!payload.exercise_name) {
      return res.status(400).json({ message: 'exercise_name is required' });
    }

    const itemId = await UserWorkoutPlanService.addItem(userId, planId, payload);
    if (!itemId) return res.status(404).json({ message: 'Plan not found' });

    res.status(201).json({ item_id: itemId });
  } catch (err) {
    console.error('addOneItem error:', err);
    res.status(500).json({ message: 'Failed to add item' });
  }
};
