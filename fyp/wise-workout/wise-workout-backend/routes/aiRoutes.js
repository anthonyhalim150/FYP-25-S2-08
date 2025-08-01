const express = require('express');
const axios = require('axios');
const router = express.Router();
const UserPreferencesModel = require('../models/userPreferencesModel');
const ExerciseModel = require('../models/exerciseModel'); 

const OPENROUTER_KEY = "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";

router.post('/ai/fitness-plan', async (req, res) => {
  const userId = req.user?.id;
  if (!userId) return res.status(401).json({ message: "Unauthorized" });

  try {
    const prefs = await UserPreferencesModel.getPreferences(userId);
    if (!prefs) return res.status(404).json({ message: "Preferences not found" });

    const exercises = await ExerciseModel.getAllExercises();
    if (!exercises || exercises.length === 0) {
      return res.status(404).json({ message: "No exercises found" });
    }

    // --- THE NEW SYSTEM PROMPT FOR 30 DAYS & WORKOUT_TIME LOGIC ---
    const systemPrompt = `
You are an expert fitness coach. Create a personalized 30-day workout plan based ONLY on the user's preferences and the provided exercise list.

STRICT RULES:
- Use only the exercises from the provided list. Never invent or use exercises not in the list.
- For each day, the number of exercises must match the user's "workout_time" preference:
  - If "Quick (e.g. 5 Minutes during Lunch Break)" → include only 1 exercise for that day.
  - If "Short (10-20 Minutes)" → include 2 exercises.
  - If "Medium (25-45 Minutes)" → include 4 exercises.
  - If "Long (1 Hour or more)" → include 6 exercises.
- Each day must include:
  - "day_of_month": 1 to 30 (for each day, incrementing)
  - "exercises": an array of the correct number of exercises, where each exercise includes: { "name": "...", "sets": X, "reps": "..." }
  - "notes": a short, motivating message or any important instruction (optional).
- You MUST generate exactly 30 days. Each object in the array is a day.
- For rest days, include: "day_of_month": <day>, "rest": true, and a motivating "notes" field (e.g., "Rest and recover today.")
- Select exercises that fit the user's equipment preference, goal, fitness level, and avoid exercises related to the user's injuries.
- Give priority to exercises the user enjoys.
- For sets, reps, or weights, always use numbers or text in quotes (e.g. "12", "10 per leg").
- Output ONLY a valid JSON array of 31 objects (first object is plan_title, next 30 are the 30 days), in order (no markdown, no explanation).
- At the top of the JSON array, add an object with the key "plan_title" and a short, catchy name for the plan, e.g. { "plan_title": "30-Day Full Body Challenge" }. The rest of the array should be the 30 days as described above.

Example output for a 2-day plan:
[
  { "plan_title": "30-Day Energy Boost" },
  {
    "day_of_month": 1,
    "exercises": [
      { "name": "Incline Push Up", "sets": 3, "reps": "10" }
    ],
    "notes": "Start strong and stay motivated!"
  },
  {
    "day_of_month": 2,
    "rest": true,
    "notes": "Rest and recover today."
  }
  // ... up to day 30
]
    `;

    const userPrompt = `
User preferences:
${JSON.stringify(prefs, null, 2)}

Available exercises (use only these!):
${JSON.stringify(exercises, null, 2)}
`;

    const response = await axios.post(
      'https://openrouter.ai/api/v1/chat/completions',
      {
        model: "z-ai/glm-4.5-air:free",
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

    console.log("AI response content:", response.data?.choices?.[0]?.message?.content);

    res.json({
      ai: response.data,
      preferences: prefs,
      exercises: exercises
    });

  } catch (error) {
    console.error("AI API error:", error?.response?.data || error.message);
    res.status(500).json({ error: "Failed to get AI fitness plan" });
  }
});

module.exports = router;
