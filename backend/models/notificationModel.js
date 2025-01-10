const connection = require('./db');

const Notification = {
    create: async (userId, message) => {
        const [result] = await connection.execute(
            'INSERT INTO notifications (userId, message) VALUES (?, ?)',
            [userId, message]
        );
        return result.insertId;
    },

    findByUserId: async (userId) => {
        const [rows] = await connection.execute('SELECT * FROM notifications WHERE userId = ?', [userId]);
        return rows;
    },

    deleteOne: async (id) => {
        await connection.execute('DELETE FROM notifications WHERE id = ?', [id]);
    },
};

module.exports = Notification;