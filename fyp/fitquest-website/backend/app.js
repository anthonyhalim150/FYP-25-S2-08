const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const dotenv = require('dotenv');
dotenv.config();

const db = require('./config/db');

const userRoutes = require('./routes/userRoutes');
const authRoutes = require('./routes/authRoutes');
const feedbackRoutes = require('./routes/feedbackRoutes');
const authenticateUser = require('./middlewares/authMiddleware');

const app = express();

app.use(cors({
  origin: ['http://localhost:3000'],
  credentials: true
}));

app.use(express.json());
app.use(cookieParser());
app.use(authRoutes);

app.use(authenticateUser);

app.use(userRoutes);
app.use(feedbackRoutes);

db.query('SELECT DATABASE() AS db_name')
  .then(([rows]) => {
    console.log('Connected to MySQL database:', rows[0].db_name);
  })
  .catch(err => {
    console.error('DB connection error:', err);
  });

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
