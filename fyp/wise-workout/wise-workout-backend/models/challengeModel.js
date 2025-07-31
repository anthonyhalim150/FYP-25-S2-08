const db = require('../config/db');

async function createChallenge(senderId, receiverId, title, target, duration) {
  const [result] = await db.query(
    'INSERT INTO challenges (sender_id, receiver_id, title, target, duration, status, created_at) VALUES (?, ?, ?, ?, ?, "pending", NOW())',
    [senderId, receiverId, title, target, duration]
  );
  return result.insertId;
}

async function getAcceptedChallenges(userId) {
  const [rows] = await db.query(
    `SELECT * FROM challenges
     WHERE receiver_id = ? AND status = 'accepted'`,
    [userId]
  );
  return rows;
}

async function getReceivedChallenges(userId) {
  const [rows] = await db.query(
    `SELECT c.*, u.username as sender_username
     FROM challenges c
     JOIN users u ON c.sender_id = u.id
     WHERE c.receiver_id = ? AND c.status = "pending"`,
    [userId]
  );
  return rows;
}

async function updateChallengeStatus(challengeId, status) {
  await db.query(
    'UPDATE challenges SET status = ? WHERE id = ?',
    [status, challengeId]
  );
}

module.exports = {
  createChallenge,
  getAcceptedChallenges,
  getReceivedChallenges,
  updateChallengeStatus,
};
