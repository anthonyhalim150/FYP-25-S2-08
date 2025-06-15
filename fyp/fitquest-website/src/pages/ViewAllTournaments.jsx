import React, { useState } from 'react';
import '../styles/Styles.css'; // Use your existing style

const dummyTournaments = [
  {
    id: 't001',
    title: 'Summer Fitness Challenge',
    description: 'A 4-week fitness tournament for all users.',
    startDate: '2024-07-01',
    endDate: '2024-07-31',
    prize: 'Summer Edition FitQuest Shirt',
    status: 'Upcoming',
  },
  {
    id: 't002',
    title: 'Muscle Madness',
    description: 'Push your limits in this 2-week strength challenge!',
    startDate: '2024-06-01',
    endDate: '2024-06-15',
    prize: 'FitQuest Gym Bag',
    status: 'Completed',
  },
];

const ViewAllTournaments = () => {
  const [selectedTournament, setSelectedTournament] = useState(null);

  return (
    <div className="all-users-container">
      <header>
        <img src="/white-logo.png" alt="FitQuest Logo" className="logo" />
        <nav><a href="/dashboard">Dashboard</a></nav>
      </header>

      <div className="page-title-with-search">
        <h2>All Tournaments</h2>
        <button
          className="upload-btn"
          onClick={() => console.log('Create New Tournament')}
        >
          + Create Tournament
        </button>
      </div>

      <table className="users-table">
        <thead>
          <tr>
            <th>Title</th>
            <th>Duration</th>
            <th>Status</th>
            <th>Prize</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {dummyTournaments.map(tour => (
            <tr key={tour.id} onClick={() => setSelectedTournament(tour)}>
              <td>{tour.title}</td>
              <td>{tour.startDate} → {tour.endDate}</td>
              <td><span className={`badge ${tour.status.toLowerCase()}`}>{tour.status}</span></td>
              <td>{tour.prize}</td>
              <td>
                <button className="edit-btn">Edit</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {/* Placeholder for modal/panel */}
      {selectedTournament && (
        <div className="modal-overlay">
          <div className="modal-content">
            <h3>{selectedTournament.title}</h3>
            <p>{selectedTournament.description}</p>
            <p>Duration: {selectedTournament.startDate} to {selectedTournament.endDate}</p>
            <p>Prize: {selectedTournament.prize}</p>
            <button onClick={() => console.log("Edit tournament logic here")}>Save Changes</button>
            <button onClick={() => setSelectedTournament(null)}>Close</button>
          </div>
        </div>
      )}
    </div>
  );
};

export default ViewAllTournaments;
