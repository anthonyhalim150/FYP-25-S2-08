const UserEntity = require('../entities/userEntity');
const AvatarEntity = require('../entities/avatarEntity');

exports.setAvatar = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { avatarId } = req.body;

    if (!userId || !avatarId) {
      return res.status(400).json({ message: 'Missing userId or avatarId' });
    }

    const avatar = await AvatarEntity.findById(avatarId);
    if (!avatar) {
      return res.status(400).json({ message: 'Avatar does not exist' });
    }

    await UserEntity.updateAvatar(userId, avatarId);
    res.status(200).json({ message: 'Avatar updated successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.getCurrentAvatar = async (req, res) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: 'Unauthorized' });
    }

    const avatarId = await UserEntity.hasAvatar(userId);
    if (!avatarId) {
      return res.status(404).json({ message: 'No avatar set for this user' });
    }

    const avatar = await AvatarEntity.findById(avatarId);
    if (!avatar) {
      return res.status(404).json({ message: 'Avatar data not found' });
    }

    res.status(200).json({ avatar });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.getCurrentProfile = async (req, res) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: 'Unauthorized' });
    }

    const user = await UserEntity.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.status(200).json({
      username: user.username,
      role: user.role,
      coins: user.coins,
      avatarId: user.avatar_id
    });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};
