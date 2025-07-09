const MessageModel = require('../models/messageModel');

class MessageService {
  static async sendMessage(senderId, receiverId, content) {
    return await MessageModel.sendMessage(senderId, receiverId, content);
  }

  static async getConversation(userId1, userId2) {
    return await MessageModel.getConversation(userId1, userId2);
  }
  static async markAsRead(senderId, receiverId) {
    await MessageModel.markAsRead(senderId, receiverId);
  }

  static async getUnreadCounts(userId) {
    return await MessageModel.getUnreadCounts(userId);
  }

}

module.exports = MessageService;
