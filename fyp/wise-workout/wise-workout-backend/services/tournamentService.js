const Tournament = require('../models/tournamentModel');

async function fetchAllTournaments() {
  return await Tournament.getAllTournaments();
}

module.exports = {
  fetchAllTournaments
};