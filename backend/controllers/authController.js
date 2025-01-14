const jwt = require('jsonwebtoken');
const User = require('../models/userModel'); // Pastikan path ke model User benar

const generateAccessToken = (user) => {
  return jwt.sign(user, 'imam123', { expiresIn: '15m' }); // JWT berlaku selama 15 menit
};

const generateRefreshToken = (user) => {
  return jwt.sign(user, 'refreshSecret', { expiresIn: '7d' }); // Refresh token berlaku selama 7 hari
};

exports.login = async (req, res) => {
  const { username, password } = req.body;

  try {
    const user = await User.findOne(username);

    if (!user || !(await User.validPassword(password, user.password))) {
      return res.status(401).json({ message: 'Invalid username or password' });
    }

    const accessToken = generateAccessToken({ id: user.id, username: user.username });
    const refreshToken = generateRefreshToken({ id: user.id, username: user.username });

    res.json({
      accessToken,
      refreshToken,
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

exports.refreshToken = (req, res) => {
  const { token } = req.body;
  if (!token) return res.sendStatus(401);

  jwt.verify(token, 'refreshSecret', (err, user) => {
    if (err) return res.sendStatus(403);

    const accessToken = generateAccessToken({ id: user.id, username: user.username });
    res.json({ accessToken });
  });
};