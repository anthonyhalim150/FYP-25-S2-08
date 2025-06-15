const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const dotenv = require('dotenv');
dotenv.config();

const db = require('./config/db');

const loginRoutes = require('./routes/loginRoutes');
const userRoutes = require('./routes/userRoutes');

const app = express();

app.use(cors({
  origin: ['http://localhost:3000'],
  credentials: true
}));

// Middleware to parse JSON and cookies
app.use(express.json());
app.use(cookieParser());

// Routes
app.use('/auth', loginRoutes);
app.use('/api', userRoutes);

// Test DB connection
db.query('SELECT DATABASE() AS db_name')
  .then(([rows]) => {
    console.log('Connected to MySQL database:', rows[0].db_name);
  })
  .catch(err => {
    console.error('DB connection error:', err);
  });

// Start server
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
