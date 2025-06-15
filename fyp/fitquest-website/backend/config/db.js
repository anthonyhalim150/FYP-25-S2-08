const mysql = require('mysql2/promise');

const db = mysql.createPool({
  host: 'localhost',
  user: 'root',      
  password: 'cps829',
  database: 'fyp',   
});

module.exports = db;
