const express = require('express');
const router = express.Router();
const { sendMessage, getConversation } = require('../controllers/messageController');

router.post('/send', sendMessage);
router.get('/conversation/:userId', getConversation);

module.exports = router;
