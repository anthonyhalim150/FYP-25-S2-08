const db = require('../config/db');

class UserPreferencesEntity {
  async savePreferences(userId, preferences) {
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
}

module.exports = new UserPreferencesEntity();
