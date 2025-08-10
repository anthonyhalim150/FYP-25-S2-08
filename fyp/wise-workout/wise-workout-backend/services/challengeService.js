const db = require('../config/db');
const ChallengeModel = require('../models/challengeModel');
const ChallengeInvitesModel = require('../models/challengeInvitesModel');
const ChallengeProgressModel = require('../models/challengeProgressModel');

const ChallengeService = {
  getAllChallenges: async () => {
    return await ChallengeModel.getAllChallenges();
  },

  getInvitations: async (userId) => {
    return await ChallengeInvitesModel.getPendingInvites(userId);
  },

  getAcceptedChallenges: async (userId) => {
    return await ChallengeInvitesModel.getAcceptedChallenges(userId);
  },

  acceptChallenge: async (inviteId) => {
    const conn = await db.getConnection();
    try {
      await conn.beginTransaction();
      const invite = await ChallengeInvitesModel.getInviteForAcceptance(inviteId);
      if (!invite) throw new Error('Invite not found');
      const now = new Date();
      const baseValue = invite.custom_duration_value || invite.duration;
      const unit = (invite.custom_duration_unit || 'days').toLowerCase();
      let expiresAt;
      if (unit === 'months') {
        const d = new Date(now.getTime());
        d.setMonth(d.getMonth() + baseValue);
        expiresAt = d;
      } else if (unit === 'weeks') {
        expiresAt = new Date(now.getTime() + baseValue * 7 * 24 * 60 * 60 * 1000);
      } else {
        expiresAt = new Date(now.getTime() + baseValue * 24 * 60 * 60 * 1000);
      }
      await ChallengeInvitesModel.markInviteAccepted(inviteId, now, expiresAt);
      await ChallengeProgressModel.insertInitialProgress(inviteId, invite.receiver_id);
      await ChallengeProgressModel.insertInitialProgress(inviteId, invite.sender_id);
      await conn.commit();
    } catch (e) {
      await conn.rollback();
      throw e;
    } finally {
      conn.release();
    }
  },

  rejectChallenge: async (inviteId) => {
    return await ChallengeInvitesModel.markInviteRejected(inviteId);
  },

  sendChallenge: async ({ senderId, receiverId, title, customValue, customDurationValue, customDurationUnit }) => {
    const challengeId = await ChallengeModel.findChallengeIdByTitle(title);
    if (!challengeId) throw new Error('Challenge template not found');
    return await ChallengeInvitesModel.createChallengeInvite(
      challengeId,
      senderId,
      receiverId,
      customValue,
      customDurationValue,
      customDurationUnit
    );
  },

  getFriendsToChallenge: async (userId, title) => {
    return await ChallengeInvitesModel.getPremiumFriendsToChallenge(userId, title);
  },
  getLeaderboard: async (userId) => {
    return await ChallengeModel.getLeaderboardsByUser(userId);
  }
};

module.exports = ChallengeService;
