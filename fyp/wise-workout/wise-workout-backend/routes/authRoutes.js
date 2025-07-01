const express = require('express');
const router = express.Router();
const {
  login,
  loginGoogle,
  loginApple,
  loginFacebook,
  register
} = require('../controllers/authController');

const {
  requestPasswordReset,
  verifyPasswordReset
} = require('../controllers/passwordResetController');

router.post('/login', login);
router.post('/google', loginGoogle);
router.post('/apple', loginApple);
router.post('/facebook', loginFacebook);
router.post('/register', register);
router.post('/forgot-password', requestPasswordReset);
router.post('/verify-password-reset', verifyPasswordReset);

module.exports = router;
