const db = require('../config/db');
const bcrypt = require('bcryptjs');

class UserEntity {
  async create(email, username = null, password = null, method = 'database', firstName = '', lastName = '') {
    let hashedPassword = null;
    if (method === 'database' && password) {
      hashedPassword = await bcrypt.hash(password, 10);
    }

    if (!username) {
      const randomSuffix = Math.floor(1000 + Math.random() * 9000);
      username = `user${randomSuffix}`;
    }

    const [result] = await db.execute(
      'INSERT INTO users (email, username, password, method, firstName, lastName) VALUES (?, ?, ?, ?, ?, ?)',
      [email, username, hashedPassword, method, firstName, lastName]
    );

    return result;
  }

  async findById(userId) {
    const [rows] = await db.execute(
      'SELECT * FROM users WHERE id = ?',
      [userId]
    );
    return rows[0] || null;
  }

  async findByEmail(email) {
    const [rows] = await db.execute(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );
    return rows[0] || null;
  }

  async findByUsername(username) {
    const [rows] = await db.execute(
      'SELECT * FROM users WHERE username = ?',
      [username]
    );
    return rows[0] || null;
  }

  async verifyLogin(email, password) {
    const [rows] = await db.execute(
      'SELECT * FROM users WHERE email = ? AND method = "database"',
      [email]
    );

    const user = rows[0];
    if (!user || !user.password) return null;

    const isMatch = await bcrypt.compare(password, user.password);
    return isMatch ? user : null;
  }
  async getTokenCount(userId) {
    const [rows] = await db.execute(
      'SELECT tokens FROM users WHERE id = ?',
      [userId]
    );
    return rows[0]?.tokens ?? 0;
  }

}

module.exports = new UserEntity();
