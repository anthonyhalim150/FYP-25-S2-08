const express = require('express');
const router = express.Router();
const {
  login,
  loginGoogle,
  loginApple,
  loginFacebook,
  register,
  setAvatar,
  getCurrentAvatar
} = require('../controllers/userController');

router.post('/login', login);
router.post('/google', loginGoogle);
router.post('/apple', loginApple);
router.post('/facebook', loginFacebook);
router.post('/register', register);
router.post('/set-avatar', setAvatar);
router.get('/current-avatar', getCurrentAvatar);


module.exports = router;
