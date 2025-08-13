const db = require('../config/db');

class WorkoutPlanModel {
  static async saveWorkoutPlan(userId, planTitle, daysJson) {
    await db.execute('DELETE FROM workout_plans WHERE user_id = ?', [userId]);
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

  static async getLatestWorkoutPlanByUser(userId) {
    const [rows] = await db.execute(
      `SELECT id, user_id, plan_title, days_json, created_at
         FROM workout_plans
        WHERE user_id = ?
     ORDER BY created_at DESC, id DESC
        LIMIT 1`,
      [userId]
    );
    return rows[0] || null;
  }

  static async getLatestWorkoutPlan(userId) {
      const [rows] = await db.execute(
        `SELECT id, user_id, plan_title, days_json, created_at
           FROM workout_plans
          WHERE user_id = ?
       ORDER BY created_at DESC, id DESC
          LIMIT 1`,
        [userId]
      );
      return rows[0] || null;
    }
}

module.exports = WorkoutPlanModel;
