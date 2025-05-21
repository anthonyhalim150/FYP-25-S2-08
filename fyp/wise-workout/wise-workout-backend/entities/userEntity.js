const db = require('../config/db');
const bcrypt = require('bcrypt');

class UserEntity {
  async create(email, username, password = null, method = 'database', isHashed = false) {
    let hashedPassword = null;
    if (method === 'database' && password) {
      hashedPassword = isHashed ? password : await bcrypt.hash(password, 10);
    }

    const [result] = await db.execute(
      'INSERT INTO users (email, username, password, method) VALUES (?, ?, ?, ?)',
      [email, username, hashedPassword, method]
    );

    return result;
  }

  async findByEmail(email) {
    const [rows] = await db.execute(
      'SELECT * FROM users WHERE email = ?',
      [email]
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

  async findByUsername(username) {
    const [rows] = await db.execute(
      'SELECT * FROM users WHERE username = ?',
      [username]
    );
    return rows[0] || null;
  }
}

module.exports = UserEntity;
