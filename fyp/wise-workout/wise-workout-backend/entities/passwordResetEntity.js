const db = require('../config/db');

class PasswordResetEntity {
  async create(email, token, expiresAt) {
    await db.execute(
      'INSERT INTO password_resets (email, token, expires_at) VALUES (?, ?, ?)',
      [email, token, expiresAt]
    );
  }

  async findValidToken(email, token) {
    const [rows] = await db.execute(
      'SELECT * FROM password_resets WHERE email = ? AND token = ? AND expires_at > NOW()',
      [email, token]
    );
    return rows[0] || null;
  }

  async deleteByEmail(email) {
    await db.execute('DELETE FROM password_resets WHERE email = ?', [email]);
  }
}

module.exports = new PasswordResetEntity();
