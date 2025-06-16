const UserEntity = require('../entities/userEntity');
const { setCookie } = require('../utils/cookieAuth');
const { isValidEmail, isValidPassword, sanitizeInput } = require('../utils/sanitize');
const { generateOTP, getExpiry } = require('../utils/otp');
const { sendOTPToEmail } = require('../services/otpService');
const PendingUserEntity = require('../entities/pendingUserEntity');

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
  const firstName = sanitizeInput(req.body.firstName || '');
  const lastName = sanitizeInput(req.body.lastName || '');

  if (!email) return res.status(400).json({ message: 'Invalid email' });

  let user = await UserEntity.findByEmail(email);
  if (!user) {
    await UserEntity.create(email, null, null, 'google', firstName, lastName); 
  }

  await setCookie(res, email);
  res.json({ message: 'Google login successful' });
};

exports.loginApple = async (req, res) => {
  const email = isValidEmail(req.body.email);
  const firstName = sanitizeInput(req.body.firstName || '');
  const lastName = sanitizeInput(req.body.lastName || '');

  if (!email) return res.status(400).json({ message: 'Invalid email' });

  let user = await UserEntity.findByEmail(email);
  if (!user) {
    await UserEntity.create(email, null, null, 'apple', firstName, lastName); 
  }

  await setCookie(res, email);
  res.json({ message: 'Apple login successful' });
};

exports.loginFacebook = async (req, res) => {
  const email = isValidEmail(req.body.email);
  const firstName = sanitizeInput(req.body.firstName || '');
  const lastName = sanitizeInput(req.body.lastName || '');

  if (!email) return res.status(400).json({ message: 'Invalid email' });

  let user = await UserEntity.findByEmail(email);
  if (!user) {
    await UserEntity.create(email, null, null, 'facebook', firstName, lastName); 
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
