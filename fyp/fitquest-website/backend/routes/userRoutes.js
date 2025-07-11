const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

router.get('/admin/stats', userController.getDashboardStats);
router.get('/admin/users', userController.getAllUsers);

module.exports = router;
