const FriendModel = require('../models/friendModel');

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
}

module.exports = FriendService;
