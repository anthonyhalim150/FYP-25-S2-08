const express = require('express');
const router = express.Router();
const { saveWorkoutPlan, getWorkoutPlansByUser, getLatestWorkoutPlan } = require('../controllers/workoutPlanController');

router.post('/save', saveWorkoutPlan);
router.get('/my-plans', getWorkoutPlansByUser);
router.get('/latest', getLatestWorkoutPlan);

module.exports = router;
