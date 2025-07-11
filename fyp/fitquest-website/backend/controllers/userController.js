const UserService = require('../services/userService');

exports.getDashboardStats = async (req, res) => {
  try {
    const stats = await UserService.getDashboardStats();
    res.status(200).json(stats);
  } catch (err) {
    res.status(500).json({ message: 'Failed to fetch stats' });
  }
};
exports.getAllUsers = async (req, res) => {
  try {
    const users = await UserService.getAllUsers();
    res.status(200).json(users);
  } catch (err) {
    res.status(500).json({ message: 'Failed to fetch users' });
  }
};
