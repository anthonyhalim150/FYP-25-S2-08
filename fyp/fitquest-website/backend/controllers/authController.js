const AuthService = require('../services/authService');

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const { user, token } = await AuthService.login(email, password);

    if (!user) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    res.cookie('session', token, {
      httpOnly: true,
      sameSite: 'lax',
      secure: false,
      maxAge: 3 * 24 * 60 * 60 * 1000
    });

    res.status(200).json({
      message: 'Login Successful',
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email
      }
    });
  } catch (err) {
    res.status(500).json({ message: "Something went wrong." });
  }
};
