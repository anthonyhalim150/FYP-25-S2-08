import React from 'react';
import '../styles/Styles.css'; // Import general styles
import './CreateTournament.css'; // Import CreateTournament-specific styles
import { useNavigate } from 'react-router-dom';

const CreateTournament = () => {
  const navigate = useNavigate();

  return (
    <div className="admin-container">
      <div className="user-content">
        <div className="create-tournament-content">
          <div className="user-header-row">
            <h2>Create New Tournament</h2>
          </div>

          <form className="create-tournament-form">
            <label>Title*</label>
            <input type="text" placeholder="Enter title here..." required />

            <label>Description*</label>
            <textarea placeholder="Enter description here..." rows={4} required />

            <label>Date*</label>
            <div className="input-date-time">
              <input type="date" placeholder="DD/MM/YYYY" required />
              <input type="time" placeholder="HH:MM" required />
            </div>

            <label>End Date</label>
            <div className="input-date-time">
              <input type="date" placeholder="DD/MM/YYYY" />
              <input type="time" placeholder="HH:MM" />
            </div>

            <label>Workout Category*</label>
            <select required>
              <option>Select a workout category</option>
              {/* Add workout categories here */}
            </select>

            <label>Reward*</label>
            <select required>
              <option>Select the reward badge</option>
              {/* Add reward options here */}
            </select>

            <div className="button-row">
              <button
                className="cancel-btn"
                type="button"
                onClick={() => navigate('/ViewAllTournaments')}
              >
                Cancel
              </button>
              <button className="create-btn" type="submit">
                Create
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default CreateTournament;
