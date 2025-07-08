const db = require('../config/db');

class MessageModel {
  static async sendMessage(senderId, receiverId, content) {
    const [result] = await db.execute(
      'INSERT INTO messages (sender_id, receiver_id, content) VALUES (?, ?, ?)',
      [senderId, receiverId, content]
    );
    return result;
  }

  static async getConversation(userId1, userId2) {
    const [rows] = await db.execute(
      `SELECT * FROM messages 
       WHERE (sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)
       ORDER BY sent_at ASC`,
      [userId1, userId2, userId2, userId1]
    );
    return rows;
  }
}

module.exports = MessageModel;
