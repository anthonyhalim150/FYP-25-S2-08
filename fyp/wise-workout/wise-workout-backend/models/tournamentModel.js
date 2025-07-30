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
    'SELECT user_id AS userId, progress FROM tournament_participants WHERE tournament_id = ?',
    [tournamentId]
  );
  return rows; // [{ userId, progress }, ...]
}

module.exports = {
  getAllTournaments,
  getTournamentNamesAndEndDates,
  getTournamentsWithParticipantCounts,
  getTournamentParticipants,
};