const express = require('express');
const router = express.Router();
const {
  setAvatar,
  getCurrentAvatar,
  getCurrentProfile
} = require('../controllers/userController');

router.post('/set-avatar', setAvatar);
router.get('/current-avatar', getCurrentAvatar);
router.get('/current-profile', getCurrentProfile);

module.exports = router;
