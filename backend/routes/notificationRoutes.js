const express = require('express');
const jwt = require('jsonwebtoken');
const { getNotifications, markAsRead } = require('../controllers/notificationController');
const router = express.Router();

const JWT_SECRET = 'imam123'; // Gantilah dengan secret key yang aman

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (token == null) {
        console.log('No token provided');
        return res.sendStatus(401);
    }

    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) {
            console.log('Token verification failed:', err);
            return res.sendStatus(403);
        }
        req.user = user;
        next();
    });
};

router.get('/', authenticateToken, getNotifications);
router.put('/:id/read', authenticateToken, markAsRead);
router.delete('/:id', authenticateToken, markAsRead);

module.exports = router;