const sanitizeInput = (input) => {
    if (typeof input !== 'string') return '';
    return input.trim().replace(/<[^>]*>?/gm, ''); 
  };
  
const isValidEmail = (email) => {
    const sanitized = sanitizeInput(email);
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(sanitized) ? sanitized : null;
  };
  
const isValidPassword = (password) => {
    const sanitized = sanitizeInput(password);
    return sanitized.length >= 6 ? sanitized : null;
  };
  
module.exports = {
    sanitizeInput,
    isValidEmail,
    isValidPassword
  };
  