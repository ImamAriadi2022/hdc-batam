const connection = require('./db');

const Notification = {
  findByUserId: async (userId) => {
    const [rows] = await connection.execute('SELECT * FROM notifications WHERE userId = ?', [userId]);
    return rows;
  },

  markAsRead: async (id) => {
    await connection.execute('DELETE FROM notifications WHERE id = ?', [id]);
  },
};

module.exports = Notification;