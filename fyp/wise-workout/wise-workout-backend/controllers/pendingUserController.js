const UserEntity = new (require('../entities/userEntity'))();
const PendingUserEntity = require('../entities/pendingUserEntity');
const { isValidEmail } = require('../utils/sanitize');
const { setCookie } = require('../utils/cookieAuth');

exports.verifyOtpRegister = async (req, res) => {
  const email = isValidEmail(req.body.email);
  const code = req.body.code?.trim();

  if (!email || !code) {
    return res.status(400).json({ message: 'Invalid email or code' });
  }

  const pendingUser = await PendingUserEntity.verifyOTP(email, code);
  if (!pendingUser) {
    return res.status(400).json({ message: 'Invalid or expired OTP' });
  }

  const existingUser = await UserEntity.findByEmail(email);
  if (existingUser) {
    await PendingUserEntity.deleteByEmail(email);
    return res.status(409).json({ message: 'User already exists' });
  }

  await UserEntity.create(email, pendingUser.username, pendingUser.password, 'database');
  await PendingUserEntity.deleteByEmail(email);

  setCookie(res, email);
  res.status(201).json({ message: 'Registration and verification successful' });
};
