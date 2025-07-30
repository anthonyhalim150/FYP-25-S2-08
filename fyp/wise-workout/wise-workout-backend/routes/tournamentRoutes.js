const express = require('express');
const router = express.Router();
const tournamentController = require('../controllers/tournamentController');

router.get('/all', tournamentController.getAllTournaments);
router.get('/name-enddate', tournamentController.getAllTournamentNamesAndEndDates);
router.get('/with-participants', tournamentController.getTournamentsWithParticipantCounts);
router.get('/:tournamentId/participants', tournamentController.getTournamentParticipants);
router.post('/:tournamentId/join', tournamentController.joinTournament);

module.exports = router;