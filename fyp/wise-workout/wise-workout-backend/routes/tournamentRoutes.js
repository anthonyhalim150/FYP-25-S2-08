const express = require('express');
const router = express.Router();
const tournamentController = require('../controllers/tournamentController');

router.get('/all', tournamentController.getAllTournaments);

module.exports = router;