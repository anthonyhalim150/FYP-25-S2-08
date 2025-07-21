const db = require('../config/db');

class UserPreferencesModel {
  static async savePreferences(userId, preferences) {
  const {
    height_cm,
    weight_kg,
    gender,
    workout_days,
    workout_time,
    equipment_pref,
    fitness_goal,
    fitness_level,
    injury,
    enjoyed_workouts,
    bmi_value
  } = preferences;

  const sql = `
    INSERT INTO user_preferences (
      user_id, height_cm, weight_kg, gender, workout_days, workout_time,
      equipment_pref, fitness_goal, fitness_level, injury, enjoyed_workouts, bmi_value
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  const values = [
    userId,
    height_cm,
    weight_kg,
    gender,
    workout_days,
    workout_time,
    equipment_pref,
    fitness_goal,
    fitness_level,
    injury,
    enjoyed_workouts,
    bmi_value
  ];


  const [result] = await db.execute(sql, values);
  return result;
}


  static async hasPreferences(userId) {
    const [rows] = await db.execute(
      'SELECT id FROM user_preferences WHERE user_id = ? LIMIT 1',
      [userId]
    );
    return rows.length > 0;
  }
}

module.exports = UserPreferencesModel;
