const express = require('express');
const router = express.Router();
const authenticateUser = require('../middlewares/authMiddleware');
const feedbackController = require('../controllers/feedbackController');

router.get('/admin/feedbacks', authenticateUser, feedbackController.getAllFeedbacks);
router.post('/admin/feedbacks/:id/status', authenticateUser, feedbackController.setFeedbackStatus);

module.exports = router;
