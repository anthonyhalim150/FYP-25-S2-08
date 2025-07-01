import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import './SideBar.css';

const SideBar = () => {
  const [open, setOpen] = useState(true); // Sidebar always visible
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.clear();
    navigate('/');
  };

  return (
    <div className='sidebar-container'>
      <nav className="sidebar-nav">
        <Link to="/dashboard">Dashboard</Link>
        <Link to="/All-Users">All Users</Link>
        <Link to="/All-Tournaments">All Tournaments</Link>
        <Link to="/All-Feedbacks">All Feedbacks</Link>
      </nav>
    </div>
  );
};

export default SideBar;
