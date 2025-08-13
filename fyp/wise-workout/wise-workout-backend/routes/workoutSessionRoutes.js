const express = require('express');
const router = express.Router();
const workoutSessionController = require('../controllers/workoutSessionController');

router.post('/sessions', workoutSessionController.saveWorkoutSession);

router.get('/sessions', workoutSessionController.getUserWorkoutSessions);

router.get('/sessions/today/summary', workoutSessionController.getTodayCaloriesSummary);

router.get('/sessions/summary', workoutSessionController.getDailyCaloriesSummaryRange);
module.exports = router;