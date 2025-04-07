import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import '../styles/components/RegisterPage.css';

function LoginPage() {
  const [formData, setFormData] = useState({
    email: '',
    password: '',
  });

  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();

    // Simulate login
    const user = {
      fullName: 'Test User',
      email: formData.email,
      role: 'homeowner', // simulate role
    };

    // Save user to localStorage
    localStorage.setItem('user', JSON.stringify(user));

    // Redirect to dashboard
    navigate('/dashboard');
  };

  return (
    <div className="registerContainer">
      <form onSubmit={handleSubmit} className="registerForm">
        <h2>Login</h2>

        <input
          type="email"
          name="email"
          placeholder="Email"
          value={formData.email}
          onChange={(e) => setFormData({ ...formData, email: e.target.value })}
          required
        />

        <input
          type="password"
          name="password"
          placeholder="Password"
          value={formData.password}
          onChange={(e) => setFormData({ ...formData, password: e.target.value })}
          required
        />

        <button type="submit">Login</button>
        <p onClick={() => navigate('/register')} className="loginLink">
          Don't have an account? Register here
        </p>
      </form>
    </div>
  );
}

export default LoginPage;
