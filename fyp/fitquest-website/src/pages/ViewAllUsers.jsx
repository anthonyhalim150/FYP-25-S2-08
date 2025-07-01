import React, { useState } from 'react';
import '../styles/Styles.css';
import './ViewAllUsers.css';
import SideBar from '../components/SideBar.jsx';
import PageLayout from '../components/PageLayout.jsx';
import NavigationBar from '../components/NavigationBar.jsx';

const ViewAllUsers = () => {
  const [selectedTab, setSelectedTab] = useState('All');
  const [searchTerm, setSearchTerm] = useState('');

  const dummyUsers = [
    { id: 1, username: 'jacob123', email: 'jacob123@gmail.com', role: 'Free', level: 'Lvl. 12', isSuspended: false },
    { id: 2, username: 'matildaHealth', email: 'matildaH@gmail.com', role: 'Premium', level: 'Lvl. 23', isSuspended: false },
    { id: 3, username: 'pitbull101', email: 'pitbull101@gmail.com', role: 'Premium', level: 'Lvl. 41', isSuspended: true },    
    { id: 4, username: 'jacob123', email: 'jacob123@gmail.com', role: 'Free', level: 'Lvl. 12', isSuspended: false },
    { id: 5, username: 'matildaHealth', email: 'matildaH@gmail.com', role: 'Premium', level: 'Lvl. 23', isSuspended: false },
    { id: 6, username: 'pitbull101', email: 'pitbull101@gmail.com', role: 'Premium', level: 'Lvl. 41', isSuspended: true },
  ];

  const filteredUsers = dummyUsers.filter((user) => {
    if (selectedTab === 'Suspended' && !user.isSuspended) return false;
    if (selectedTab === 'Active' && user.isSuspended) return false;
    return user.username.toLowerCase().includes(searchTerm.toLowerCase());
  });

  return (
    
    <PageLayout>

    <div className="admin-container">
      <SideBar />
      <div className="user-content">
        <div className="user-header">
          <h2>All Users</h2>
          <div className="header-row">
            <div className="user-tabs-container">
              {['All', 'Active', 'Suspended'].map((tab) => (
                <div
                  key={tab}
                  className={`user-tab ${selectedTab === tab ? 'active' : ''}`}
                  onClick={() => setSelectedTab(tab)}
                >
                  {tab}
                </div>
              ))}
            </div>

          <div className="search-bar-container" style={{ maxWidth: '400px' }}>
          <input
            type="text"
            placeholder="Search feedback by email or words ..."
            className="search-bar"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
          <button className="search-icon-btn">
            <img src="/icon-search.png" alt="Search" />
          </button>
        </div>
          </div>
        </div>

        <table className="users-table">
          <thead>
            <tr>
              <th>Username</th>
              <th>Email</th>
              <th>Role</th>
              <th>Level</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {filteredUsers.map((user) => (
              <tr key={user.id}>
                <td>{user.username}</td>
                <td>{user.email}</td>
                <td>{user.role}</td>
                <td>{user.level}</td>
                <td>
                  <span className={`status-badge ${user.isSuspended ? 'suspended' : 'active'}`}>
                    {user.isSuspended ? 'Suspended' : 'Active'}
                  </span>
                </td>
                <td>
                  <button className="view-btn">View</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>

    </PageLayout>
  );
};

export default ViewAllUsers;