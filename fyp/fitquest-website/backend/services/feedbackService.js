const FeedbackModel = require('../models/feedbackModel');

class FeedbackService {
  static async getAllFeedbacks(filter) {
    return await FeedbackModel.findAllWithUser(filter);
  }
  static async setFeedbackStatus(id, status) {
    await FeedbackModel.updateStatus(id, status);
  }
}

module.exports = FeedbackService;
