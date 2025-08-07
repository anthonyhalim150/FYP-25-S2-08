// models/challengeModel.js
const db = require('../config/db');

const ChallengeModel = {
  getAllChallenges: async () => {
    const [rows] = await db.execute('SELECT id, type, value, duration FROM challenges');
    return rows;
  },
  // Get all pending challenge invites for a user
  getPendingInvites: async (userId) => {
    const [rows] = await db.execute(
      `SELECT ci.id, c.type, c.value, c.duration, u.username as senderName
       FROM challenge_invites ci
       JOIN challenges c ON ci.challenge_id = c.id
       JOIN users u ON ci.sender_id = u.id
       WHERE ci.receiver_id = ? AND ci.status = 'pending'`,
      [userId]
    );
    return rows;
  },

  // Get all accepted challenges for a user with daysLeft calculation
  getAcceptedChallenges: async (userId) => {
    const [rows] = await db.execute(
      `SELECT ci.id, c.type, c.value, c.duration,
              DATEDIFF(DATE_ADD(ci.updated_at, INTERVAL c.duration DAY), NOW()) AS daysLeft,
              u.username as senderName
       FROM challenge_invites ci
       JOIN challenges c ON ci.challenge_id = c.id
       JOIN users u ON ci.sender_id = u.id
       WHERE ci.receiver_id = ? AND ci.status = 'accepted'`,
      [userId]
    );
    return rows;
  },

  // Update the status of a challenge invite (accept or reject)
  updateInviteStatus: async (inviteId, status) => {
    const [result] = await db.execute(
      'UPDATE challenge_invites SET status = ?, updated_at = NOW() WHERE id = ?',
      [status, inviteId]
    );
    return result;
  },

  createChallengeAndInvite: async (senderId, receiverId, title, target, duration) => {
    const connection = await db.getConnection();
    try {
      await connection.beginTransaction();

      // Insert challenge into `challenges`
      const [challengeResult] = await connection.execute(
        'INSERT INTO challenges (type, value, duration) VALUES (?, ?, ?)',
        [title, target, duration]
      );

      const challengeId = challengeResult.insertId;

      // Insert into `challenge_invites`
      const [inviteResult] = await connection.execute(
        'INSERT INTO challenge_invites (challenge_id, sender_id, receiver_id) VALUES (?, ?, ?)',
        [challengeId, senderId, receiverId]
      );

      await connection.commit();
      return challengeId;
    } catch (err) {
      await connection.rollback();
      throw err;
    } finally {
      connection.release();
    }
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
