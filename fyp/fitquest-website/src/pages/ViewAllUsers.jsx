import React, { useState, useEffect } from 'react';
import '../styles/Styles.css';
import './ViewAllUsers.css';
import PageLayout from '../components/PageLayout.jsx';
import ViewAUser from '../components/ViewAUser.jsx';
import { fetchAllUsers } from '../services/userService';

const ViewAllUsers = () => {
  const [selectedTab, setSelectedTab] = useState('All');
  const [selectedUser, setSelectedUser] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [fetchError, setFetchError] = useState('');

  useEffect(() => {
    setLoading(true);
    setFetchError('');
    fetchAllUsers()
      .then(data => {
        setUsers(data);
        setLoading(false);
      })
      .catch(() => {
        setUsers([]);
        setLoading(false);
        setFetchError('Could not fetch users');
      });
  }, []);

  const filteredUsers = users.filter((user) => {
    if (selectedTab === 'Suspended' && !user.isSuspended) return false;
    if (selectedTab === 'Active' && user.isSuspended) return false;
    return user.username.toLowerCase().includes(searchTerm.toLowerCase());
  });

  return (
    <PageLayout>
      <div className="admin-container">
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
              <div className="search-bar-container">
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
          {loading ? (
            <div className="loading-text">Loading users...</div>
          ) : fetchError ? (
            <div className="error-text">{fetchError}</div>
          ) : (
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
                  <tr key={user.id} onClick={() => setSelectedUser(user)} style={{ cursor: 'pointer' }}>
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
          )}
          {selectedUser && (
            <ViewAUser user={selectedUser} onClose={() => setSelectedUser(null)} />
          )}
        </div>
      </div>
    </PageLayout>
  );
};

export default ViewAllUsers;