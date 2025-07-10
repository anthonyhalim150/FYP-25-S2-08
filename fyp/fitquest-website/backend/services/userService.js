const UserModel = require('../models/userModel');

class UserService {
  static async getDashboardStats() {
    const [total, active, premium] = await Promise.all([
      UserModel.getTotalUserCount(),
      UserModel.getActiveUserCount(),
      UserModel.getPremiumUserCount()
    ]);
    return { total, active, premium };
  }
}

module.exports = UserService;
