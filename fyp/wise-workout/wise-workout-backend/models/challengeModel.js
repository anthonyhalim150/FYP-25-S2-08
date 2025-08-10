const db = require('../config/db');

const ChallengeModel = {
  getAllChallenges: async () => {
    const [rows] = await db.execute('SELECT id, type, value, unit, duration FROM challenges');
    return rows;
  },
  findChallengeIdByTitle: async (title) => {
    const [rows] = await db.execute('SELECT id FROM challenges WHERE type = ?', [title]);
    return rows[0]?.id || null;
  },
  getLeaderboardsByUser: async (userId) => {
    const [rows] = await db.execute(
      `SELECT
         ci.id AS invite_id,
         c.type, c.value, c.unit, c.duration,
         u.id AS user_id, u.username,
         CAST(SUM(cp.progress_value) AS UNSIGNED) AS progress,
         ci.accepted_at,
         ci.expires_at,
         GREATEST(0, DATEDIFF(ci.expires_at, NOW())) AS days_left,
         TIMESTAMPDIFF(DAY, ci.accepted_at, ci.expires_at) AS total_days
       FROM challenge_invites ci
       JOIN challenges c ON ci.challenge_id = c.id
       JOIN challenge_progress cp ON cp.challenge_invite_id = ci.id
       JOIN users u ON u.id = cp.user_id
       WHERE ci.status = 'accepted'
         AND (ci.sender_id = ? OR ci.receiver_id = ?)
       GROUP BY ci.id, u.id
       ORDER BY ci.id, progress DESC`,
      [userId, userId]
    );
    return rows;
  }  
};

module.exports = ChallengeModel;
