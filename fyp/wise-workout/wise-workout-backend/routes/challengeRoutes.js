const express = require('express');
const router = express.Router();
const challengeController = require('../controllers/challengeController');

router.post('/send', challengeController.sendChallenge);
router.get('/accepted', challengeController.getAcceptedChallenges);
router.get('/received' , challengeController.getReceivedChallenges);
router.post('/respond', challengeController.respondChallenge);

module.exports = router;
