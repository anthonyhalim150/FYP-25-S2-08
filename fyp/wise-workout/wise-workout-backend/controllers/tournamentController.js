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

async function getAllTournamentNamesAndEndDates(req, res) {
  try {
    const tournaments = await tournamentService.getTournamentNamesAndEndDates();
    res.status(200).json(tournaments);
  } catch (err) {
    console.error('Error fetching tournament names/end dates:', err);
    res.status(500).json({ message: 'Failed to fetch tournament names and end dates.' });
  }
}

// Get all tournaments with participant counts
async function getTournamentsWithParticipantCounts(req, res) {
  try {
    const tournaments = await tournamentService.getTournamentsWithParticipantCounts();
    res.status(200).json(tournaments);
  } catch (err) {
    console.error('Error fetching tournaments with participants:', err);
    res.status(500).json({message: 'Failed to retrieve tournaments.'});
  }
}

// Get all participants (with progress) for a single tournament
async function getTournamentParticipants(req, res) {
  try {
    const tournamentId = req.params.tournamentId;
    const participants = await tournamentService.getTournamentParticipants(tournamentId);
    res.status(200).json(participants);
  } catch (err) {
    console.error('Error fetching participants for tournament:', err);
    res.status(500).json({message: 'Failed to get participants'});
  }
}

module.exports = {
  getAllTournaments,
  getAllTournamentNamesAndEndDates,
  getTournamentsWithParticipantCounts,
  getTournamentParticipants,
};