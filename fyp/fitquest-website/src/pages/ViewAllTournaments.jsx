import React, { useState } from 'react';
import './ViewAllTournaments.css';
import ViewATournament from '../components/ViewATournament';

const dummyTournaments = [
  {
    id: 't001',
    number: 1,
    title: 'Summer Fitness ‘25',
    description: 'A 21-day all-round fitness event designed to help users stay active through summer heat — challenges include HIIT, mobility, and hydration tracking.',
    startDate: 'Jun 10, 2025',
    endDate: 'Jul 1, 2025',
    duration: '21 days',
    prize: 'Summer Edition FitQuest Shirt',
    status: 'ongoing',
  },
  {
    id: 't002',
    number: 2,
    title: 'HIIT HeatWave',
    description: 'A high-intensity 10-day burst to push stamina and speed. Perfect for users wanting a quick, sweaty transformation.',
    startDate: 'Jun 10, 2025',
    endDate: 'Jun 20, 2025',
    duration: '10 days',
    prize: 'FitQuest Gym Bag',
    status: 'completed',
  },
  {
    id: 't003',
    number: 3,
    title: 'FitBliz 30-day',
    description: 'A consistent, full-month challenge focused on balance: strength, cardio, flexibility — great for long-term goal setters.',
    startDate: 'Jun 10, 2025',
    endDate: 'July 10, 2025',
    duration: '30 days',
    prize: 'Badge Unlock',
    status: 'ongoing',
  },
  {
    id: 't004',
    number: 4,
    title: 'CoreClash',
    description: 'A consistent, full-month challenge focused on balance: strength, cardio, flexibility — great for long-term goal setters.',
    startDate: 'Jun 10, 2025',
    endDate: 'Jun 30, 2025',
    duration: '20 days',
    prize: 'Resistance Band',
    status: 'ongoing',
  },
  {
    id: 't005',
    number: 5,
    title: 'Stretch Surge',
    description: 'A 21-day all-round fitness event designed to help users stay active through summer heat — challenges include HIIT, mobility, and hydration tracking.',
    startDate: 'Jun 10, 2025',
    endDate: 'July 1, 2025',
    duration: '22 days',
    prize: 'Yoga Mat',
    status: 'ongoing',
  },
];

const ViewAllTournaments = () => {
  const [selectedTournament, setSelectedTournament] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');

  const filteredTournaments = dummyTournaments.filter(t =>
    t.title.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="all-users-container">
      <div className="page-title-with-search">
        <h2>All Tournaments</h2>
         <div className="search-bar-container">
          <input
            className="search-bar"
            type="text"
            placeholder="Search tournaments..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
          <button className="search-icon-btn">
            <img src="/icon-search.png" alt="Search" />
          </button>
        </div>
        <button
          className="upload-btn"
          onClick={() => window.location.href = '/create-tournament'}>
          + Create Tournament
        </button>
      </div>

      <table className="tournament-table">
        <thead>
          <tr>
            <th>No.</th>
            <th>Tournaments</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Duration</th>
            <th>Status</th>
            <th>Manage</th>
          </tr>
        </thead>
        <tbody>
          {dummyTournaments.map((tour) => (
            <tr key={tour.id} onClick={() => setSelectedTournament(tour)}>
              <td>{tour.number}</td>
              <td>{tour.title}</td>
              <td>{tour.startDate}</td>
              <td>{tour.endDate}</td>
              <td>{tour.duration}</td>
              <td>
                <span className={`badge ${tour.status.toLowerCase()}`}>
                  {tour.status}
                </span>
              </td>
              <td>
                <button className="edit-btn">Edit</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {selectedTournament && (
        <ViewATournament
          tournament={selectedTournament}
          onClose={() => setSelectedTournament(null)}
        />
      )}
    </div>
  );
};

export default ViewAllTournaments;
