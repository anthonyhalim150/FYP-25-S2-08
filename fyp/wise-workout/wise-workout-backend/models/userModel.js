const db = require('../config/db');
const bcrypt = require('bcryptjs');

class UserModel {
  static async create(email, username = null, password = null, method = 'database', firstName = '', lastName = '') {
    let hashedPassword = null;
    if (method === 'database' && password) {
      hashedPassword = await bcrypt.hash(password, 10);
    }

    if (!username) {
      const randomSuffix = Math.floor(1000 + Math.random() * 9000);
      username = `user${randomSuffix}`;
    }

    const [result] = await db.execute(
      `INSERT INTO users (email, username, password, method, firstName, lastName)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [email, username, hashedPassword, method, firstName, lastName]
    );

    return result;
  }

  static async findById(userId) {
    const [rows] = await db.execute(
      'SELECT * FROM users WHERE id = ?',
      [userId]
    );
    return rows[0] || null;
  }

  static async findByEmail(email) {
    const [rows] = await db.execute(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );
    return rows[0] || null;
  }

  static async findByUsername(username) {
    const [rows] = await db.execute(
      'SELECT * FROM users WHERE username = ?',
      [username]
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

    const isMatch = await bcrypt.compare(password, user.password);
    return isMatch ? user : null;
  }

  static async getTokenCount(userId) {
    const [rows] = await db.execute(
      'SELECT tokens FROM users WHERE id = ?',
      [userId]
    );
    return rows[0]?.tokens ?? 0;
  }

  static async updateDOB(userId, dob) {
    const [result] = await db.execute(
      'UPDATE users SET dob = ? WHERE id = ?',
      [dob, userId]
    );
    return result;
  }

  static async updateProfile(userId, updates) {
    const fields = [];
    const values = [];

    if (updates.username) {
      fields.push('username = ?');
      values.push(updates.username);
    }
    if (updates.firstName) {
      fields.push('firstName = ?');
      values.push(updates.firstName);
    }
    if (updates.lastName) {
      fields.push('lastName = ?');
      values.push(updates.lastName);
    }
    if (updates.dob) {
      fields.push('dob = ?');
      values.push(updates.dob);
    }

    if (fields.length === 0) return;

    values.push(userId);

    const sql = `UPDATE users SET ${fields.join(', ')} WHERE id = ?`;
    await db.execute(sql, values);
  }
}

module.exports = UserModel;
