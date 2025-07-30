const db = require('../config/db');

class WorkoutSessionModel {
  static async createSession({ userId, workoutId, startTime, endTime, duration, caloriesBurned, notes }) {
    const [result] = await db.execute(
      `INSERT INTO workout_sessions (user_id, workout_id, start_time, end_time, duration, calories_burned, notes)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [userId, workoutId, startTime, endTime, duration, caloriesBurned, notes]
    );
    return result.insertId;
  }

  static async getSessionsByUserId(userId) {
    const [rows] = await db.execute(
      `SELECT 
        ws.session_id,
        ws.workout_id,
        ws.start_time,
        ws.end_time,
        ws.duration,
        ws.calories_burned,
        ws.notes,
        ws.created_at,
        w.workout_name
      FROM workout_sessions ws
      LEFT JOIN workouts w ON ws.workout_id = w.workout_id
      WHERE ws.user_id = ?
      ORDER BY ws.start_time DESC`,
      [userId]
    );
    return rows;
  }

  static async countSessionsByUserId(userId) {
    const [rows] = await db.execute(
      'SELECT COUNT(*) as session_count FROM workout_sessions WHERE user_id = ?',
      [userId]
    );
    return rows[0].session_count;
  }

  static async getTotalCaloriesBurnedByUserId(userId) {
    const [rows] = await db.execute(
      'SELECT SUM(calories_burned) as total_calories FROM workout_sessions WHERE user_id = ?',
      [userId]
    );
    return rows[0].total_calories || 0;
  }
}

module.exports = WorkoutSessionModel;
