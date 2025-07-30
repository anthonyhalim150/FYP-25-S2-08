const tournamentService = require('../services/tournamentService');

async function getAllTournaments(req, res) {
  try {
    const tournaments = await tournamentService.fetchAllTournaments();
    tournaments.forEach(t =>
      t.features = t.features ? JSON.parse(t.features) : []
    );
    res.status(200).json(tournaments);
  } catch (err) {
    console.error('Error fetching tournaments:', err);
    res.status(500).json({message: 'Failed to retrieve tournaments.'});
  }
}

module.exports = {
  getAllTournaments
};