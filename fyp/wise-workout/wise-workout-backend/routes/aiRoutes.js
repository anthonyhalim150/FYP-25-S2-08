const express = require('express');
const axios = require('axios');
const router = express.Router();
const UserPreferencesModel = require('../models/userPreferencesModel');

const OPENROUTER_KEY = "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";

// POST /ai/fitness-plan
router.post('/ai/fitness-plan', async (req, res) => {
  const userId = req.user?.id;
  if (!userId) return res.status(401).json({ message: "Unauthorized" });

  try {
    // 1. Fetch user preferences from the DB
    const prefs = await UserPreferencesModel.getPreferences(userId);
    if (!prefs) return res.status(404).json({ message: "Preferences not found" });

    // 2. Prepare a strict system prompt
    const systemPrompt = `
You are an expert fitness coach. Based on the user's preferences, create a detailed and motivating 1-week workout plan.
Output ONLY a valid JSON array (no markdown, no explanations).
For reps/sets/weight with units/words, use a string in quotes (e.g. "10 per leg").
Example output:
[
  {
    "day": 1,
    "exercises": [
      { "name": "Squats", "sets": 3, "reps": "12" }
    ],
    "notes": "Focus on form."
  }
]
`;

    // 3. Prepare user prompt with all preference data
    const userPrompt = `User preferences: ${JSON.stringify(prefs)}`;

    // 4. Call Qwen AI via OpenRouter
    const response = await axios.post(
      'https://openrouter.ai/api/v1/chat/completions',
      {
        model: "qwen/qwen3-235b-a22b-2507:free",
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

    // 5. Log Qwen's response to your terminal
    console.log("AI response content:", response.data?.choices?.[0]?.message?.content);

    // 6. Return AI result to frontend
    res.json({
      ai: response.data,
      preferences: prefs
    });

  } catch (error) {
    // Log error details to terminal
    console.error("AI API error:", error?.response?.data || error.message);
    res.status(500).json({ error: "Failed to get AI fitness plan" });
  }
});

module.exports = router;
