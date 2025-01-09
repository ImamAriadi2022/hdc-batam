const express = require('express');
const multer = require('multer');
const jwt = require('jsonwebtoken');
const { getAllReports, createReport, updateReport, deleteReport } = require('../controllers/reportController');
const router = express.Router();

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

const JWT_SECRET = 'imam123'; // Gantilah dengan secret key yang aman

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (token == null) return res.sendStatus(401);

    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) return res.sendStatus(403);
        req.user = user;
        next();
    });
};

router.get('/', authenticateToken, getAllReports);
router.post('/', authenticateToken, upload.single('imageFile'), createReport);
router.put('/:id', authenticateToken, upload.single('imageFile'), updateReport); // Endpoint untuk update laporan
router.delete('/:id', authenticateToken, deleteReport); // Endpoint untuk delete laporan

module.exports = router;