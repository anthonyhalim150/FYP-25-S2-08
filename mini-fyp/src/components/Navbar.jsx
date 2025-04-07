import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import '../styles/components/Navbar.css';

function Navbar() {
  const navigate = useNavigate();
  const user = JSON.parse(localStorage.getItem('user'));

  const handleLogout = () => {
    localStorage.removeItem('user');
    navigate('/login');
  };

  return (
    <nav className="navbar">
      <div className="navbar-brand">CleanMatch</div>
      <ul className="navbar-links">
        {user && user.role === 'homeowner' && (
          <>
            <li><Link to="/search">Search</Link></li>
            <li><Link to="/shortlist">Shortlist</Link></li>
          </>
        )}

        {user && user.role === 'cleaner' && (
          <li><Link to="/match-history">Match History</Link></li>
        )}

        {user && user.role === 'manager' && (
          <li><Link to="/reports">Reports</Link></li>
        )}

        {user && (
          <>
            <li><Link to="/dashboard">Dashboard</Link></li>
            <li><button onClick={handleLogout}>Logout</button></li>
          </>
        )}

        {!user && (
          <>
            <li><Link to="/login">Login</Link></li>
            <li><Link to="/register">Register</Link></li>
          </>
        )}
      </ul>
    </nav>
  );
}

export default Navbar;
