import React from 'react';
import '../styles/Styles.css';

const ViewAUser = ({ user, onClose }) => {
  if (!user) return null;

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content user-modal-split" onClick={(e) => e.stopPropagation()}>
        <button className="modal-close" onClick={onClose}>✕</button>

        {/* Left Yellow Panel */}
        <div className="user-info-panel">
          <img
            src={user.avatar || `/icon-avatar${(user.id % 6 || 6)}.png`}
            alt="User Avatar"
            className="user-avatar-large"
          />
          <h2>{user.username}</h2>
          <p><strong>First Name:</strong> {user.first_name}</p>
          <p><strong>Last Name:</strong> {user.last_name}</p>
          <p><strong>Date of Birth:</strong> {user.dob}</p>
          <p><strong>Email:</strong> {user.email}</p>
          <p><strong>Account:</strong> {user.account}</p>
          <p><strong>Level:</strong> {user.level}</p>

          <button className="edit-btn">Edit</button>
        </div>

        {/* Right Preferences Panel */}
        <div className="user-preferences-panel">
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

export default ViewAUser;
