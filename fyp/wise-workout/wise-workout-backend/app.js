const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const dotenv = require('dotenv');
dotenv.config();

const authRoutes = require('./routes/authRoutes'); 
const userRoutes = require('./routes/userRoutes');
const pendingUserRoutes = require('./routes/pendingUserRoutes');
const questionnaireRoutes = require('./routes/userPreferenceRoutes');
const spinRoutes = require('./routes/spinRoutes');
const authenticateUser = require('./middlewares/authMiddleware');
const db = require('./config/db');

const app = express();

app.use(cors({
  origin: ['http://localhost:3000', 'http://10.0.2.2:3000'],
  credentials: true
}));
app.use(express.json());
app.use(cookieParser());

// Public routes
app.use('/auth', authRoutes);
app.use('/auth', pendingUserRoutes);

// Authenticated routes
app.use(authenticateUser);
app.use('/user', userRoutes); 
app.use('/lucky', spinRoutes);
app.use('/questionnaire', questionnaireRoutes);

db.query('SELECT 1')
  .then(() => console.log('Connected to MySQL database.'))
  .catch(err => console.error('DB connection error:', err));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}...`);
});
