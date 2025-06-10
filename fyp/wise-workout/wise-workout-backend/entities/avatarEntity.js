const db = require('../config/db');

class AvatarEntity {
  async findById(avatarId) {
    const [rows] = await db.execute(
      'SELECT * FROM avatars WHERE id = ?',
      [avatarId]
    );
    return rows[0] || null;
  }

  async getAll() {
    const [rows] = await db.execute('SELECT * FROM avatars');
    return rows;
  }
  async updateAvatar(userId, avatarId) {
    const [result] = await db.execute(
      'UPDATE users SET avatar_id = ? WHERE id = ?',
      [avatarId, userId]
    );
    return result;
  }
}

module.exports = new AvatarEntity();
