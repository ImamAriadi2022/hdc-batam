const connection = require('../models/db');

exports.getNotifications = async (req, res) => {
    const userId = req.user.id; // Assumes userId is obtained from middleware
    try {
        const [rows] = await connection.execute('SELECT * FROM notifications WHERE userId = ?', [userId]);
        res.json(rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

exports.markAsRead = async (req, res) => {
    const { id } = req.params;
    try {
        await connection.execute('UPDATE notifications SET isRead = 1 WHERE id = ?', [id]);
        res.json({ message: 'Notification marked as read' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
};
