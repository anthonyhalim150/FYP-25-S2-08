const WorkoutSessionModel = require('../models/workoutSessionModel');
const ExerciseLogsModel = require('../models/exerciseLogsModel');
const BadgeService = require('../services/badgeService');
const DailyQuestModel = require('../models/dailyQuestModel');

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
      if (sessionCount >= 1) {
        await BadgeService.grantBadge(userId, 1); // badgeId 1 = First Workout
      }
      if (sessionCount >= 10) {
        await BadgeService.grantBadge(userId, 3); // badgeId 3 = 10 Workouts
      }
      if (sessionCount >= 50) {
        await BadgeService.grantBadge(userId, 10); // badgeId 10 = 50 Workouts
      }
      const totalCalories = await WorkoutSessionModel.getTotalCaloriesBurnedByUserId(userId);
      if (totalCalories >= 1000) {
        await BadgeService.grantBadge(userId, 4); // badgeId 4 = 1000 Calories Burned
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
