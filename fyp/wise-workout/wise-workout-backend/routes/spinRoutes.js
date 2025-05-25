const express = require('express');
const router = express.Router();
const { spin } = require('../controllers/spinController');

router.get('/spin', spin);

module.exports = router;
