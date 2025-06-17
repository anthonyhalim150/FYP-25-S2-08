const UserModel = require('../models/userModel');
const AvatarModel = require('../models/avatarModel');
const BackgroundModel = require('../models/backgroundModel');

class UserService {
  static async setAvatar(userId, avatarId) {
    if (!userId || !avatarId) throw new Error('MISSING_DATA');

    const avatar = await AvatarModel.findById(avatarId);
    if (!avatar) throw new Error('AVATAR_NOT_FOUND');

    const user = await UserModel.findById(userId);
    if (avatar.is_premium && user.role !== 'premium') {
      throw new Error('PREMIUM_REQUIRED');
    }

    await AvatarModel.updateAvatar(userId, avatarId);
  }

  static async setBackground(userId, backgroundId) {
    if (!userId || !backgroundId) throw new Error('MISSING_DATA');

    const background = await BackgroundModel.findById(backgroundId);
    if (!background) throw new Error('BACKGROUND_NOT_FOUND');

    const user = await UserModel.findById(userId);
    if (background.is_premium && user.role !== 'premium') {
      throw new Error('PREMIUM_REQUIRED');
    }

    await BackgroundModel.updateBackground(userId, backgroundId);
  }

  static async getCurrentAvatar(userId) {
    const user = await UserModel.findById(userId);
    if (!user || !user.avatar_id) throw new Error('NO_AVATAR');

    const avatar = await AvatarModel.findById(user.avatar_id);
    if (!avatar) throw new Error('AVATAR_DATA_MISSING');

    return avatar;
  }

  static async getCurrentBackground(userId) {
    const user = await UserModel.findById(userId);
    if (!user || !user.background_id) throw new Error('NO_BACKGROUND');

    const background = await BackgroundModel.findById(user.background_id);
    if (!background) throw new Error('BACKGROUND_DATA_MISSING');

    return background;
  }

  static async getCurrentProfile(userId) {
    const user = await UserModel.findById(userId);
    if (!user) throw new Error('USER_NOT_FOUND');

    const avatar = user.avatar_id ? await AvatarModel.findById(user.avatar_id) : null;
    const background = user.background_id ? await BackgroundModel.findById(user.background_id) : null;

    return {
      username: user.username,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      dob: user.dob,
      role: user.role,
      tokens: user.tokens,
      avatar: avatar ? avatar.image_url : null,
      background: background ? background.image_url : null
    };
  }

  static async updateProfile(userId, updates) {
    if (updates.username) {
      const existing = await UserModel.findByUsername(updates.username);
      if (existing && existing.id !== userId) {
        throw new Error('USERNAME_EXISTS');
      }
    }
    await UserModel.updateProfile(userId, updates);
  }
}

module.exports = UserService;
