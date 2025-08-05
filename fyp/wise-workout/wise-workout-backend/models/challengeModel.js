// models/challengeModel.js
const db = require('../config/db');

const ChallengeModel = {
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
  }
};

module.exports = ChallengeModel;
