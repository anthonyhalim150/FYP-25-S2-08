const db = require('../config/db');

class AvatarEntity {
  async findById(avatarId) {
    const [rows] = await db.execute(
      'SELECT * FROM avatars WHERE id = ?',
      [avatarId]
    );
    return rows[0] || null;
  }

  async getAllAvatars() {
    const [rows] = await db.execute('SELECT * FROM avatars');
    return rows;
  }
}

module.exports = new AvatarEntity();
