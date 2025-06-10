const express = require('express');
const router = express.Router();
const {
  login,
  loginGoogle,
  loginApple,
  loginFacebook,
  register
} = require('../controllers/authController');

router.post('/login', login);
router.post('/google', loginGoogle);
router.post('/apple', loginApple);
router.post('/facebook', loginFacebook);
router.post('/register', register);

module.exports = router;
