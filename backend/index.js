const express = require('express');
const bodyParser = require('body-parser');
const morgan = require('morgan'); // Import Morgan
const authRoutes = require('./routes/authRoutes');
const reportRoutes = require('./routes/reportRoutes');
const notificationRoutes = require('./routes/notificationRoutes');
const authController = require('./controllers/authController');
const cors = require('cors'); // Import CORS
const path = require('path')

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors({
    origin: '*',
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE']
})); // Enable CORS
app.use(bodyParser.json());
app.use(morgan('dev')); // Enable Morgan for logging

// default
app.get('/', (req, res) => {
    res.send('Server is running');
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/reports', reportRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.post('/api/getUserByUsername', authController.getUserByUsername);

// Error handling middleware
app.use((err, req, res, next) => {
    console.error('Unhandled error:', err);
    res.status(500).json({ message: 'Internal server error' });
});

// Start Server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});