const jwt = require('jsonwebtoken');
const User = require('../models/userModel'); // Pastikan path ke model User benar

exports.login = async (req, res) => {
  const { username, password } = req.body;

  try {
    const user = await User.findOne(username);

    if (!user || !(await User.validPassword(password, user.password))) {
      return res.status(401).json({ message: 'Invalid username or password' });
    }

    const token = jwt.sign({ id: user.id, username: user.username }, 'imam123', { expiresIn: '1h' });

    res.json({
      token,
      user: {
        id: user.id,
        username: user.username
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};