import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import styles from '../styles/components/RegisterPage.css';

function RegisterPage() {
  const [formData, setFormData] = useState({
    fullName: '',
    email: '',
    password: '',
    role: 'homeowner',
  });

  const navigate = useNavigate();

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    try {
      console.log('Registering user:', formData);
      navigate('/login');
    } catch (error) {
      console.error('Registration failed:', error);
    }
  };

  return (
    <div className={styles.registerContainer}>
      <form onSubmit={handleSubmit} className={styles.registerForm}>
        <h2>Create an Account</h2>

        <input
          type="text"
          name="fullName"
          placeholder="Full Name"
          value={formData.fullName}
          onChange={handleChange}
          required
        />

        <input
          type="email"
          name="email"
          placeholder="Email"
          value={formData.email}
          onChange={handleChange}
          required
        />

        <input
          type="password"
          name="password"
          placeholder="Password"
          value={formData.password}
          onChange={handleChange}
          required
        />

        <select name="role" value={formData.role} onChange={handleChange}>
          <option value="homeowner">Homeowner</option>
          <option value="cleaner">Cleaner</option>
          <option value="admin">Admin</option>
          <option value="manager">Platform Manager</option>
        </select>

        <button type="submit">Register</button>
        <p onClick={() => navigate('/login')} className={styles.loginLink}>
          Already have an account? Log in here
        </p>
      </form>
    </div>
  );
}

export default RegisterPage;
