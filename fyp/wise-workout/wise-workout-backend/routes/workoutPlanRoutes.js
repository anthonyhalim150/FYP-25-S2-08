const express = require('express');
const router = express.Router();
const { saveWorkoutPlan, getWorkoutPlansByUser } = require('../controllers/workoutPlanController');

router.post('/save', saveWorkoutPlan);             // POST /workout-plans/save
router.get('/my-plans', getWorkoutPlansByUser);    // GET  /workout-plans/my-plans

module.exports = router;
