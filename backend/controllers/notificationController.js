const Notification = require('../models/notificationModel');

exports.getNotifications = async (req, res) => {
  try {
    const userId = req.user.id;
    console.log(`Fetching notifications for userId: ${userId}`);
    const notifications = await Notification.findByUserId(userId);
    res.status(200).json(notifications);
  } catch (error) {
    console.error('Error fetching notifications:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};

exports.markAsRead = async (req, res) => {
  try {
    const { id } = req.params;
    console.log(`Marking notification as read with id: ${id}`);
    await Notification.markAsRead(id);
    res.status(200).json({ message: 'Notification marked as read' });
  } catch (error) {
    console.error('Error marking notification as read:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};