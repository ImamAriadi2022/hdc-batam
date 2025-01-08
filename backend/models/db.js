const mysql = require('mysql2/promise');

const dbConfig = {
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'emergency_app'
};

const connection = mysql.createPool(dbConfig);

module.exports = connection;
