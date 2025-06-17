const bcrypt = require('bcryptjs');
const { generateOTP, getExpiry } = require('../utils/otp');
const { sendResetOTPToEmail } = require('../utils/otpService');
const PasswordResetModel = require('../models/passwordResetModel');
const UserModel = require('../models/userModel');

class PasswordResetService {
  static async requestReset(email) {
    const user = await UserModel.findByEmail(email);
    if (!user) throw new Error('EMAIL_NOT_FOUND');

    const otp = generateOTP();
    const expiresAt = getExpiry();

    await PasswordResetModel.deleteByEmail(email);
    await PasswordResetModel.create(email, otp, expiresAt);
    await sendResetOTPToEmail(email, otp);
  }

  static async verifyReset(email, otp, newPassword) {
    const record = await PasswordResetModel.findValidToken(email, otp);
    if (!record) throw new Error('INVALID_OR_EXPIRED_OTP');

    const hashed = await bcrypt.hash(newPassword, 10);
    await UserModel.updatePasswordByEmail(email, hashed);
    await PasswordResetModel.deleteByEmail(email);
  }
}

module.exports = PasswordResetService;
