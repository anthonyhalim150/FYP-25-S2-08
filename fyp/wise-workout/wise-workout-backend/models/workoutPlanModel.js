const db = require('../config/db');

class WorkoutPlanModel {
  static async saveWorkoutPlan(userId, planTitle, daysJson) {
    const [result] = await db.execute(
      `INSERT INTO workout_plans (user_id, plan_title, days_json, created_at)
       VALUES (?, ?, ?, NOW())`,
      [userId, planTitle, JSON.stringify(daysJson)]
    );
    return result.insertId;
  }

  static async getWorkoutPlansByUser(userId) {
    const [rows] = await db.execute(
      `SELECT * FROM workout_plans WHERE user_id = ? ORDER BY created_at DESC`,
      [userId]
    );
    return rows;
  }
}

module.exports = WorkoutPlanModel;
