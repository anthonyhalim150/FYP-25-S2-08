const UserEntity = require('../entities/userEntity');
const AvatarEntity = require('../entities/avatarEntity');
const BackgroundEntity = require('../entities/backgroundEntity'); 

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

exports.setBackground = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { backgroundId } = req.body;

    if (!userId || !backgroundId) {
      return res.status(400).json({ message: 'Missing userId or backgroundId' });
    }

    const background = await BackgroundEntity.findById(backgroundId);
    if (!background) {
      return res.status(400).json({ message: 'Background does not exist' });
    }

    await UserEntity.updateBackground(userId, backgroundId);
    res.status(200).json({ message: 'Background updated successfully' });
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


exports.getCurrentBackground = async (req, res) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: 'Unauthorized' });
    }

    const user = await UserEntity.findById(userId);
    if (!user || !user.background_id) {
      return res.status(404).json({ message: 'No background set for this user' });
    }

    const background = await BackgroundEntity.findById(user.background_id);
    if (!background) {
      return res.status(404).json({ message: 'Background data not found' });
    }

    res.status(200).json({ background });
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
      avatarId: user.avatar_id,
      backgroundId: user.background_id 
    });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};
