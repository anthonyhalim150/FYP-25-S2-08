const mysql = require('mysql2/promise');

const db = mysql.createPool({
  host: 'wise-workout.c9qquugywaez.ap-southeast-2.rds.amazonaws.com',
  user: 'admin', 
  password: process.env.DB_PASSWORD,
  database: 'FYP', 
  port: 3306,
  waitForConnections: true,
  connectionLimit: 100,
  queueLimit: 5
});

module.exports = db;
