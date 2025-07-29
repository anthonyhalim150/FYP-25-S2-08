const db = require('../config/db');

class ExerciseLogModel {
  static async logExercise(sessionId, { exerciseKey, exerciseName, setsData }) {
    const [result] = await db.execute(
      `INSERT INTO exercise_logs (session_id, exercise_key, exercise_name, sets_data)
       VALUES (?, ?, ?, ?)`,
      [sessionId, exerciseKey, exerciseName, JSON.stringify(setsData)]
    );
    return result.insertId;
  }

  static async getExerciseLogsBySessionId(sessionId) {
    const [rows] = await db.execute(
      `SELECT 
        log_id,
        exercise_key,
        exercise_name,
        sets_data,
        created_at
      FROM exercise_logs
      WHERE session_id = ?
      ORDER BY created_at ASC`,
      [sessionId]
    );
    return rows.map(row => ({
      ...row,
      sets_data: JSON.parse(row.sets_data)
    }));
  }
}

module.exports = ExerciseLogModel;
