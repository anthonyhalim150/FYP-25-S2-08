const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

router.post('/login', userController.login);
router.get('/admin/stats', userController.getDashboardStats);

module.exports = router;
