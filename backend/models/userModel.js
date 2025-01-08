const connection = require('./db');

const User = {
    findByUsername: async (username) => {
        const [rows] = await connection.execute('SELECT * FROM users WHERE username = ?', [username]);
        return rows[0];
    },

    create: async (username, hashedPassword) => {
        const [result] = await connection.execute(
            'INSERT INTO users (username, password) VALUES (?, ?)',
            [username, hashedPassword]
        );
        return result.insertId;
    },
};

module.exports = User;
