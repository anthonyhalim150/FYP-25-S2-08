const db = require('../config/db');

class TournamentModel {
  static async insertTournament({ title, description, startDate, endDate, features, target_exercise_pattern }) {
    const [result] = await db.execute(
      `INSERT INTO tournaments (title, description, startDate, endDate, features, target_exercise_pattern)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [title, description, startDate, endDate, features, target_exercise_pattern]
    );
    return { id: result.insertId, title, description, startDate, endDate, features, target_exercise_pattern };
  }

  static async getAllTournaments() {
    const [rows] = await db.execute(
      `SELECT id, title, description, startDate, endDate, features, target_exercise_pattern, rewarded
       FROM tournaments
       ORDER BY created_at DESC`
    );
    return rows;
  }

  static async updateTournament(id, { title, description, startDate, endDate, features, target_exercise_pattern }) {
    await db.execute(
      `UPDATE tournaments
       SET title = ?, description = ?, startDate = ?, endDate = ?, features = ?, target_exercise_pattern = ?
       WHERE id = ?`,
      [title, description, startDate, endDate, features, target_exercise_pattern, id]
    );
    return { message: 'Tournament updated successfully' };
  }
}

module.exports = TournamentModel;
