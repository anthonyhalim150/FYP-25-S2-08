const db = require('../config/db');

const ChallengeInvitesModel = {
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
  getInviteForAcceptance: async (inviteId) => {
    const [rows] = await db.execute(
      `SELECT ci.id, ci.receiver_id, ci.custom_duration_value, ci.custom_duration_unit, c.duration
       FROM challenge_invites ci
       JOIN challenges c ON ci.challenge_id = c.id
       WHERE ci.id = ? FOR UPDATE`,
      [inviteId]
    );
    return rows[0] || null;
  },
  markInviteAccepted: async (inviteId, acceptedAt, expiresAt) => {
    const [r] = await db.execute(
      'UPDATE challenge_invites SET status = ?, accepted_at = ?, expires_at = ? WHERE id = ?',
      ['accepted', acceptedAt, expiresAt, inviteId]
    );
    return r;
  },
  markInviteRejected: async (inviteId) => {
    const [r] = await db.execute(
      'UPDATE challenge_invites SET status = ? WHERE id = ?',
      ['rejected', inviteId]
    );
    return r;
  },
  createChallengeInvite: async (challengeId, senderId, receiverId, customValue, customDurationValue, customDurationUnit) => {
    const [result] = await db.execute(
      `INSERT INTO challenge_invites
        (challenge_id, sender_id, receiver_id, custom_value, custom_duration_value, custom_duration_unit)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [challengeId, senderId, receiverId, customValue, customDurationValue, customDurationUnit]
    );
    return result;
  },
  getPremiumFriendsToChallenge: async (userId, title) => {
    const [rows] = await db.execute(
      `SELECT u.id, u.username, u.firstName, u.lastName, u.email, u.role,
              a.image_url AS avatar_url, b.image_url AS background_url
       FROM friends f
       JOIN users u ON u.id = f.friend_id
       LEFT JOIN avatars a ON u.avatar_id = a.id
       LEFT JOIN backgrounds b ON u.background_id = b.id
       WHERE f.user_id = ?
         AND f.status = 'accepted'
         AND u.role = 'premium'
         AND NOT EXISTS (
           SELECT 1
           FROM challenge_invites ci
           JOIN challenges c ON c.id = ci.challenge_id
           WHERE c.type = ?
             AND (
               (ci.sender_id = ? AND ci.receiver_id = u.id)
               OR
               (ci.sender_id = u.id AND ci.receiver_id = ?)
             )
             AND (
               ci.status = 'pending'
               OR (ci.status = 'accepted' AND ci.expires_at > NOW())
             )
         )`,
      [userId, title, userId, userId]
    );
    return rows;
  }  
};

module.exports = ChallengeInvitesModel;
