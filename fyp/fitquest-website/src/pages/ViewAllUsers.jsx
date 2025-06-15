import React, { useState } from 'react';
import '../styles/Styles.css';
import ViewAUser from '../components/ViewAUser';

const ViewAllUsers = () => {
  const [selectedUser, setSelectedUser] = useState(null);

  const dummyUsers = [
    {
      id: 1,
      username: 'matilda',
      email: 'matilda@gmail.com',
      role: 'admin',
      tokens: 50,
      method: 'database',
      avatar: '/icon-avatar1.png',
      preferences: {
        workout_frequency: '3x/week',
        fitness_goal: 'Lose fat',
        workout_time: 'Morning',
        fitness_level: 'Intermediate',
        injury: 'Knee pain',
      },
    },
    {
      id: 2,
      username: 'jacob',
      email: 'jacob@gmail.com',
      role: 'user',
      tokens: 15,
      method: 'google',
      avatar: '/icon-avatar2.png',
      preferences: {
        workout_frequency: 'Daily',
        fitness_goal: 'Build muscle',
        workout_time: 'Evening',
        fitness_level: 'Beginner',
        injury: 'None',
      },
    },
    {
      id: 3,
      username: 'alisa',
      email: 'alisa@gmail.com',
      role: 'premium',
      tokens: 120,
      method: 'apple',
      avatar: '/icon-avatar3.png',
      preferences: {
        workout_frequency: '2x/week',
        fitness_goal: 'Tone body',
        workout_time: 'Afternoon',
        fitness_level: 'Advanced',
        injury: 'Shoulder strain',
      },
    },
  ];

  return (
    <div className="all-users-container">
      <header>
        <img src="/white-logo.png" alt="FitQuest Logo" className="logo" />
        <nav>
          <a href="/dashboard">Dashboard</a>
        </nav>
      </header>

      <div className="page-title-with-search">
        <h2>All Users</h2>
        <div className="search-bar-container">
          <input type="text" placeholder="Search users..." className="search-bar" />
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
            <th>Role</th>
            <th>Method</th>
            <th>Tokens</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {dummyUsers.map(user => (
            <tr key={user.id} onClick={() => setSelectedUser(user)} style={{ cursor: 'pointer' }}>
              <td>{user.id}</td>
              <td>{user.username}</td>
              <td>{user.email}</td>
              <td>{user.role}</td>
              <td>{user.method}</td>
              <td>{user.tokens}</td>
              <td>
                <button className="view-btn">View</button>
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
