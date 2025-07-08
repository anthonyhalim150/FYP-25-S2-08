const FriendModel = require('../models/friendModel');
const UserModel = require('../models/userModel');

class FriendService {
  static async sendRequest(userId, friendId) {
    return await FriendModel.sendRequest(userId, friendId);
  }
  static async acceptRequest(userId, friendId) {
    await FriendModel.acceptRequest(userId, friendId);
  }
  static async rejectRequest(userId, friendId) {
    await FriendModel.rejectRequest(userId, friendId);
  }
  static async getFriends(userId) {
    return await FriendModel.getFriends(userId);
  }
  static async getPendingRequests(userId) {
    return await FriendModel.getPendingRequests(userId);
  }
  static async getSentRequests(userId) {
    return await FriendModel.getSentRequests(userId);
  }
  static async searchUsers(userId, query) {
    const friends = await FriendModel.getFriends(userId);
    const pending = await FriendModel.getPendingRequests(userId);
    const sent = await FriendModel.getSentRequests(userId);
    const excludeIds = [userId];
    friends.forEach(f => excludeIds.push(f.id));
    pending.forEach(f => excludeIds.push(f.id));
    sent.forEach(f => excludeIds.push(f.id));
    const uniqueIds = [...new Set(excludeIds)];
    return await UserModel.searchUsers(query, uniqueIds);
  }

}

module.exports = FriendService;
