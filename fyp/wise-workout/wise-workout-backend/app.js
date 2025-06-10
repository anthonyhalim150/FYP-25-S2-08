const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const dotenv = require('dotenv');
dotenv.config();

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
//This is public route.
app.use('/auth', userRoutes);
app.use('/auth', pendingUserRoutes);

app.use(authenticateUser);
app.use('/lucky', spinRoutes);
app.use('/questionnaire', questionnaireRoutes);

db.query('SELECT 1')
  .then(() => console.log('Connected to MySQL database.'))
  .catch(err => console.error('DB connection error:', err));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}...`);
});
