const UserModel = require('../models/userModel');
const PendingUserModel = require('../models/pendingUserModel');

class PendingUserService {
  static async verifyOtpAndRegister(email, code) {
    const pendingUser = await PendingUserModel.verifyOTP(email, code);
    if (!pendingUser) throw new Error('INVALID_OTP');

    const existingUser = await UserModel.findByEmail(email);
    if (existingUser) {
      await PendingUserModel.deleteByEmail(email);
      throw new Error('USER_EXISTS');
    }

    await UserModel.create(
      email,
      pendingUser.username,
      pendingUser.password,
      'database',
      pendingUser.firstName,
      pendingUser.lastName,
      true
    );

    await PendingUserModel.deleteByEmail(email);
  }
}

module.exports = PendingUserService;
