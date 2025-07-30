const Tournament = require('../models/tournamentModel');

async function fetchAllTournaments() {
  return await Tournament.getAllTournaments();
}

async function getTournamentNamesAndEndDates() {
  return await Tournament.getTournamentNamesAndEndDates();
}

module.exports = {
  fetchAllTournaments,
  getTournamentNamesAndEndDates
};