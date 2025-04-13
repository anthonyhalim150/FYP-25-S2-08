const UserEntity = new (require('../entities/userEntity'))();
const { setCookie } = require('../utils/cookieAuth');
const { isValidEmail, isValidPassword, sanitizeInput } = require('../utils/sanitize');

exports.login = async (req, res) => {
  const email = isValidEmail(req.body.email);
  const password = isValidPassword(req.body.password);

  if (!email || !password) {
    return res.status(400).json({ message: 'Invalid email or password format' });
  }

  const user = await UserEntity.verifyLogin(email, password);
  if (!user) return res.status(401).json({ message: 'Invalid credentials' });

  setCookie(res, email);
  res.json({ message: 'Login successful' });
};

exports.loginGoogle = async (req, res) => {
  const email = isValidEmail(req.body.email);
  if (!email) return res.status(400).json({ message: 'Invalid email' });

  let user = await UserEntity.findByEmail(email);
  if (!user) {
    await UserEntity.create(email, null, 'google');
  }

  setCookie(res, email);
  res.json({ message: 'Google login successful' });
};

exports.loginApple = async (req, res) => {
  const email = isValidEmail(req.body.email);
  if (!email) return res.status(400).json({ message: 'Invalid email' });

  let user = await UserEntity.findByEmail(email);
  if (!user) {
    await UserEntity.create(email, null, 'apple');
  }

  setCookie(res, email);
  res.json({ message: 'Apple login successful' });
};

exports.loginFacebook = async (req, res) => {
  const email = isValidEmail(req.body.email);
  if (!email) return res.status(400).json({ message: 'Invalid email' });

  let user = await UserEntity.findByEmail(email);
  if (!user) {
    await UserEntity.create(email, null, 'facebook');
  }

  setCookie(res, email);
  res.json({ message: 'Facebook login successful' });
};
