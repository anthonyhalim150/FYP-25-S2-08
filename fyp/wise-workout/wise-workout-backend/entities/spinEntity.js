const db = require('../config/db');

const prizes = [
  { label: '10 Coins', type: 'coins', value: 10 },
  { label: '50 Coins', type: 'coins', value: 50 },
  { label: 'Nothing', type: 'none', value: 0 },
  { label: 'Premium 1 Day', type: 'premium', value: 1 },
];

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

  async deductCoins(userId, amount) {
    const [result] = await db.execute(
      'UPDATE users SET coins = coins - ? WHERE id = ? AND coins >= ?',
      [amount, userId, amount]
    );
    return result.affectedRows > 0;
  }

  async applyPrize(userId, prize) {
    if (prize.type === 'coins') {
      await db.execute(
        'UPDATE users SET coins = coins + ? WHERE id = ?',
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

  getRandomPrize() {
    return prizes[Math.floor(Math.random() * prizes.length)];
  }
}

module.exports = new SpinEntity();
