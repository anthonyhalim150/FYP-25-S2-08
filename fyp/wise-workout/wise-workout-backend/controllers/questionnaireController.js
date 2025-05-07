const userPreferencesEntity = require('../entities/userPreferencesEntity');

const submitUserPreferences = async (req, res) => {
  try {
    const userId = req.user?.id;
    if (!userId) return res.status(401).json({ message: 'Unauthorized' });

    const {
      workout_frequency,
      fitness_goal,
      workout_time,
      fitness_level,
      injury
    } = req.body;

    if (
      !workout_frequency ||
      !fitness_goal ||
      !workout_time ||
      !fitness_level ||
      !injury
    ) {
      return res.status(400).json({ message: 'Missing required fields' });
    }

    const preferences = {
      workout_frequency,
      fitness_goal,
      preferred_time: workout_time,
      fitness_level,
      injury
    };

    await userPreferencesEntity.savePreferences(userId, preferences);
    res.status(200).json({ message: 'Preferences submitted successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

module.exports = { submitUserPreferences };
