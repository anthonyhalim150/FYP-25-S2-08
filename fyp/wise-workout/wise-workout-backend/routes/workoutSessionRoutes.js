const express = require('express');
const router = express.Router();
const workoutSessionController = require('../controllers/workoutSessionController');

// Save a workout session
router.post('/sessions', workoutSessionController.saveWorkoutSession);

// Get user's workout sessions
router.get('/sessions', workoutSessionController.getUserWorkoutSessions);

module.exports = router;