const challengeService = require('../services/challengeService');

async function sendChallenge(req, res) {
  try {
    const senderId = req.user.id;
    const { receiverId, title, target, duration } = req.body;
    if (!receiverId || !title || !target || !duration) {
      return res.status(400).json({ message: 'Missing required fields' });
    }
    await challengeService.sendChallenge(senderId, receiverId, title, target, duration);
    res.status(200).json({ message: 'Challenge sent' });
  } catch (err) {
    console.error('Error sending challenge:', err);
    res.status(500).json({ message: 'Failed to send challenge' });
  }
}

async function getReceivedChallenges(req, res) {
  try {
    const userId = req.user.id;
    const challenges = await challengeService.getReceivedChallenges(userId);
    res.status(200).json(challenges);
  } catch (err) {
    console.error('Error fetching challenges:', err);
    res.status(500).json({ message: 'Failed to retrieve challenges' });
  }
}

async function getAcceptedChallenges(req, res) {
  try {
    const userId = req.user.id;
    const challenges = await challengeService.getAcceptedChallenges(userId);
    res.status(200).json(challenges);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to fetch accepted challenges.' });
  }
}

async function respondChallenge(req, res) {
  try {
    const { challengeId, action } = req.body;
    if (!challengeId || !['accept', 'reject'].includes(action)) {
      return res.status(400).json({ message: 'Invalid input' });
    }
    const status = action === 'accept' ? 'accepted' : 'rejected';
    await challengeService.respondChallenge(challengeId, status);
    res.status(200).json({ message: `Challenge ${action}ed` });
  } catch (err) {
    console.error('Error responding to challenge:', err);
    res.status(500).json({ message: 'Failed to respond to challenge' });
  }
}

module.exports = {
  sendChallenge,
  getAcceptedChallenges,
  getReceivedChallenges,
  respondChallenge,
};
