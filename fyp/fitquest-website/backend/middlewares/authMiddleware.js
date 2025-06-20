const jwt = require('jsonwebtoken');
const JWT_SECRET = process.env.JWT_SECRET || 'fitquest-secret-key';

const authenticateUser = (req, res, next) => {
  const token = req.cookies?.session || req.headers['authorization']?.split(' ')[1];
  if (!token) {
    return res.status(401).json({ message: 'No session token' });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(401).json({ message: 'Invalid session' });
  }
};

module.exports = authenticateUser;