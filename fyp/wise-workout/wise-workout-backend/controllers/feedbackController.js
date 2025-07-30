const FeedbackService = require('../services/feedbackService');

exports.submitFeedback = async (req, res) => {
  const userId = req.user.id;
  const { message, rating, liked_features, problems } = req.body;
  if (typeof rating !== 'number' || rating < 1 || rating > 5)
    return res.status(400).json({ message: 'Rating is required and must be between 1 and 5' });
  await FeedbackService.addFeedback(userId, {
    message: message || null,
    rating,
    liked_features: Array.isArray(liked_features) ? liked_features : [],
    problems: Array.isArray(problems) ? problems : [],
  });
  res.json({ message: 'Feedback submitted' });
};

exports.getPublishedFeedback = async (req, res) => {
  const feedback = await FeedbackService.getPublishedFeedback();
  res.json(feedback);
};

exports.getAllFeedback = async (req, res) => {
  const feedback = await FeedbackService.getAllFeedback();
  res.json(feedback);
};

exports.updateFeedbackStatus = async (req, res) => {
  const { id, status } = req.body;
  if (!['accepted', 'rejected', 'pending'].includes(status))
    return res.status(400).json({ message: 'Invalid status' });
  await FeedbackService.updateStatus(id, status);
  res.json({ message: 'Feedback status updated' });
};