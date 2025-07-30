const express = require('express');
const axios = require('axios');
const router = express.Router();
const UserPreferencesModel = require('../models/userPreferencesModel');
const ExerciseModel = require('../models/exerciseModel'); // <-- import your exercise model

const OPENROUTER_KEY = "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";

// POST /ai/fitness-plan
router.post('/ai/fitness-plan', async (req, res) => {
  const userId = req.user?.id;
  if (!userId) return res.status(401).json({ message: "Unauthorized" });

  try {
    // 1. Fetch user preferences from the DB
    const prefs = await UserPreferencesModel.getPreferences(userId);
    if (!prefs) return res.status(404).json({ message: "Preferences not found" });

    // 2. Fetch all exercises from the DB
    const exercises = await ExerciseModel.getAllExercises();
    if (!exercises || exercises.length === 0) {
      return res.status(404).json({ message: "No exercises found" });
    }

    // 3. Prepare a strict system prompt
const systemPrompt = `
You are an expert fitness coach. Create a personalized weekly workout plan based ONLY on the user's preferences and the provided exercise list.

STRICT RULES:
- Use only the exercises from the provided list. Never invent or use exercises not in the list.
- The workout frequency (number of days per week) MUST match the user's preference, always using the higher number if a range is given (e.g., "1-2 times a week" = 2 days, "3-4 times a week" = 4 days, "5+ times a week" = 5 days).
- Assign real days of the week for each workout, and make sure workout days are spread out through the week. Insert REST days between workout days (do not schedule workouts on consecutive days unless necessary).
- For each workout day, include AT LEAST 4 different exercises.
- Each workout day must include:
  - "day_of_week": e.g. "Monday"
  - "exercises": an array, where each exercise includes: { "name": "...", "sets": X, "reps": "..." }
  - "notes": a short, motivating message or any important instruction (optional).
- For days with no workouts, include an entry with "day_of_week": "<Day>", "rest": true, and a motivating "notes" field such as "Rest and recover today."
- Select exercises that fit the user's equipment preference, goal, fitness level, and avoid exercises related to the user's injuries.
- Give priority to exercises the user enjoys.
- For sets, reps, or weights, always use numbers or text in quotes (e.g. "12", "10 per leg").
- Output ONLY a valid JSON array of all 7 days of the week, in order (no markdown, no explanation). Each object is either a workout day or a rest day.

Example output for a 2-day/week plan:
[
  {
    "day_of_week": "Monday",
    "exercises": [
      { "name": "Incline Push Up", "sets": 3, "reps": "10" },
      { "name": "Tricep Dips", "sets": 3, "reps": "15" },
      { "name": "Chest Fly", "sets": 3, "reps": "12" },
      { "name": "Plank", "sets": 3, "reps": "1 min" }
    ],
    "notes": "Focus on slow and controlled movements."
  },
  {
    "day_of_week": "Tuesday",
    "rest": true,
    "notes": "Rest and recover today!"
  },
  {
    "day_of_week": "Wednesday",
    "rest": true,
    "notes": "Use this day to stretch and hydrate."
  },
  {
    "day_of_week": "Thursday",
    "exercises": [
      { "name": "Squats", "sets": 3, "reps": "15" },
      { "name": "Lunges", "sets": 3, "reps": "12 per leg" },
      { "name": "Glute Bridge", "sets": 3, "reps": "15" },
      { "name": "Russian Twist", "sets": 3, "reps": "20" }
    ],
    "notes": "Keep your core engaged."
  },
  {
    "day_of_week": "Friday",
    "rest": true,
    "notes": "Active rest: Take a walk or do some yoga."
  },
  {
    "day_of_week": "Saturday",
    "rest": true,
    "notes": "Enjoy your rest day!"
  },
  {
    "day_of_week": "Sunday",
    "rest": true,
    "notes": "Prepare for the upcoming week."
  }
]
`;



    // 4. Prepare user prompt with all preference data and exercises
    const userPrompt = `
User preferences:
${JSON.stringify(prefs, null, 2)}

Available exercises (use only these!):
${JSON.stringify(exercises, null, 2)}
`;

    // 5. Call Qwen AI via OpenRouter
    const response = await axios.post(
      'https://openrouter.ai/api/v1/chat/completions',
      {
        model: "openai/gpt-3.5-turbo",
        messages: [
          { role: "system", content: systemPrompt },
          { role: "user", content: userPrompt }
        ]
      },
      {
        headers: {
          "Authorization": `Bearer ${OPENROUTER_KEY}`,
          "Content-Type": "application/json"
        }
      }
    );

    // 6. Log Qwen's response to your terminal
    console.log("AI response content:", response.data?.choices?.[0]?.message?.content);

    // 7. Return AI result to frontend
    res.json({
      ai: response.data,
      preferences: prefs,
      exercises: exercises
    });

  } catch (error) {
    // Log error details to terminal
    console.error("AI API error:", error?.response?.data || error.message);
    res.status(500).json({ error: "Failed to get AI fitness plan" });
  }
});

module.exports = router;
