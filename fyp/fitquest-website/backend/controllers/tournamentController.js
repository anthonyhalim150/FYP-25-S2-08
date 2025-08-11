const TournamentService = require('../services/tournamentService');

exports.createTournament = async (req, res) => {
  try {
    const { title, description, startDate, endDate, features, target_exercise_pattern } = req.body;
    if (!title || !description || !startDate || !endDate || !target_exercise_pattern) {
      return res.status(400).json({ message: 'Missing required fields' });
    }

    const tournament = await TournamentService.createTournament({
      title,
      description,
      startDate,
      endDate,
      features: JSON.stringify(features || []),
      target_exercise_pattern
    });

    res.status(201).json(tournament);
  } catch (err) {
    res.status(500).json({ message: 'Failed to create tournament', error: err.message });
  }
};

exports.getAllTournaments = async (req, res) => {
  try {
    const tournaments = await TournamentService.fetchAllTournaments();
    res.status(200).json(tournaments);
  } catch (err) {
    res.status(500).json({ message: 'Failed to fetch tournaments', error: err.message });
  }
};

exports.updateTournament = async (req, res) => {
  try {
    const id = req.params.id;
    const { title, description, startDate, endDate, features, target_exercise_pattern } = req.body;
    await TournamentService.editTournament(id, {
      title,
      description,
      startDate,
      endDate,
      features: JSON.stringify(features || []),
      target_exercise_pattern
    });
    res.status(200).json({ message: 'Tournament updated successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Failed to update tournament', error: err.message });
  }
};
