const db = require('../config/db');

async function getAllTournaments() {
  const [rows] = await db.query('SELECT * FROM tournaments ORDER BY startDate ASC');
  return rows;
}

async function getTournamentNamesAndEndDates() {
  const [rows] = await db.query('SELECT id, title, endDate FROM tournaments ORDER BY startDate ASC');
  return rows;
}

// Get ALL tournaments with participant counts
async function getTournamentsWithParticipantCounts() {
  const [rows] = await db.query(
    `SELECT t.id, t.title, t.endDate, COUNT(tp.id) AS participants
     FROM tournaments t
     LEFT JOIN tournament_participants tp ON t.id = tp.tournament_id
     GROUP BY t.id, t.title, t.endDate
     ORDER BY t.startDate ASC`
  );
  return rows; // [{ id, title, endDate, participants }, ...]
}

// Get participants and progress for a tournament
async function getTournamentParticipants(tournamentId) {
  const [rows] = await db.query(
    `
    SELECT
      tp.user_id AS userId,
      u.username AS username,
      tp.progress
    FROM tournament_participants tp
    JOIN users u ON tp.user_id = u.id
    WHERE tp.tournament_id = ?
    ORDER BY tp.progress DESC, tp.joined_at ASC
    `,
    [tournamentId]
  );
  return rows; // [{ userId, username, progress }, ...]
}

// Insert a user into tournament_participants
async function joinTournament(tournamentId, userId) {
  // Check if already joined (avoid duplicate records)
  const [existing] = await db.query(
    'SELECT id FROM tournament_participants WHERE tournament_id = ? AND user_id = ?',
    [tournamentId, userId]
  );
  if (existing.length > 0) return { status: 'already_joined' };

  // Insert new participant
  await db.query(
    'INSERT INTO tournament_participants (tournament_id, user_id, progress) VALUES (?, ?, 0)',
    [tournamentId, userId]
  );
  return { status: 'joined' };
}

module.exports = {
  getAllTournaments,
  getTournamentNamesAndEndDates,
  getTournamentsWithParticipantCounts,
  getTournamentParticipants,
  joinTournament,
};