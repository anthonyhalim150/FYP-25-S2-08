import React, { useState } from 'react';
import './ViewAllTournaments.css';
import ViewATournament from '../components/ViewATournament';
import PageLayout from '../components/PageLayout';

const dummyTournaments = [
  { id: 't001', number: 1, title: 'Summer Fitness ‘25', startDate: 'Jun 10, 2025', endDate: 'Jul 1, 2025', duration: '21 days', prize: 'Shirt', status: 'ongoing' },
  { id: 't002', number: 2, title: 'HIIT HeatWave', startDate: 'Jun 10, 2025', endDate: 'Jun 20, 2025', duration: '10 days', prize: 'Gym Bag', status: 'completed' },
  { id: 't003', number: 3, title: 'FitBliz 30-day', startDate: 'Jun 10, 2025', endDate: 'Jul 10, 2025', duration: '30 days', prize: 'Badge', status: 'ongoing' },
  { id: 't004', number: 4, title: 'CoreClash', startDate: 'Jun 10, 2025', endDate: 'Jun 30, 2025', duration: '20 days', prize: 'Band', status: 'ongoing' },
  { id: 't005', number: 5, title: 'Stretch Surge', startDate: 'Jun 10, 2025', endDate: 'Jul 1, 2025', duration: '22 days', prize: 'Yoga Mat', status: 'ongoing' },
];

const ViewAllTournaments = () => {
  const [selectedTournament, setSelectedTournament] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedTab, setSelectedTab] = useState('All');

  const filteredTournaments = dummyTournaments.filter((t) => {
    const matchesSearch = t.title.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesTab =
      selectedTab === 'All' || t.status.toLowerCase() === selectedTab.toLowerCase();
    return matchesSearch && matchesTab;
  });

  return (
    <PageLayout>
      <div className="admin-container">
        <div className="user-content">
         <div className="user-header-row">
  <h2>All Tournaments</h2>
  <div className="header-row">
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

  </div>
</div>

<div className="tab-and-create-row">
  <div className="user-tabs-container">
    {['All', 'Ongoing', 'Completed'].map((tab) => (
      <div
        key={tab}
        className={`user-tab ${selectedTab === tab ? 'active' : ''}`}
        onClick={() => setSelectedTab(tab)}
      >
        {tab}
      </div>
    ))}
  </div>
  <button
    className="create-btn"
    onClick={() => window.location.href = '/create-tournament'}
  >
    + Create New Tournament
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
              {filteredTournaments.map((tour) => (
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
            <div className="tournament-modal-overlay" onClick={() => setSelectedTournament(null)}>
              <div className="tournament-modal-content" onClick={(e) => e.stopPropagation()}>
                <ViewATournament
                  tournament={selectedTournament}
                  onClose={() => setSelectedTournament(null)}
                />
              </div>
            </div>
          )}
        </div>
      </div>
    </PageLayout>
  );
};

export default ViewAllTournaments;
