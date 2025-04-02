import React, { useState, useEffect } from 'react';
import '../styles/components/MatchHistoryPage.css';

function MatchHistoryPage() {
  const [matches, setMatches] = useState([]);
  const [filter, setFilter] = useState('');

  useEffect(() => {
    // Simulated data fetch
    const history = [
      { id: 1, service: 'Deep Clean', date: '2025-03-15' },
      { id: 2, service: 'Weekly Cleaning', date: '2025-03-20' },
      { id: 3, service: 'Move-Out Cleaning', date: '2025-04-01' },
    ];
    setMatches(history);
  }, []);

  const filtered = matches.filter((m) =>
    m.service.toLowerCase().includes(filter.toLowerCase())
  );

  return (
    <div className="matchHistoryContainer">
      <h2>Confirmed Match History</h2>
      <input
        type="text"
        placeholder="Filter by service..."
        value={filter}
        onChange={(e) => setFilter(e.target.value)}
        className="matchFilter"
      />
      <ul className="matchList">
        {filtered.map((m) => (
          <li key={m.id} className="matchItem">
            <strong>{m.service}</strong> — <span>{m.date}</span>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default MatchHistoryPage;
