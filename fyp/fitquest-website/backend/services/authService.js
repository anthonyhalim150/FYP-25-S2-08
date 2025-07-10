const UserModel = require('../models/userModel');
const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'fitquest-secret-key';

class AuthService {
  static async login(email, password) {
    const user = await UserModel.verifyLogin(email, password);
    if (!user) return { user: null, token: null };
    const token = jwt.sign(
      {
        id: user.id,
        email: user.email,
      },
      JWT_SECRET,
      { expiresIn: '1h' }
    );
    return { user, token };
  }

}

module.exports = AuthService;
