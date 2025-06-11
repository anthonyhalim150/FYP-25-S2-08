const db = require('../config/db');

class PrizeEntity {
  async getAll() {
    const [rows] = await db.execute('SELECT * FROM prizes');
    return rows;
  }

  async findById(prizeId) {
    const [rows] = await db.execute(
      'SELECT * FROM prizes WHERE id = ?',
      [prizeId]
    );
    return rows[0] || null;
  }
}

module.exports = new PrizeEntity();
