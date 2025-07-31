const Challenge = require('../models/challengeModel');

async function sendChallenge(senderId, receiverId, title, target, duration) {
  return await Challenge.createChallenge(senderId, receiverId, title, target, duration);
}

async function getAcceptedChallenges(userId) {
  return await challenge.getAcceptedChallenges(userId);
}

async function getReceivedChallenges(userId) {
  return await Challenge.getReceivedChallenges(userId);
}

async function respondChallenge(challengeId, status) {
  return await Challenge.updateChallengeStatus(challengeId, status);
}

module.exports = {
  sendChallenge,
  getAcceptedChallenges,
  getReceivedChallenges,
  respondChallenge,
};
