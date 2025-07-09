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
    return await UserModel.searchUsersWithStatus(query, userId);
  }


}

module.exports = FriendService;
