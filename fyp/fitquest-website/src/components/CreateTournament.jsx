import React, { useState } from 'react';
import '../styles/Styles.css';
import './CreateTournament.css';
import { useNavigate } from 'react-router-dom';
import { createTournament } from '../services/tournamentService';

const CreateTournament = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    startDate: '',
    endDate: '',
    features: [],
    target_exercise_pattern: ''
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await createTournament(formData);
      navigate('/All-Tournaments');
    } catch (err) {
      console.error('Failed to create tournament', err);
    }
  };

  return (
    <div className="admin-container">
      <div className="user-content">
        <div className="create-tournament-content">
          <div className="user-header-row">
            <h2>Create New Tournament</h2>
          </div>

          <form className="create-tournament-form" onSubmit={handleSubmit}>
            <label>Title*</label>
            <input
              type="text"
              value={formData.title}
              onChange={(e) => setFormData({ ...formData, title: e.target.value })}
              required
            />

            <label>Description*</label>
            <textarea
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              rows={4}
              required
            />

            <label>Start Date*</label>
            <input
              type="datetime-local"
              value={formData.startDate}
              onChange={(e) => setFormData({ ...formData, startDate: e.target.value })}
              required
            />

            <label>End Date*</label>
            <input
              type="datetime-local"
              value={formData.endDate}
              onChange={(e) => setFormData({ ...formData, endDate: e.target.value })}
              required
            />

            <label>Target Exercise Pattern*</label>
            <input
              type="text"
              placeholder="e.g. push up, squat"
              value={formData.target_exercise_pattern}
              onChange={(e) => setFormData({ ...formData, target_exercise_pattern: e.target.value })}
              required
            />

            <div className="button-row">
              <button
                className="cancel-btn"
                type="button"
                onClick={() => navigate('/All-Tournaments')}
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
