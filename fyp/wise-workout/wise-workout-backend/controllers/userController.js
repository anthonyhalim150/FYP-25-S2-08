const UserEntity = require('../entities/userEntity');
const { setCookie } = require('../utils/cookieAuth');
const { isValidEmail, isValidPassword, sanitizeInput } = require('../utils/sanitize');
const {generateOTP, getExpiry} = require('../utils/otp');
const { sendOTPToEmail } = require('../services/otpService');
const PendingUserEntity = require('../entities/pendingUserEntity');
const AvatarEntity = require('../entities/avatarEntity');

exports.login = async (req, res) => {
  const email = isValidEmail(req.body.email);
  const password = isValidPassword(req.body.password);

  if (!email || !password) {
    return res.status(400).json({ message: 'Invalid email or password format' });
  }

  const user = await UserEntity.verifyLogin(email, password);
  if (!user) return res.status(401).json({ message: 'Invalid credentials' });

  await setCookie(res, email);
  res.json({ message: 'Login successful' });
};

exports.loginGoogle = async (req, res) => {
  const email = isValidEmail(req.body.email);
  if (!email) return res.status(400).json({ message: 'Invalid email' });

  let user = await UserEntity.findByEmail(email);
  if (!user) {
    await UserEntity.create(email, null, 'google');
  }

  await setCookie(res, email);
  res.json({ message: 'Google login successful' });
};

exports.loginApple = async (req, res) => {
  const email = isValidEmail(req.body.email);
  if (!email) return res.status(400).json({ message: 'Invalid email' });

  let user = await UserEntity.findByEmail(email);
  if (!user) {
    await UserEntity.create(email, null, 'apple');
  }

  await setCookie(res, email);
  res.json({ message: 'Apple login successful' });
};

exports.loginFacebook = async (req, res) => {
  const email = isValidEmail(req.body.email);
  if (!email) return res.status(400).json({ message: 'Invalid email' });

  let user = await UserEntity.findByEmail(email);
  if (!user) {
    await UserEntity.create(email, null, 'facebook');
  }

  await setCookie(res, email);
  res.json({ message: 'Facebook login successful' });
};

exports.register = async (req, res) => {
  const { email, username, password } = req.body;

  const cleanEmail = isValidEmail(email);
  const cleanPassword = isValidPassword(password);
  const cleanUsername = sanitizeInput(username);

  if (!cleanEmail || !cleanPassword || !cleanUsername) {
    return res.status(400).json({ message: 'Invalid email, username, or password format' });
  }

  const existingUser = await UserEntity.findByEmail(cleanEmail);
  if (existingUser) {
    return res.status(409).json({ message: 'User with this email already exists' });
  }

  const existingUsername = await UserEntity.findByUsername(cleanUsername);
  if (existingUsername) {
    return res.status(409).json({ message: 'Username is already taken' });
  }

  const otp = generateOTP();
  const expiresAt = getExpiry();

  await PendingUserEntity.create(cleanEmail, cleanUsername, cleanPassword, otp, expiresAt);
  await sendOTPToEmail(cleanEmail, otp);

  res.status(201).json({ message: 'OTP sent to email. Complete verification to finish registration.' });
};


exports.setAvatar = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { avatarId } = req.body;

    if (!userId || !avatarId) {
      return res.status(400).json({ message: 'Missing userId or avatarId' });
    }

    const avatar = await AvatarEntity.findById(avatarId);
    if (!avatar) {
      return res.status(400).json({ message: 'Avatar does not exist' });
    }

    await UserEntity.updateAvatar(userId, avatarId);
    res.status(200).json({ message: 'Avatar updated successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.getCurrentAvatar = async (req, res) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: 'Unauthorized' });
    }

    const avatarId = await UserEntity.hasAvatar(userId);
    if (!avatarId) {
      return res.status(404).json({ message: 'No avatar set for this user' });
    }

    const avatar = await AvatarEntity.findById(avatarId);
    if (!avatar) {
      return res.status(404).json({ message: 'Avatar data not found' });
    }

    res.status(200).json({ avatar });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};
