const ChallengeModel = require('../models/challengeModel');

const ChallengeService = {
  getAllChallenges: async () => {
    return await ChallengeModel.getAllChallenges();
  },
  getInvitations: async (userId) => {
    return await ChallengeModel.getPendingInvites(userId);
  },

  getAcceptedChallenges: async (userId) => {
    return await ChallengeModel.getAcceptedChallenges(userId);
  },

  acceptChallenge: async (inviteId) => {
    return await ChallengeModel.updateInviteStatus(inviteId, 'accepted');
  },

  rejectChallenge: async (inviteId) => {
    return await ChallengeModel.updateInviteStatus(inviteId, 'rejected');
  },

  sendChallenge: async ({ senderId, receiverId, title, customValue, customDurationValue, customDurationUnit }) => {
    const challengeId = await ChallengeModel.findChallengeIdByTitle(title);
    return await ChallengeModel.createChallengeInvite(
      challengeId,
      senderId,
      receiverId,
      customValue,         
      customDurationValue,     
      customDurationUnit   
    );
  },
  
  getFriendsToChallenge: async (userId, title) => {
    return await ChallengeModel.getPremiumFriendsToChallenge(userId, title);
  }
};

module.exports = ChallengeService;
