// UserModal.jsx
import React from 'react';
import '../styles/Styles.css';

const UserModal = ({ user, onClose }) => {
  if (!user) return null;

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={e => e.stopPropagation()}>
        <button className="modal-close" onClick={onClose}>✕</button>
        
          {/* Left Panel: Personal Info */}
          <div className="user-left-panel">
            {/* <img src={user.avatar} alt="User Avatar" className="user-avatar-large" /> */}
            <img
              src={user.avatar || `/icon-avatar${(user.id % 6 || 6)}.png`}
              alt="User Avatar"
              className="user-avatar-large"
            />

            <h2>{user.username}</h2>
            <p><strong>Email:</strong> {user.email}</p>
            <p><strong>Role:</strong> {user.role}</p>
            <p><strong>Login Method:</strong> {user.method}</p>
            <p><strong>Tokens:</strong> {user.tokens}</p>
          </div>

          {/* Right Panel: Preferences */}
          <div className="user-right-panel">
            <h3>User Preferences</h3>
            <ul>
              <li><strong>Workout Frequency:</strong> {user.preferences.workout_frequency}</li>
              <li><strong>Fitness Goal:</strong> {user.preferences.fitness_goal}</li>
              <li><strong>Workout Time:</strong> {user.preferences.workout_time}</li>
              <li><strong>Fitness Level:</strong> {user.preferences.fitness_level}</li>
              <li><strong>Injury:</strong> {user.preferences.injury}</li>
            </ul>
          </div>
        
      </div>
    </div>
  );
};

export default UserModal;
