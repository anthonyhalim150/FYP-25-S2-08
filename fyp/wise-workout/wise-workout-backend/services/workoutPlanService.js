const WorkoutPlanModel = require('../models/workoutPlanModel');

class WorkoutPlanService {
  static async saveWorkoutPlan(userId, planTitle, days) {
    if (!userId || !planTitle || !days) throw new Error('MISSING_DATA');
    return await WorkoutPlanModel.saveWorkoutPlan(userId, planTitle, days);
  }

  static async getWorkoutPlansByUser(userId) {
    if (!userId) throw new Error('MISSING_DATA');
    return await WorkoutPlanModel.getWorkoutPlansByUser(userId);
  }

  static async getLatestWorkoutPlan(userId) {
    if (!userId) throw new Error('MISSING_DATA');
    return await WorkoutPlanModel.getLatestWorkoutPlanByUser(userId);
  }

    static async getLatestWorkoutPlan(userId) {
      if (!userId) throw new Error('MISSING_DATA');
      return await WorkoutPlanModel.getLatestWorkoutPlan(userId);
    }
}

module.exports = WorkoutPlanService;
