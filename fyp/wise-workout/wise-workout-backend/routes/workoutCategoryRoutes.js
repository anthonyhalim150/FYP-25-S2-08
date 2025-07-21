const express = require('express');
const router = express.Router();
const workoutCategoryController = require('../controllers/workoutCategoryController');

router.get('/', workoutCategoryController.getAllCategories);
router.get('/:id', workoutCategoryController.getCategoryById);

module.exports = router;
