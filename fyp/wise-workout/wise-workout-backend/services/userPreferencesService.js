const UserModel = require('../models/userModel');
const UserPreferencesModel = require('../models/userPreferencesModel');

class UserPreferencesService {
  static async submit(userId, preferences, dob) {
    await UserModel.updateDOB(userId, dob);
    return await UserPreferencesModel.savePreferences(userId, preferences);
  }

  static async check(userId) {
    return await UserPreferencesModel.hasPreferences(userId);
  }

    static async update(userId, preferences) {
      return await UserPreferencesModel.updatePreferences(userId, preferences);
    }
}

module.exports = UserPreferencesService;
