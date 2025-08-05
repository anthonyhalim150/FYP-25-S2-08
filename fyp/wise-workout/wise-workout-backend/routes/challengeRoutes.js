// routes/challengeRoutes.js
const express = require('express');
const router = express.Router();
const ChallengeController = require('../controllers/challengeController');

router.get('/invitations', ChallengeController.getInvitations);
router.get('/accepted', ChallengeController.getAcceptedChallenges);
router.post('/:id/accept', ChallengeController.acceptChallenge);
router.post('/:id/reject', ChallengeController.rejectChallenge);
router.post('/send', ChallengeController.sendChallenge);

module.exports = router;
