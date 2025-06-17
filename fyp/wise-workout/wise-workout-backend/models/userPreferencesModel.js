const db = require('../config/db');

class UserPreferencesModel {
  static async savePreferences(userId, preferences) {
    const {
      workout_frequency,
      fitness_goal,
      workout_time,
      fitness_level,
      injury
    } = preferences;

    const sql = `
      INSERT INTO user_preferences (
        user_id,
        workout_frequency,
        fitness_goal,
        workout_time,
        fitness_level,
        injury
      ) VALUES (?, ?, ?, ?, ?, ?)
    `;

    const [result] = await db.execute(sql, [
      userId,
      workout_frequency,
      fitness_goal,
      workout_time,
      fitness_level,
      injury
    ]);

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
