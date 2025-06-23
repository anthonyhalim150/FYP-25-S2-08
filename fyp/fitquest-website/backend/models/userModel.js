const db = require('../config/db');
const bcrypt = require('bcrypt');

class UserModel {
  static async create(email, username, password = null, method = 'database') {
    let hashedPassword = null;
    if (method === 'database' && password) {
      hashedPassword = await bcrypt.hash(username + password, 10);
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
    const isMatch = await bcrypt.compare(user.username + password, user.password);
    return isMatch ? user : null;
  }
}

module.exports = UserModel;