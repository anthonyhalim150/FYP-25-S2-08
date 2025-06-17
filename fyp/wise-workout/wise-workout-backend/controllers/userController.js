const UserService = require('../services/userService');

exports.setAvatar = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { avatarId } = req.body;

    await UserService.setAvatar(userId, avatarId);
    res.status(200).json({ message: 'Avatar updated successfully' });
  } catch (err) {
    const map = {
      MISSING_DATA: 400,
      AVATAR_NOT_FOUND: 400,
      PREMIUM_REQUIRED: 403
    };
    res.status(map[err.message] || 500).json({ message: err.message });
  }
};

exports.setBackground = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { backgroundId } = req.body;

    await UserService.setBackground(userId, backgroundId);
    res.status(200).json({ message: 'Background updated successfully' });
  } catch (err) {
    const map = {
      MISSING_DATA: 400,
      BACKGROUND_NOT_FOUND: 400,
      PREMIUM_REQUIRED: 403
    };
    res.status(map[err.message] || 500).json({ message: err.message });
  }
};

exports.getCurrentAvatar = async (req, res) => {
  try {
    const userId = req.user?.id;
    const avatar = await UserService.getCurrentAvatar(userId);
    res.status(200).json({ avatar });
  } catch (err) {
    const map = {
      NO_AVATAR: 404,
      AVATAR_DATA_MISSING: 404
    };
    res.status(map[err.message] || 500).json({ message: err.message });
  }
};

exports.getCurrentBackground = async (req, res) => {
  try {
    const userId = req.user?.id;
    const background = await UserService.getCurrentBackground(userId);
    res.status(200).json({ background });
  } catch (err) {
    const map = {
      NO_BACKGROUND: 404,
      BACKGROUND_DATA_MISSING: 404
    };
    res.status(map[err.message] || 500).json({ message: err.message });
  }
};

exports.getCurrentProfile = async (req, res) => {
  try {
    const userId = req.user?.id;
    const profile = await UserService.getCurrentProfile(userId);
    res.status(200).json(profile);
  } catch (err) {
    const map = {
      USER_NOT_FOUND: 404
    };
    res.status(map[err.message] || 500).json({ message: err.message });
  }
};

exports.updateProfile = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { username, firstName, lastName, dob } = req.body;

    await UserService.updateProfile(userId, { username, firstName, lastName, dob });
    res.status(200).json({ message: 'Profile updated successfully' });
  } catch (err) {
    const map = {
      USERNAME_EXISTS: 409
    };
    res.status(map[err.message] || 500).json({ message: err.message });
  }
};
