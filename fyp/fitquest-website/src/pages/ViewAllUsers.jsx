import React, { useState } from 'react';
import '../styles/Styles.css';
import ViewAUser from '../components/ViewAUser';
import NavigationBar from '../components/NavigationBar';

const ViewAllUsers = () => {
  const [selectedUser, setSelectedUser] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');

  const [dummyUsers, setDummyUsers] = useState([
    {
      id: 1,
      username: 'jacob123',
      email: 'jacob123@gmail.com',
      role: 'Free',
      level: 'Lvl. 12',
      isSuspended: false,
      preferences: {
        workout_frequency: '3x/week',
        fitness_goal: 'Lose fat',
        workout_time: 'Morning',
        fitness_level: 'Intermediate',
        injury: 'None'
      }
    },
    {
      id: 2,
      username: 'matildaHealth',
      email: 'matildaH@gmail.com',
      role: 'Premium',
      level: 'Lvl. 23',
      isSuspended: false,
      preferences: {
        workout_frequency: '5x/week',
        fitness_goal: 'Build muscle',
        workout_time: 'Evening',
        fitness_level: 'Beginner',
        injury: 'None'
      }
    },
    {
      id: 3,
      username: 'pitbull101',
      email: 'pitbull101@gmail.com',
      role: 'Premium',
      level: 'Lvl. 41',
      isSuspended: true,
      preferences: {
        workout_frequency: '2x/week',
        fitness_goal: 'Tone body',
        workout_time: 'Afternoon',
        fitness_level: 'Advanced',
        injury: 'Shoulder strain'
      }
    }
    // Add more users as needed
  ]);

  const filteredUsers = dummyUsers.filter(
    (u) =>
      u.username.toLowerCase().includes(searchTerm.toLowerCase()) ||
      u.email.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const toggleSuspend = (user) => {
    const updated = { ...user, isSuspended: !user.isSuspended };
    setDummyUsers((prev) =>
      prev.map((u) => (u.id === updated.id ? updated : u))
    );
  };

  return (
    <div className="all-users-container">
          <header className="admin-header">
      <img src="/white-logo.png" alt="FitQuest Logo" className="logo"/>
      <NavigationBar />
    </header>

      <div className="page-title-with-search">
        <h2 className="pixel-font">All Users</h2>
        <div className="search-bar-container" style={{ maxWidth: '400px' }}>
          <input
            type="text"
            placeholder="Search users by email or username..."
            className="search-bar"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
          <button className="search-icon-btn">
            <img src="/icon-search.png" alt="Search" />
          </button>
        </div>
      </div>

      <table className="users-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Email</th>
            <th>Account</th>
            <th>Level</th>
            <th>Manage</th>
          </tr>
        </thead>
        <tbody>
          {filteredUsers.map((user) => (
            <tr key={user.id} style={{ cursor: 'pointer' }} onClick={() => setSelectedUser(user)}>
              <td>{user.id}</td>
              <td>{user.username}</td>
              <td>{user.email}</td>
              <td>{user.role}</td>
              <td>{user.level}</td>
              <td>
                <div
                  style={{ display: 'flex', gap: '0.5rem', justifyContent: 'center' }}
                  onClick={(e) => e.stopPropagation()} // prevent triggering modal from button clicks
                >
                  <button className="view-btn" onClick={() => setSelectedUser(user)}>View</button>
                  <button
                    className={user.isSuspended ? 'unsuspend-btn' : 'suspend-btn'}
                    onClick={() => toggleSuspend(user)}
                  >
                    {user.isSuspended ? 'Unsuspend' : 'Suspend'}
                  </button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {selectedUser && (
        <ViewAUser
          user={selectedUser}
          onClose={() => setSelectedUser(null)}
        />
      )}
    </div>
  );
};

export default ViewAllUsers;
