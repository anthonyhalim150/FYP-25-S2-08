const db = require('../config/db');

class FeedbackModel {
  static async findAllWithUser({ status = 'All', search = '' } = {}) {
    let query = `
      SELECT f.*, u.username, u.email, u.role, u.avatar_id
      FROM feedback f
      LEFT JOIN users u ON u.id = f.user_id
      WHERE 1
    `;
    let params = [];
    if (status && status !== 'All') {
      query += ' AND f.status = ?';
      params.push(status.toLowerCase());
    }
    if (search) {
      query += ' AND (u.username LIKE ? OR u.email LIKE ? OR f.message LIKE ?)';
      params.push(`%${search}%`, `%${search}%`, `%${search}%`);
    }
    query += ' ORDER BY f.created_at DESC';
    const [rows] = await db.execute(query, params);
    return rows;
  }
  static async updateStatus(id, status) {
    await db.execute('UPDATE feedback SET status = ? WHERE id = ?', [status, id]);
  }
}

module.exports = FeedbackModel;
