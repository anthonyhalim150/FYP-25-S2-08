const db = require('../config/db');

const ChallengeModel = {
  getAllChallenges: async () => {
    const [rows] = await db.execute('SELECT id, type, value, unit, duration FROM challenges');
    return rows;
  },
  findChallengeIdByTitle: async (title) => {
    const [rows] = await db.execute('SELECT id FROM challenges WHERE type = ?', [title]);
    return rows[0]?.id || null;
  }
};

module.exports = ChallengeModel;
