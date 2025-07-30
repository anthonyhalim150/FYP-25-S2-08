const db = require('../config/db');

async function getAllTournaments() {
  const [rows] = await db.query('SELECT * FROM tournaments ORDER BY startDate ASC');
  return rows;
}

async function getTournamentNamesAndEndDates() {
  const [rows] = await db.query('SELECT id, title, endDate FROM tournaments ORDER BY startDate ASC');
  return rows;
}

module.exports = {
  getAllTournaments,
  getTournamentNamesAndEndDates
};