const express = require('express');
const router = express.Router();
const tournamentController = require('../controllers/tournamentController');

router.get('/all', tournamentController.getAllTournaments);

router.get('/name-enddate', tournamentController.getAllTournamentNamesAndEndDates);

module.exports = router;