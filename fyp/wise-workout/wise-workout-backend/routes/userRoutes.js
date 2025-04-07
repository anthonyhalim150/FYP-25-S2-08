const express = require('express');
const router = express.Router();
const {login, loginGoogle, loginApple} = require('../controllers/userController');

router.post('/login', login);
router.post('/google', loginGoogle);
router.post('/apple', loginApple);


module.exports = router;
