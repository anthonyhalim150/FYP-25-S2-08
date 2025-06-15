// AllUsersPage.jsx
import React, { useState } from 'react';
import '../styles/Styles.css';

const dummyUsers = [
  {
    id: 1,
    username: 'matilda',
    email: 'matilda@gmail.com',
    role: 'admin',
    tokens: 50,
    method: 'database',
    preferences: {
      workout_frequency: '3x/week',
      fitness_goal: 'Lose fat',
      workout_time: 'Morning',
      fitness_level: 'Intermediate',
      injury: 'Knee pain'
    }
  },
  {
    id: 2,
    username: 'jacob',
    email: 'jacob@gmail.com',
    role: 'user',
    tokens: 15,
    method: 'google',
    preferences: {
      workout_frequency: 'Daily',
      fitness_goal: 'Build muscle',
      workout_time: 'Evening',
      fitness_level: 'Beginner',
      injury: 'None'
    }
  },
  {
    id: 3,
    username: 'alisa',
    email: 'alisa@gmail.com',
    role: 'premium',
    tokens: 120,
    method: 'apple',
    preferences: {
      workout_frequency: '2x/week',
      fitness_goal: 'Tone body',
      workout_time: 'Afternoon',
      fitness_level: 'Advanced',
      injury: 'Shoulder strain'
    }
  }
];

const AllUsersPage = () => {
  const [selectedUser, setSelectedUser] = useState(null);

  return (
    <div className="all-users-container">
      <header>
        <img src="/white-logo.png" alt="FitQuest Logo" className="logo" />
        <nav>
          <a href="/">Dashboard</a>
        </nav>
      </header>
      <div className="page-title">
        <h2>All Users</h2>
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
            <th>Preferences</th>
          </tr>
        </thead>
        <tbody>
          {dummyUsers.map((user) => (
            <tr key={user.id}>
              <td>{user.id}</td>
              <td>{user.username}</td>
              <td>{user.email}</td>
              <td>{user.role}</td>
              <td>{user.method}</td>
              <td>{user.tokens}</td>
              <td>
                <button
                  className="view-btn"
                  onClick={() => setSelectedUser(user)}
                >
                  View
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {selectedUser && (
        <div className="preferences-modal">
          <div className="modal-content">
            <h3>Preferences for {selectedUser.username}</h3>
            <ul>
              <li><strong>Frequency:</strong> {selectedUser.preferences.workout_frequency}</li>
              <li><strong>Goal:</strong> {selectedUser.preferences.fitness_goal}</li>
              <li><strong>Time:</strong> {selectedUser.preferences.workout_time}</li>
              <li><strong>Level:</strong> {selectedUser.preferences.fitness_level}</li>
              <li><strong>Injury:</strong> {selectedUser.preferences.injury}</li>
            </ul>
            <button className="close-btn" onClick={() => setSelectedUser(null)}>Close</button>
          </div>
        </div>
      )}
    </div>
  );
};

export default AllUsersPage;
