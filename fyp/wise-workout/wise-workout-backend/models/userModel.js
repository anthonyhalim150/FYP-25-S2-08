const db = require('../config/db');
const bcrypt = require('bcryptjs');
const PEPPER = require('../config/auth');

class UserModel {
  static async create(email, username = null, password = null, method = 'database', firstName = '', lastName = '', skipHash = false) {
    let hashedPassword = null;
    if (method === 'database' && password) {
        hashedPassword = skipHash ? password : await bcrypt.hash(password, 12);
    }
    if (!username) {
        const randomSuffix = Math.floor(1000 + Math.random() * 9000);
        username = `user${randomSuffix}`;
    }
    const [result] = await db.execute(
        `INSERT INTO users (email, username, password, method, firstName, lastName) VALUES (?, ?, ?, ?, ?, ?)`,
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

    const isMatch = await bcrypt.compare(PEPPER+password, user.password);
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
  static async updatePasswordByEmail(email, hashedPassword) {
    await db.execute(
      'UPDATE users SET password = ? WHERE email = ? AND method = "database"',
      [hashedPassword, email]
    );
  }
  static async searchUsersWithStatus(query, userId) {
    let sql = `
      SELECT u.id, u.username, u.email, u.firstName, u.lastName,
        a.image_url as avatar_url,
        b.image_url as background_url,
        CASE
          WHEN f1.status = 'accepted' OR f2.status = 'accepted' THEN 'friends'
          WHEN f1.status = 'pending' THEN 'sent'        -- You sent them a request
          WHEN f2.status = 'pending' THEN 'pending'     -- They sent you a request
          ELSE 'none'
        END as relationship_status
      FROM users u
      LEFT JOIN friends f1
        ON f1.user_id = ? AND f1.friend_id = u.id
      LEFT JOIN friends f2
        ON f2.user_id = u.id AND f2.friend_id = ?
      LEFT JOIN avatars a ON u.avatar_id = a.id
      LEFT JOIN backgrounds b ON u.background_id = b.id
      WHERE (u.username LIKE ? OR u.email LIKE ?)
        AND u.id != ?
      LIMIT 20
    `;
    const values = [userId, userId, `%${query}%`, `%${query}%`, userId];
    const [rows] = await db.execute(sql, values);
    return rows;
  }

  static async addXP(userId, amount) {
    await db.execute('UPDATE users SET xp = xp + ? WHERE id = ?', [amount, userId]);
  }

}

module.exports = UserModel;
