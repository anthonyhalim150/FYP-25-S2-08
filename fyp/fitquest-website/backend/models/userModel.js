const db = require('../config/db');
const bcrypt = require('bcrypt');
const PEPPER = require('../config/auth');

class UserModel {
  static async create(email, username, password = null, method = 'database') {
    let hashedPassword = null;
    if (method === 'database' && password) {
      hashedPassword = await bcrypt.hash(PEPPER + password, 12);
    }
    const [result] = await db.execute(
      'INSERT INTO users (email, username, password, method) VALUES (?, ?, ?, ?)',
      [email, username, hashedPassword, method]
    );
    return result;
  }

  static async findByEmail(email) {
    const [rows] = await db.execute(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );
    return rows[0] || null;
  }

  static async verifyLogin(email, password) {
    const [rows] = await db.execute(
      'SELECT * FROM users WHERE email = ? AND method = "database"',
      [email]
    );
    const user = rows[0];
    if (!user || !user.password) return null;
    const isMatch = await bcrypt.compare(PEPPER + password, user.password);
    return isMatch ? user : null;
  }

  static async getTotalUserCount() {
    const [rows] = await db.execute('SELECT COUNT(*) AS total FROM users');
    return rows[0]?.total || 0;
  }

  static async getActiveUserCount() {
    const [rows] = await db.execute('SELECT COUNT(*) AS active FROM users WHERE role != "suspended"');
    return rows[0]?.active || 0;
  }

  static async getPremiumUserCount() {
    const [rows] = await db.execute('SELECT COUNT(*) AS premium FROM users WHERE role = "premium"');
    return rows[0]?.premium || 0;
  }
  static async findAllWithPreferences() {
    const [rows] = await db.execute(`
      SELECT 
        u.id, u.username, u.email, u.role, u.tokens, u.created_at, u.updated_at,
        u.firstName, u.lastName, u.dob,
        IF(u.role='premium', 'Premium', 'Free') AS account,
        up.workout_frequency, up.fitness_goal, up.workout_time, up.fitness_level, up.injury
      FROM users u
      LEFT JOIN user_preferences up ON up.user_id = u.id
    `);
    console

    return rows.map((row) => ({
      id: row.id,
      username: row.username,
      email: row.email,
      role: row.role === 'premium' ? 'Premium' : 'Free',
      level: `Lvl. ${row.tokens || 1}`,
      isSuspended: row.role === 'suspended',
      first_name: row.firstName,
      last_name: row.lastName,
      dob: row.dob,
      account: row.account,
      preferences: {
        workout_frequency: row.workout_frequency || 'N/A',
        fitness_goal: row.fitness_goal || 'N/A',
        workout_time: row.workout_time || 'N/A',
        fitness_level: row.fitness_level || 'N/A',
        injury: row.injury || 'N/A',
      }
    }));
  }
}

module.exports = UserModel;
