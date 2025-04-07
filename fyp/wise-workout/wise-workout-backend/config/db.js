const mysql = require('mysql2/promise');

const db = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'Vvs319338',
  database: 'FYP',
});

module.exports = db;
