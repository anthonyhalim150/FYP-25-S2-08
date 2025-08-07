const db = require('../config/db');

const ChallengeModel = {
  getAllChallenges: async () => {
    const [rows] = await db.execute('SELECT id, type, value, unit, duration FROM challenges');
    return rows;
  },

  getPendingInvites: async (userId) => {
    const [rows] = await db.execute(
      `SELECT ci.id, c.type, c.value, c.unit, c.duration, ci.custom_value, ci.custom_duration_value, ci.custom_duration_unit, u.username as senderName
       FROM challenge_invites ci
       JOIN challenges c ON ci.challenge_id = c.id
       JOIN users u ON ci.sender_id = u.id
       WHERE ci.receiver_id = ? AND ci.status = 'pending'`,
      [userId]
    );
    return rows;
  },

  getAcceptedChallenges: async (userId) => {
    const [rows] = await db.execute(
      `SELECT ci.id, c.type, c.value, c.unit, c.duration, ci.custom_value, ci.custom_duration_value, ci.custom_duration_unit,
              DATEDIFF(ci.expires_at, NOW()) AS daysLeft,
              u.username as senderName
       FROM challenge_invites ci
       JOIN challenges c ON ci.challenge_id = c.id
       JOIN users u ON ci.sender_id = u.id
       WHERE ci.receiver_id = ? AND ci.status = 'accepted'`,
      [userId]
    );
    return rows;
  },

  updateInviteStatus: async (inviteId, status) => {
    if (status === 'accepted') {
      const [inviteRows] = await db.execute(
        `SELECT ci.id, ci.custom_duration_value, ci.custom_duration_unit, c.duration
         FROM challenge_invites ci
         JOIN challenges c ON ci.challenge_id = c.id
         WHERE ci.id = ?`,
        [inviteId]
      );
      if (inviteRows.length === 0) throw new Error('Invite not found');
      const invite = inviteRows[0];
      const acceptedAt = new Date();
      let durationValue = invite.custom_duration_value || invite.duration;
      let unit = (invite.custom_duration_unit || 'days').toLowerCase();
      let durationMs;
      if (unit === 'weeks') durationMs = durationValue * 7 * 24 * 60 * 60 * 1000;
      else if (unit === 'months') durationMs = durationValue * 30 * 24 * 60 * 60 * 1000;
      else durationMs = durationValue * 24 * 60 * 60 * 1000;
      const expiresAt = new Date(acceptedAt.getTime() + durationMs);
      const [result] = await db.execute(
        'UPDATE challenge_invites SET status = ?, accepted_at = ?, expires_at = ? WHERE id = ?',
        [status, acceptedAt, expiresAt, inviteId]
      );
      return result;
    } else {
      const [result] = await db.execute(
        'UPDATE challenge_invites SET status = ? WHERE id = ?',
        [status, inviteId]
      );
      return result;
    }
  },
  createChallengeInvite: async (
    challengeId,
    senderId,
    receiverId,
    customValue,
    customDurationValue,
    customDurationUnit
  ) => {
    const [result] = await db.execute(
      `INSERT INTO challenge_invites
        (challenge_id, sender_id, receiver_id, custom_value, custom_duration_value, custom_duration_unit)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [challengeId, senderId, receiverId, customValue, customDurationValue, customDurationUnit]
    );
    return result;
  },

  findChallengeIdByTitle: async (title) => {
    const [rows] = await db.execute(
      'SELECT id FROM challenges WHERE type = ?',
      [title]
    );
    if (rows.length === 0) throw new Error('Challenge template not found');
    return rows[0].id;
  },

  getPremiumFriendsToChallenge: async (userId, title) => {
    const [rows] = await db.execute(
      `SELECT u.id, u.username, u.firstName, u.lastName, u.email, u.role,
              a.image_url as avatar_url, b.image_url as background_url
       FROM friends f
       JOIN users u ON u.id = f.friend_id
       LEFT JOIN avatars a ON u.avatar_id = a.id
       LEFT JOIN backgrounds b ON u.background_id = b.id
       WHERE f.user_id = ?
         AND f.status = "accepted"
         AND u.role = "premium"
         AND u.id NOT IN (
           SELECT ci.receiver_id
           FROM challenge_invites ci
           JOIN challenges c ON ci.challenge_id = c.id
           WHERE ci.sender_id = ? AND c.type = ?
             AND (
               ci.status = 'pending'
               OR (ci.status = 'accepted' AND ci.expires_at > NOW())
             )
         )`,
      [userId, userId, title]
    );
    return rows;
  }
};

module.exports = ChallengeModel;
