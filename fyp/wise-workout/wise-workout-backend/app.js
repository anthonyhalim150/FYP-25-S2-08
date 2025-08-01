const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const dotenv = require('dotenv');
const rateLimit = require('express-rate-limit');
dotenv.config();
const authenticateUser = require('./middlewares/authMiddleware');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const pendingUserRoutes = require('./routes/pendingUserRoutes');
const questionnaireRoutes = require('./routes/userPreferenceRoutes');
const spinRoutes = require('./routes/spinRoutes');
const prizeRoutes = require('./routes/prizeRoutes');
const messageRoutes = require('./routes/messageRoutes');
const friendRoutes = require('./routes/friendRoutes');
const badgeRoutes = require('./routes/badgeRoutes');
const dailyQuestRoutes = require('./routes/dailyQuestRoutes');
const workoutCategoryRoutes = require('./routes/workoutCategoryRoutes');
const workoutRoutes = require('./routes/workoutRoutes');
const exerciseRoutes = require('./routes/exerciseRoutes');
const workoutSessionRoutes = require('./routes/workoutSessionRoutes');
const tournamentRoutes = require('./routes/tournamentRoutes');
const aiRoutes = require('./routes/aiRoutes');
const feedbackRoutes = require('./routes/feedbackRoutes');
const challengeRoutes = require('./routes/challengeRoutes');
const workoutPlanRoutes = require('./routes/workoutPlanRoutes');
const userPreferenceRoutes = require('./routes/userPreferenceRoutes');
const db = require('./config/db');

const app = express();

const authLimiter = rateLimit({
  windowMs: 60 * 1000,
  max: 10,
  message: { message: 'Too many requests, please try again later.' },
  standardHeaders: true,
  legacyHeaders: false,
});

app.use(cors({
  origin: ['http://localhost:3000', 'http://10.0.2.2:3000'],
  credentials: true
}));
app.use(express.json());
app.use(cookieParser());

app.use('/auth', authLimiter);
app.use('/auth', authRoutes);
app.use('/auth', pendingUserRoutes);

app.use(authenticateUser);
app.use('/user', userRoutes);
app.use('/user', dailyQuestRoutes);
app.use('/lucky', spinRoutes);
app.use('/questionnaire', questionnaireRoutes);
app.use('/prizes', prizeRoutes);
app.use('/messages', messageRoutes);
app.use('/friends', friendRoutes);
app.use('/badges', badgeRoutes);
app.use('/workout-categories', workoutCategoryRoutes);
app.use('/workouts', workoutRoutes);
app.use('/exercises', exerciseRoutes);
app.use('/workout-sessions', workoutSessionRoutes);
app.use('/tournaments', tournamentRoutes);
app.use('/feedback', feedbackRoutes);
app.use('/challenges', challengeRoutes);
app.use('/workout-plans', workoutPlanRoutes);
app.use('/user/preferences', userPreferenceRoutes);
app.use(aiRoutes);
db.query('SELECT 1')
  .then(() => console.log('Connected to MySQL database.'))
  .catch(err => console.error('DB connection error:', err));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}...`);
});
