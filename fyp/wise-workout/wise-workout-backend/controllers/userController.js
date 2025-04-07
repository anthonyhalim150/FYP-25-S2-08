const UserEntity = require('../entities/userEntity');
const { setCookie } = require('../utils/cookieAuth');

// 1. Email + Password login
exports.login = async (req, res) => {
  const { email, password } = req.body;
  const user = await UserEntity.verifyLogin(email, password);

  if (!user) return res.status(401).json({ message: 'Invalid credentials' });

  setCookie(res, email);
  res.json({ message: 'Login successful' });
};

// 2. Google Sign-In
exports.loginGoogle = async (req, res) => {
  const { email } = req.body;
  let user = await UserEntity.findByEmail(email);

  if (!user) {
    await UserEntity.create(email, 'google');
  }

  setCookie(res, email);
  res.json({ message: 'Google login successful' });
};

// 3. Apple Sign-In
exports.loginApple = async (req, res) => {
  const { email } = req.body;
  let user = await UserEntity.findByEmail(email);

  if (!user) {
    await UserEntity.create(email, 'apple');
  }

  setCookie(res, email);
  res.json({ message: 'Apple login successful' });
};
