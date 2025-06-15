const express = require('express');
const router = express.Router();
const db = require('../config/db');

router.get('/users', async (req, res) => {
  try {
    const [users] = await db.execute('SELECT * FROM users');
    const [preferences] = await db.execute('SELECT * FROM user_preferences');

    const result = users.map(user => {
      const pref = preferences.find(p => p.user_id === user.id);
      return {
        ...user,
        preferences: pref || null
      };
    });

    res.json(result);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Failed to load users' });
  }
});

module.exports = router;
