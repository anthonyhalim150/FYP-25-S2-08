const userPreferencesEntity = require('../entities/userPreferencesEntity');
const UserEntity = require('../entities/userEntity');

const submitUserPreferences = async (req, res) => {
  try {
    const userId = req.user?.id;
    if (!userId) return res.status(401).json({ message: 'Unauthorized' });

    const {
      workout_frequency,
      fitness_goal,
      workout_time,
      fitness_level,
      injury,
      dob
    } = req.body;

    if (
      !workout_frequency ||
      !fitness_goal ||
      !workout_time ||
      !fitness_level ||
      !injury ||
      !dob
    ) {
      return res.status(400).json({ message: 'Missing required fields' });
    }

    await UserEntity.updateDOB(userId, dob);

    const preferences = {
      workout_frequency,
      fitness_goal,
      workout_time,
      fitness_level,
      injury
    };

    await userPreferencesEntity.savePreferences(userId, preferences);
    res.status(200).json({ message: 'Preferences submitted successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};
const checkPreferences = async (req, res) => {
  try {
    const userId = req.user?.id;
    if (!userId) return res.status(401).json({ message: 'Unauthorized' });

    const hasPreferences = await userPreferencesEntity.hasPreferences(userId);
    res.status(200).json({ hasPreferences });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};
module.exports = { submitUserPreferences, checkPreferences };
