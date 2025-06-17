const db = require('../config/db');

class PasswordResetModel {
  static async create(email, token, expiresAt) {
    await db.execute(
      'INSERT INTO password_resets (email, token, expires_at) VALUES (?, ?, ?)',
      [email, token, expiresAt]
    );
  }

  static async findValidToken(email, token) {
    const [rows] = await db.execute(
      'SELECT * FROM password_resets WHERE email = ? AND token = ? AND expires_at > NOW()',
      [email, token]
    );
    return rows[0] || null;
  }

  static async deleteByEmail(email) {
    await db.execute('DELETE FROM password_resets WHERE email = ?', [email]);
  }
}

module.exports = PasswordResetModel;
