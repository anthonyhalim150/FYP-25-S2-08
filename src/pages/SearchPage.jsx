import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';

function SearchPage() {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {

    const allCleaners = [
      { id: 1, name: 'Maria Lopez', specialty: 'Deep Clean' },
      { id: 2, name: 'James Tan', specialty: 'Weekly Cleaning' },
      { id: 3, name: 'Fatimah Ali', specialty: 'Move-Out Cleaning' },
    ];
    setResults(allCleaners);
  }, []);

  const handleSearch = (e) => {
    e.preventDefault();

    const filtered = results.filter((c) =>
      c.name.toLowerCase().includes(query.toLowerCase()) ||
      c.specialty.toLowerCase().includes(query.toLowerCase())
    );
    setResults(filtered);
  };

  const viewProfile = (id) => {
    navigate(`/cleaner/${id}`);
  };

  return (
    <div style={{ padding: '2rem' }}>
      <h2>Find a Cleaner</h2>

      <form onSubmit={handleSearch} style={{ marginBottom: '1rem' }}>
        <input
          type="text"
          placeholder="Search by name or service..."
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          style={{ padding: '0.5rem', width: '250px' }}
        />
        <button type="submit" style={{ padding: '0.5rem 1rem', marginLeft: '0.5rem' }}>
          Search
        </button>
      </form>

      <ul>
        {results.map((cleaner) => (
          <li key={cleaner.id} style={{ marginBottom: '1rem' }}>
            <strong>{cleaner.name}</strong> — {cleaner.specialty}
            <button
              onClick={() => viewProfile(cleaner.id)}
              style={{ marginLeft: '1rem', padding: '0.3rem 0.8rem' }}
            >
              View Profile
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default SearchPage;
