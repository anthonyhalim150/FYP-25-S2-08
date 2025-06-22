import React from 'react';
import '../styles/Styles.css';
import NavigationBar from '../components/NavigationBar';
import { useNavigate } from 'react-router-dom';

const CreateTournament = () => {
  const navigate = useNavigate();

  return (
    <div className="all-users-container">
          <header className="admin-header">
      <img src="/white-logo.png" alt="FitQuest Logo" className="logo"/>
      <NavigationBar />
    </header>

      <div className="page-title-with-search">
        <h2 className="pixel-font">Create New Tournament</h2>
      </div>

      <form className="modal-content" style={{ backgroundColor: 'white' }}>
        <label>Title*</label>
        <input type="text" placeholder="Enter title here..." />

        <label>Description*</label>
        <textarea placeholder="Enter description here..." rows={4} />

        <label>Date*</label>
        <div style={{ display: 'flex', gap: '1rem' }}>
          <input type="date" placeholder="DD/MM/YYYY" />
          <input type="time" placeholder="HH:MM" />
        </div>

        <label>End Date</label>
        <div style={{ display: 'flex', gap: '1rem' }}>
          <input type="date" placeholder="DD/MM/YYYY" />
          <input type="time" placeholder="HH:MM" />
        </div>

        <label>Workout Category*</label>
        <select>
          <option>Select a workout category</option>
        </select>

        <label>Reward*</label>
        <select>
          <option>Select the reward badge</option>
        </select>

        <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '1.5rem' }}>
          <button className="reject-btn" type="button" onClick={() => navigate('/All-Tournaments')}>
            Cancel
          </button>
          <button className="upload-btn">Create</button>
        </div>
      </form>
    </div>
  );
};

export default CreateTournament;
