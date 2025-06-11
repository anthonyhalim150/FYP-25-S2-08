const db = require('../config/db');

class SpinEntity {
  async hasSpunToday(userId) {
    const [rows] = await db.execute(
      'SELECT * FROM spin_history WHERE user_id = ? AND DATE(spun_at) = CURDATE()',
      [userId]
    );
    return rows.length > 0;
  }

  async getLastSpin(userId) {
    const [rows] = await db.execute(
      'SELECT spun_at FROM spin_history WHERE user_id = ? ORDER BY spun_at DESC LIMIT 1',
      [userId]
    );
    return rows[0] || null;
  }

  async deductTokens(userId, amount) {
    const [result] = await db.execute(
      'UPDATE users SET tokens = tokens - ? WHERE id = ? AND tokens >= ?',
      [amount, userId, amount]
    );
    return result.affectedRows > 0;
  }

  async applyPrize(userId, prize) {
    if (prize.type === 'tokens') {
      await db.execute(
        'UPDATE users SET tokens = tokens + ? WHERE id = ?',
        [prize.value, userId]
      );
    } else if (prize.type === 'premium') {
      await db.execute(
        'UPDATE users SET isPremium = true WHERE id = ?',
        [userId]
      );
    }
  }

  async logSpin(userId, prize) {
    await db.execute(
      'INSERT INTO spin_history (user_id, prize_label, prize_type, prize_value) VALUES (?, ?, ?, ?)',
      [userId, prize.label, prize.type, prize.value]
    );
  }

  async getAllPrizes() {
    const [rows] = await db.execute('SELECT * FROM prizes');
    return rows;
  }
}

module.exports = new SpinEntity();
