import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';

function Dashboard() {
  const [user, setUser] = useState(null);
  const navigate = useNavigate();

 
  useEffect(() => {
    const userData = JSON.parse(localStorage.getItem('user'));
    if (!userData) {
      navigate('/login');
    } else {
      setUser(userData);
    }
  }, [navigate]);

  if (!user) return null;

  return (
    <div style={{ padding: '2rem' }}>
      <h2>Welcome back, {user.fullName || 'User'}!</h2>
      <p>You are logged in as <strong>{user.role}</strong>.</p>

      {user.role === 'homeowner' && <p>Start browsing cleaners now!</p>}
      {user.role === 'cleaner' && <p>Manage your services and check your views.</p>}
      {user.role === 'manager' && <p>View system reports and manage categories.</p>}
      {user.role === 'admin' && <p>Admin dashboard and user management here.</p>}
    </div>
  );
}

export default Dashboard;
