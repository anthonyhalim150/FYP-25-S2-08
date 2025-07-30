const FeedbackModel = require('../models/feedbackModel');

class FeedbackService {
  static async addFeedback(userId, feedbackData) {
    await FeedbackModel.addFeedback(userId, feedbackData);
  }

  static async getPublishedFeedback() {
    return await FeedbackModel.getPublishedFeedback();
  }

  static async getAllFeedback() {
    return await FeedbackModel.getAllFeedback();
  }

  static async updateStatus(id, status) {
    await FeedbackModel.updateStatus(id, status);
  }
}

module.exports = FeedbackService;
