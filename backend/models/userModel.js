const connection = require('./db');
const bcrypt = require('bcrypt');

const User = {
    findByUsername: async (username) => {
        const [rows] = await connection.execute('SELECT * FROM users WHERE username = ?', [username]);
        return rows[0];
    },

    create: async (username, password) => {
        const hashedPassword = await bcrypt.hash(password, 10);
        await connection.execute('INSERT INTO users (username, password) VALUES (?, ?)', [username, hashedPassword]);
    },
};

module.exports = User;