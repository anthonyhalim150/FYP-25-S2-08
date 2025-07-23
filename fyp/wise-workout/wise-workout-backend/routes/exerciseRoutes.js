const express = require('express');
const router = express.Router();
const exerciseController = require('../controllers/exerciseController');

// GET all exercises for a workout
router.get('/workout/:workoutId', exerciseController.getExercisesByWorkout);

module.exports = router;
