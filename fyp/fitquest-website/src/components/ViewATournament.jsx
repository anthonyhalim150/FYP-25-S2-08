import React from 'react';
import '../styles/Styles.css';
import { useNavigate } from 'react-router-dom';



const ViewATournament = ({ tournament, onClose }) => {
    const navigate = useNavigate();

    if (!tournament) return null;

  return (
    <div className="view-tournament-modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()} style={{ backgroundColor: '#fff' }}>
        <button className="modal-close" onClick={onClose}>✕</button>
        <h2 className="pixel-font">Edit Tournament</h2>

        <label>Title*</label>
        <input type="text" value={tournament.title}  />

        <label>Description*</label>
        <textarea value={tournament.description} rows={4}  />

        <label>Date*</label>

        <div className="date-group-row">
          <span>Start date</span>
          <div className="date-time-inputs">
            <input type="date" value={tournament.startDate}  />
            <input type="time" value={tournament.startTime || '00:00'}  />
          </div>
        </div>

        <div className="date-group-row">
          <span>End date</span>
          <div className="date-time-inputs">
            <input type="date" value={tournament.endDate}  />
            <input type="time" value={tournament.endTime || '23:59'}  />
          </div>
        </div>

        <div className="form-row-2col">
          <div className="form-group-col">
            <label>Workout Category*</label>
            <select>
              <option>{tournament.category || 'All Workout'}</option>
            </select>
          </div>

          <div className="form-group-col">
            <label>Reward*</label>
            <select>
              <option>{tournament.prize || 'Reward A'}</option>
            </select>
          </div>
        </div>

        <div className="button-row">
        <button className="reject-btn" type="button" onClick={() => { onClose(); navigate('/All-Tournaments');}}>
        Cancel
        </button>
          <button className="save-btn">Save</button>
        </div>
      </div>
    </div>
  );
};

export default ViewATournament;
