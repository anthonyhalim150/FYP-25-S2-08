const express = require('express');
const router = express.Router();
const {
  setAvatar,
  setBackground,
  getCurrentAvatar,
  getCurrentBackground, 
  getCurrentProfile,
  updateProfile
} = require('../controllers/userController');

router.post('/set-avatar', setAvatar);
router.post('/set-background', setBackground);
router.get('/current-avatar', getCurrentAvatar);
router.get('/current-background', getCurrentBackground); 
router.get('/current-profile', getCurrentProfile);
router.post('/update-profile', updateProfile);

module.exports = router;
