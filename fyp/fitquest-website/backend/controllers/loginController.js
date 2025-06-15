const jwt = require('jsonwebtoken');
const UserEntity = require('../entities/userEntity');

const JWT_SECRET = 'fitquest-secret-key';

class LoginController {
  async login(req, res) {
    try {
      const { email, password } = req.body;
      const userEntity = new UserEntity();

      const user = await userEntity.verifyLogin(email, password);
      console.log("Login attempt:", email);
      console.log("User found:", user);

      if (!user) {
        return res.status(401).json({ message: 'Invalid email or password' });
      }

      const token = jwt.sign(
        {
          id: user.id,
          email: user.email,
        },
        JWT_SECRET,
        { expiresIn: '1h' }
      );

      res.status(200).json({
        message: 'Login Successful',
        token,
        user: {
          id: user.id,
          username: user.username,
          email: user.email,
        }
      });

    } catch (err) {
      console.error("Login error:", err);
      res.status(500).json({ message: "Something went wrong." });
    }
  }
}

module.exports = new LoginController();