const Notification = require('../models/notificationModel');

exports.getNotifications = async (req, res) => {
    const userId = req.user.id; // Assumes userId is obtained from middleware
    console.log(`Fetching notifications for userId: ${userId}`);
    try {
        const notifications = await Notification.findByUserId(userId);
        res.json(notifications);
    } catch (error) {
        console.error('Error fetching notifications:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

exports.markAsRead = async (req, res) => {
    const { id } = req.params;
    console.log(`Marking notification as read with id: ${id}`);
    try {
        await Notification.markAsRead(id);
        res.json({ message: 'Notification marked as read' });
    } catch (error) {
        console.error('Error marking notification as read:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};