const express = require('express');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const authRoutes = require('./routes/authRoutes');
const reportRoutes = require('./routes/reportRoutes');
const notificationRoutes = require('./routes/notificationRoutes');
const authController = require('./controllers/authController'); // Pastikan path ke controller benar
const cors = require('cors');
const path = require('path');
const db = require('./models/db');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors({
    origin: '*',
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE']
}));
app.use(bodyParser.json());
app.use(morgan('dev'));

// default
app.get('/', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM users');
        if (rows.length > 0) {
            res.status(200).json({
                message: 'Data fetched successfully',
                data: rows
            });
        } else {
            res.status(404).json({
                message: 'No data found'
            });
        }
    } catch (err) {
        console.error('Error fetching data from database:', err);
        res.status(500).json({
            message: 'Failed to fetch data from database',
            error: err.message
        });
    }
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api', authRoutes);
app.use('/api/reports', reportRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.post('/api/getUserByUsername', authController.getUserByUsername); // Pastikan fungsi ini ada di authController

// Error handling middleware
app.use((err, req, res, next) => {
    console.error('Unhandled error:', err);
    res.status(500).json({ message: 'Internal server error' });
});

// Start Server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});