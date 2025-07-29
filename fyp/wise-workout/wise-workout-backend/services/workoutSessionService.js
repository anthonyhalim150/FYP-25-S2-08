const WorkoutSessionModel = require('../models/workoutSessionModel');
const ExerciseLogsModel = require('../models/exerciseLogsModel');

class WorkoutSessionService {
  static async saveWorkoutSession(sessionData, exerciseLogs) {
    try {
      const sessionId = await WorkoutSessionModel.createSession(sessionData);
      for (const exercise of exerciseLogs) {
        await ExerciseLogsModel.logExercise(sessionId, exercise);
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
