const WorkoutSessionModel = require('../models/workoutSessionModel');
const ExerciseLogModel = require('../models/exerciseLogsModel');

class WorkoutSessionService {
  static async saveWorkoutSession(sessionData, exerciseLogs) {
    try {
      const sessionId = await WorkoutSessionModel.createSession(sessionData);
      for (const exercise of exerciseLogs) {
        await ExerciseLogModel.logExercise(sessionId, exercise);
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
        session.exercises = await ExerciseLogModel.getExerciseLogsBySessionId(session.session_id);
      }
      return sessions;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = WorkoutSessionService;
