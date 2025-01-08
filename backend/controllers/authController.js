const connection = require('../models/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Gantilah 'your_jwt_secret_key' dengan secret key yang aman
const JWT_SECRET = 'imam123';

exports.login = async (req, res) => {
    const { username, password } = req.body;
    console.log(`Login attempt with username: ${username}`);
    try {
        const [rows] = await connection.execute('SELECT * FROM users WHERE username = ?', [username]);
        const user = rows[0];

        if (!user) {
            console.log('User not found');
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) {
            console.log('Invalid password');
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        const token = jwt.sign({ id: user.id, username: user.username }, JWT_SECRET, { expiresIn: '1h' });
        console.log('Login successful');
        res.json({ token });
    } catch (error) {
        console.error('Error during login:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};