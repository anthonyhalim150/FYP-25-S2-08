const WorkoutSessionModel = require('../models/workoutSessionModel');
const ExerciseLogsModel = require('../models/exerciseLogsModel');
const BadgeService = require('../services/badgeService');
const DailyQuestModel = require('../models/dailyQuestModel');
const ChallengeInvitesModel = require('../models/challengeInvitesModel');
const ChallengeProgressModel = require('../models/challengeProgressModel');

class WorkoutSessionService {
  static async saveWorkoutSession(sessionData, exerciseLogs) {
    try {
      const sessionId = await WorkoutSessionModel.createSession(sessionData);
      for (const exercise of exerciseLogs) {
        await ExerciseLogsModel.logExercise(sessionId, exercise);
      }

      const userId = sessionData.userId;
      const today = new Date().toISOString().slice(0, 10);
      await DailyQuestModel.markQuestDone(userId, 'ANY_WORKOUT', today);

      const sessionCount = await WorkoutSessionModel.countSessionsByUserId(userId);
      if (sessionCount >= 1) await BadgeService.grantBadge(userId, 1);
      if (sessionCount >= 10) await BadgeService.grantBadge(userId, 3);
      if (sessionCount >= 50) await BadgeService.grantBadge(userId, 10);
      const totalCalories = await WorkoutSessionModel.getTotalCaloriesBurnedByUserId(userId);
      if (totalCalories >= 1000) await BadgeService.grantBadge(userId, 4);

      const lower = s => (s || '').toLowerCase();
      const sumReps = arr => {
        if (!arr || !Array.isArray(arr)) return 0;
        let t = 0;
        for (const s of arr) {
          const v = typeof s?.reps === 'number' ? s.reps : parseInt(s?.reps || 0, 10);
          if (!Number.isNaN(v)) t += v;
        }
        return t;
      };

      let pushUps = 0;
      let squats = 0;
      let jumpingJacks = 0;
      for (const ex of exerciseLogs || []) {
        const name = lower(ex.exercise_name || ex.exerciseName);
        const reps = sumReps(ex.sets_data || ex.setsData);
        if (name.includes('push up')) pushUps += reps;
        else if (name.includes('squat')) squats += reps;
        else if (name.includes('jumping jack')) jumpingJacks += reps;
      }

      const invites = await ChallengeInvitesModel.getActiveAcceptedInvitesForUser(userId);
      const caloriesThisSession = Number(sessionData.caloriesBurned || 0);
      for (const inv of invites) {
        const unit = lower(inv.unit);
        let delta = 0;
        if (unit.includes('push up')) delta = pushUps;
        else if (unit.includes('squat')) delta = squats;
        else if (unit.includes('jumping jack')) delta = jumpingJacks;
        else if (unit.includes('calorie')) delta = Math.max(0, Math.round(caloriesThisSession));
        if (delta > 0) {
          await ChallengeProgressModel.incrementProgress(inv.invite_id, userId, delta);
        }
      }

      return sessionId;
    } catch (error) {
      throw error;
    }
  }

  static async getUserWorkoutSessions(userId) {
    try {
      const sessions = await WorkoutSessionModel.getSessionsByUserId(userId);
      for (const session of sessions) {
        session.exercises = await ExerciseLogsModel.getExerciseLogsBySessionId(session.session_id);
      }
      return sessions;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = WorkoutSessionService;
