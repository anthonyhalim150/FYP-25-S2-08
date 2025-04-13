const express = require('express');
const router = express.Router();
const {login, loginGoogle, loginApple, loginFacebook} = require('../controllers/userController');

router.post('/login', login);
router.post('/google', loginGoogle);
router.post('/apple', loginApple);
router.post('/facebook', loginFacebook);


module.exports = router;
