const UserEntity = new (require('../entities/userEntity'))();
const { setCookie } = require('../utils/cookieAuth');

exports.login = async (req, res) => {
  const { email, password } = req.body;
  const user = await UserEntity.verifyLogin(email, password);

  if (!user) return res.status(401).json({ message: 'Invalid credentials' });

  setCookie(res, email);
  res.json({ message: 'Login successful' });
};

exports.loginGoogle = async (req, res) => {
  const { email } = req.body;
  let user = await UserEntity.findByEmail(email);

  if (!user) {
    await UserEntity.create(email, null, 'google');
  }

  setCookie(res, email);
  res.json({ message: 'Google login successful' });
};

exports.loginApple = async (req, res) => {
  const { email } = req.body;
  let user = await UserEntity.findByEmail(email);

  if (!user) {
    await UserEntity.create(email, null, 'apple');
  }

  setCookie(res, email);
  res.json({ message: 'Apple login successful' });
};
