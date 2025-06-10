const db = require('../config/db');

class BackgroundEntity {
  async findById(id) {
    const [rows] = await db.execute('SELECT * FROM backgrounds WHERE id = ?', [id]);
    return rows[0] || null;
  }

  async getAll() {
    const [rows] = await db.execute('SELECT * FROM backgrounds');
    return rows;
  }
  async updateBackground(userId, backgroundId) {
    const [result] = await db.execute(
      'UPDATE users SET background_id = ? WHERE id = ?',
      [backgroundId, userId]
    );
    return result;
  }
}

module.exports = new BackgroundEntity();
