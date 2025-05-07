const express = require('express');
const router = express.Router();
const questionnaireController = require('../controllers/questionnaireController');

router.post('/submit', questionnaireController.submitUserPreferences);

module.exports = router;
