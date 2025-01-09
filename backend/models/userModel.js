const connection = require('./db');
const bcrypt = require('bcrypt');

const User = {
  findOne: async (username) => {
    const [rows] = await connection.execute('SELECT * FROM users WHERE username = ?', [username]);
    return rows[0];
  },
  validPassword: async (inputPassword, storedPassword) => {
    return await bcrypt.compare(inputPassword, storedPassword);
  }
};

module.exports = User;