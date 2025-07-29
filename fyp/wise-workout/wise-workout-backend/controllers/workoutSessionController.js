const WorkoutSessionService = require('../services/workoutSessionService');

exports.saveWorkoutSession = async (req, res) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: 'User not authenticated' });
    }

    const { workoutId, startTime, endTime, duration, caloriesBurned, notes, exercises } = req.body;
    
    const sessionData = {
      userId,
      workoutId: workoutId || null,
      startTime: startTime || new Date().toISOString(),
      endTime: endTime || new Date().toISOString(),
      duration: duration || 0,
      caloriesBurned: caloriesBurned || 0,
      notes: notes || ''
    };

    const sessionId = await WorkoutSessionService.saveWorkoutSession(sessionData, exercises || []);
    
    res.status(201).json({ 
      message: 'Workout session saved successfully',
      sessionId 
    });
  } catch (error) {
    console.error('Error saving workout session:', error);
    res.status(500).json({ message: 'Failed to save workout session' });
  }
};

exports.getUserWorkoutSessions = async (req, res) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: 'User not authenticated' });
    }

    const sessions = await WorkoutSessionService.getUserWorkoutSessions(userId);
    
    res.json(sessions);
  } catch (error) {
    console.error('Error fetching workout sessions:', error);
    res.status(500).json({ message: 'Failed to fetch workout sessions' });
  }
};