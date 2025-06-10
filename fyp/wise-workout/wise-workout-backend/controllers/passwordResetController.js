const bcrypt = require('bcryptjs');
const { generateOTP, getExpiry } = require('../utils/otp');
const { sendResetOTPToEmail } = require('../services/otpService');
const PasswordResetEntity = require('../entities/passwordResetEntity');
const UserEntity = require('../entities/userEntity');

exports.requestPasswordReset = async (req, res) => {
  const email = req.body.email?.trim();

  if (!email) {
    return res.status(400).json({ message: 'Email is required' });
  }

  const user = await UserEntity.findByEmail(email);
  if (!user) {
    return res.status(404).json({ message: 'Email not found' });
  }

  const otp = generateOTP();
  const expiresAt = getExpiry();

  await PasswordResetEntity.deleteByEmail(email);
  await PasswordResetEntity.create(email, otp, expiresAt);
  await sendResetOTPToEmail(email, otp);

  res.json({ message: 'OTP sent to your email' });
};

exports.verifyPasswordReset = async (req, res) => {
  const email = req.body.email?.trim();
  const otp = req.body.otp?.trim();
  const newPassword = req.body.newPassword?.trim();

  if (!email || !otp || !newPassword) {
    return res.status(400).json({ message: 'Missing email, OTP, or password' });
  }

  const record = await PasswordResetEntity.findValidToken(email, otp);
  if (!record) {
    return res.status(400).json({ message: 'Invalid or expired OTP' });
  }

  const hashed = await bcrypt.hash(newPassword, 10);
  await UserEntity.updatePasswordByEmail(email, hashed);
  await PasswordResetEntity.deleteByEmail(email);

  res.json({ message: 'Password updated successfully' });
};
