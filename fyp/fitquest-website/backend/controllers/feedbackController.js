const FeedbackService = require('../services/feedbackService');

exports.getAllFeedbacks = async (req, res) => {
  try {
    const { status = 'All', search = '' } = req.query;
    const feedbacks = await FeedbackService.getAllFeedbacks({ status, search });
    res.status(200).json(feedbacks);
  } catch {
    res.status(500).json({ message: 'Failed to fetch feedbacks' });
  }
};

exports.setFeedbackStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    if (!['pending', 'accepted', 'rejected'].includes(status))
      return res.status(400).json({ message: 'Invalid status' });
    await FeedbackService.setFeedbackStatus(id, status);
    res.status(200).json({ message: `Feedback status set to ${status}` });
  } catch {
    res.status(400).json({ message: 'Failed to update status' });
  }
};
