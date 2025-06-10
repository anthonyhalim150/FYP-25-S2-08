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
}

module.exports = new BackgroundEntity();
