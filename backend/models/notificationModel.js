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

    markAsRead: async (id) => {
        await connection.execute('UPDATE notifications SET isRead = 1 WHERE id = ?', [id]);
    },
};

module.exports = Notification;