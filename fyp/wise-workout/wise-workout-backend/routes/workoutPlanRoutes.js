const express = require('express');
const router = express.Router();
const { saveWorkoutPlan, getWorkoutPlansByUser } = require('../controllers/workoutPlanController');

router.post('/save', saveWorkoutPlan);
router.get('/my-plans', getWorkoutPlansByUser);

module.exports = router;
