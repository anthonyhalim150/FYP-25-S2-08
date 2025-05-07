const jwt = require('jsonwebtoken');
const JWT_SECRET = process.env.JWT_SECRET; 

exports.setCookie = (res, email) => {
  const token = jwt.sign({ email }, JWT_SECRET, { expiresIn: '1d' });

  res.cookie('session', token, {
    httpOnly: true,
    secure: false, 
    sameSite: 'Lax',
    maxAge: 24 * 60 * 60 * 1000,
  });
};
