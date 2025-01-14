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
    console.log(`Deleting notification with id: ${id}`);
    const result = await Notification.deleteOne(id);
    console.log(`Delete result: ${result}`);
    if (result > 0) {
      res.status(200).json({ message: 'Notification deleted' });
    } else {
      res.status(404).json({ message: 'Notification not found' });
    }
  } catch (error) {
    console.error('Error deleting notification:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};