const db = require('../config/db');

class UserWorkoutPlanModel {
  static async getPlansByUserId(userId) {
    const [rows] = await db.execute(
      `SELECT plan_id, plan_title, created_at
       FROM user_workout_plan
       WHERE user_id = ?`,
      [userId]
    );
    return rows;
  }

  static async createPlan(userId, planTitle) {
    const [result] = await db.execute(
      `INSERT INTO user_workout_plan (user_id, plan_title)
       VALUES (?, ?)`,
      [userId, planTitle]
    );
    return result.insertId;
  }

  static async getItemsByPlanId(planId) {
    const [rows] = await db.execute(
      `SELECT exercise_name, exercise_reps, exercise_sets, exercise_duration
       FROM user_workout_plan_items
       WHERE plan_id = ?`,
      [planId]
    );
    return rows;
  }

  static async deletePlan(planId, userId) {
    const [result] = await db.execute(
      `DELETE FROM user_workout_plan
       WHERE plan_id = ? AND user_id = ?`,
      [planId, userId]
    );
    return result.affectedRows > 0;
  }

  static async addItemForUser(userId, planId, item) {
    // ensure plan belongs to user
    const [own] = await db.execute(
      'SELECT 1 FROM user_workout_plan WHERE plan_id = ? AND user_id = ? LIMIT 1',
      [planId, userId]
    );
    if (own.length === 0) return null;

    const { exercise_name, exercise_reps, exercise_sets, exercise_duration } = item;

    const [res] = await db.execute(
      `INSERT INTO user_workout_plan_items
       (plan_id, exercise_name, exercise_reps, exercise_sets, exercise_duration)
       VALUES (?, ?, ?, ?, ?)`,
      [planId, exercise_name, exercise_reps, exercise_sets, exercise_duration]
    );
    return res.insertId;
  }

}

module.exports = UserWorkoutPlanModel;
