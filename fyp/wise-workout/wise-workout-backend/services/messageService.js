const MessageModel = require('../models/messageModel');

class MessageService {
  static async sendMessage(senderId, receiverId, content) {
    return await MessageModel.sendMessage(senderId, receiverId, content);
  }

  static async getConversation(userId1, userId2) {
    return await MessageModel.getConversation(userId1, userId2);
  }
}

module.exports = MessageService;
