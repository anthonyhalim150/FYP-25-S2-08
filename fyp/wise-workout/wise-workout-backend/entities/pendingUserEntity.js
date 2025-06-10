const db = require('../config/db');

class PendingUserEntity {
  async create(email, username = null, hashedPassword, otp, expiresAt) {
    if (!username) {
      const randomSuffix = Math.floor(1000 + Math.random() * 9000);
      username = `user${randomSuffix}`;
    }

    await db.execute(
      'DELETE FROM pending_users WHERE email = ? OR username = ?',
      [email, username]
    );

    const [result] = await db.execute(
      'INSERT INTO pending_users (email, username, password, otp, expires_at) VALUES (?, ?, ?, ?, ?)',
      [email, username, hashedPassword, otp, expiresAt]
    );

    return result;
  }

  async findByEmail(email) {
    const [rows] = await db.execute(
      'SELECT * FROM pending_users WHERE email = ?',
      [email]
    );
    return rows[0] || null;
  }

  async verifyOTP(email, code) {
    const [rows] = await db.execute(
      'SELECT * FROM pending_users WHERE email = ? AND otp = ? AND expires_at > NOW()',
      [email, code]
    );
    return rows[0] || null;
  }

  async deleteByEmail(email) {
    await db.execute(
      'DELETE FROM pending_users WHERE email = ?',
      [email]
    );
  }
}

module.exports = new PendingUserEntity();
