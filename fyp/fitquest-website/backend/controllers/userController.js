const UserService = require('../services/userService');

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const { user, token } = await UserService.login(email, password);

    if (!user) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

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

exports.getDashboardStats = async (req, res) => {
  try {
    const stats = await UserService.getDashboardStats();
    res.status(200).json(stats);
  } catch (err) {
    res.status(500).json({ message: 'Failed to fetch stats' });
  }
};
