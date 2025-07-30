const express = require('express');
const router = express.Router();
const feedbackController = require('../controllers/feedbackController');

router.post('/submit', feedbackController.submitFeedback);
router.get('/published', feedbackController.getPublishedFeedback);
router.get('/all', feedbackController.getAllFeedback); // admin only
router.post('/update-status', feedbackController.updateFeedbackStatus); // admin only

module.exports = router;
